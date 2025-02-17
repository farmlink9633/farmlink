import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define baseurl in your utils.dart or replace it directly here.
const String baseurl = 'http://your-server-url/api';

class NoticeDetailsScreen extends StatefulWidget {
  @override
  _NoticeDetailsScreenState createState() => _NoticeDetailsScreenState();
}

class _NoticeDetailsScreenState extends State<NoticeDetailsScreen> {
  List<dynamic> _notices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotices();
  }

  Future<void> _fetchNotices() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/GetNoticesNew/'));

      if (response.statusCode == 200) {
        setState(() {
          _notices = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice Details'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notices.isEmpty
              ? Center(child: Text('No notices available'))
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _notices.length,
                  itemBuilder: (context, index) {
                    final notice = _notices[index];
                    return Card(
                      color: Colors.yellow[50],
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      child: ListTile(
                        title: Text(
                          notice['title'] ?? 'No Title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text(
                              notice['description'] ?? 'No Description',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Date: ${notice['date']?.split('T')[0] ?? 'No Date'}",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.green),
                      ),
                    );
                  },
                ),
    );
  }
}
