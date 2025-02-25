import 'package:farmlink/officer/officer_notice_add_screen.dart';
import 'package:farmlink/officer/officer_notice_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseurl = 'https://287e-2409-4073-483-7171-9ce9-18ff-1781-65e7.ngrok-free.app';

class OfficerNoticeScreen extends StatefulWidget {
  @override
  _OfficerNoticeScreenState createState() => _OfficerNoticeScreenState();
}

class _OfficerNoticeScreenState extends State<OfficerNoticeScreen> {
  List<dynamic> _notices = [];
  List<dynamic> _filteredNotices = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNotices();
    _searchController.addListener(_filterNotices);
  }

  Future<void> _fetchNotices() async {
    final response = await http.get(Uri.parse('$baseurl/GetNoticesView/'));

    if (response.statusCode == 200) {
      setState(() {
        print(response.body);
        _notices = jsonDecode(response.body);
        _filteredNotices = _notices;
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load notices')),
      );
    }
  }

  void _filterNotices() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredNotices = _notices.where((notice) {
        String title = notice['title'].toLowerCase();
        String description = notice['description'].toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(236, 215, 228, 212),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 116, 140, 107),
          title: Text(
            "Notices",
            style: GoogleFonts.poppins(
              fontSize: 23,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search notices...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: const Color.fromARGB(255, 116, 140, 107)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredNotices.isEmpty
                      ? Center(child: Text('No notices found'))
                      : ListView.builder(
                          itemCount: _filteredNotices.length,
                          itemBuilder: (context, index) {
                            var notice = _filteredNotices[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: ListTile(
                                tileColor: const Color.fromARGB(235, 204, 215, 202),
                                title: Text(
                                  notice['title'],
                                  style: TextStyle(fontWeight: FontWeight.normal),
                                ),
                                subtitle: Text(notice['description']),
                                trailing: Text(
                                  (notice['date'] != null && notice['date'].contains('T'))
                                      ? notice['date'].split('T')[0] // Extract YYYY-MM-DD
                                      : 'No Date',
                                  style: TextStyle(color: const Color.fromARGB(255, 118, 115, 115)),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NoticeDetailScreen(noticeId: 8,),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OfficerNoticeAddScreen()),
            );
          },
          backgroundColor: const Color.fromARGB(255, 116, 140, 107),
          child: Icon(Icons.add, color: Colors.white),
          tooltip: 'Add Notice',
        ),
      ),
    );
  }
}