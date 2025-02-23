import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class NoticeDetailScreen extends StatefulWidget {
  final int noticeId;
  
  NoticeDetailScreen({required this.noticeId});

  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  bool isLoading = true;
  bool isEditing = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    fetchNoticeDetail();
  }

  Future<void> fetchNoticeDetail() async {
    final response = await http.get(Uri.parse('$baseurl/UpdateNotice/${widget.noticeId}/'));
    
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        titleController.text = data['title'];
        descriptionController.text = data['description'];
        selectedDate = DateTime.parse(data['date'] ?? DateTime.now().toString());
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveChanges() async {
    setState(() {
      isLoading = true;
    });
    
    final response = await http.put(
      Uri.parse('$baseurl/UpdateNotice/${widget.noticeId}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': titleController.text,
        'description': descriptionController.text,
        'date': selectedDate?.toIso8601String(),
      }),
    );
    
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        isEditing = false;
      });
      Navigator.pop(context, true);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteNotice() async {
    setState(() {
      isLoading = true;
    });
    
    final response = await http.delete(
      Uri.parse('$baseurl/UpdateNotice/${widget.noticeId}/'),
    );
    
    if (response.statusCode == 204) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice Details', style: GoogleFonts.poppins()),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    enabled: isEditing,
                    style: GoogleFonts.poppins(),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    enabled: isEditing,
                    style: GoogleFonts.poppins(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        child: Text('Edit', style: GoogleFonts.poppins()),
                      ),
                      ElevatedButton(
                        onPressed: isEditing ? saveChanges : null,
                        child: Text('Save Changes', style: GoogleFonts.poppins()),
                      ),
                      ElevatedButton(
                        onPressed: deleteNotice,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: Text('Delete', style: GoogleFonts.poppins()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
