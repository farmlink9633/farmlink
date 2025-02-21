import 'package:farmlink/officer/officer_notice_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


const String baseurl = 'https://9a0e-117-196-58-124.ngrok-free.app';

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212) ,
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        title: Text(
          "Notices",
          style: GoogleFonts.poppins(
          fontSize: 28),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Notices...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
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
                              tileColor: const Color.fromARGB(236, 215, 228, 212) ,
                              title: Text(
                                notice['title'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(notice['description']),
                              trailing: Text(
                                          (notice['date'] != null && notice['date'].contains('T'))
                                             ? notice['date'].split('T')[0] // Extract YYYY-MM-DD
                                             : 'No Date',
                                style: TextStyle(color: Colors.grey),
                              ),
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
    );
  }
}
