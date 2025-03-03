import 'dart:convert';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class NoticeDetailScreen extends StatefulWidget {
  final int noticeId;
  const NoticeDetailScreen({Key? key, required this.noticeId}) : super(key: key);

  @override
  _NoticeDetailScreenState createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  bool isLoading = true;
  bool hasError = false;
  Map<String, dynamic>? noticeData;

  @override
  void initState() {
    super.initState();
    fetchNoticeDetails();
  }

  Future<void> fetchNoticeDetails() async {
    final String apiUrl = "$baseurl/noticesingleview/?notice_id=${widget.noticeId}";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'success') {
          setState(() {
            noticeData = responseData['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _deleteNotice() async {
    // Show confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Notice",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete this notice?",
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "No",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Yes",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.green),
            ),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      final String apiUrl = "$baseurl/UpdateNotice/?NoticeId=${widget.noticeId}";

      try {
        final response = await http.delete(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          // Navigate back to the previous screen after successful deletion
          Navigator.pop(context, true); // Pass `true` to indicate deletion
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to delete notice",
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error: $e",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
        );
      }
    }
  }

  Future<void> _editNotice() async {
    // Navigate to an edit screen or show a dialog for editing
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoticeScreen(noticeId: widget.noticeId, noticeData: noticeData!),
      ),
    );

    if (result == true) {
      // Refresh the notice details after editing
      fetchNoticeDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        title: Text(
          "Notice Details",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 237, 239, 237)),
            onPressed: _editNotice,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Color.fromARGB(255, 237, 239, 237)),
            onPressed: _deleteNotice,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Text(
                    "Failed to load notice",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        noticeData?['title'] ?? "No Title",
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 51, 56, 50)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Date: ${noticeData?['date'] ?? "N/A"}",
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Officer: ${noticeData?['officer'] ?? "N/A"}",
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const Divider(thickness: 1, height: 20, color: Color.fromARGB(255, 89, 87, 87),),
                      Text(
                        noticeData?['description'] ?? "No Description",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ],
                  ),
                ),
    );
  }
}

// EditNoticeScreen with Poppins font
class EditNoticeScreen extends StatefulWidget {
  final int noticeId;
  final Map<String, dynamic> noticeData;

  const EditNoticeScreen({Key? key, required this.noticeId, required this.noticeData}) : super(key: key);

  @override
  _EditNoticeScreenState createState() => _EditNoticeScreenState();
}

class _EditNoticeScreenState extends State<EditNoticeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noticeData['title']);
    _descriptionController = TextEditingController(text: widget.noticeData['description']);
  }

  Future<void> _updateNotice() async {
    final String apiUrl = "$baseurl/UpdateNotice/?NoticeId=${widget.noticeId}";

    final Map<String, dynamic> requestBody = {
      'title': _titleController.text,
      'description': _descriptionController.text,
    };

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return `true` to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to update notice",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
            style: GoogleFonts.poppins(fontSize: 16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        title: Text(
          "Edit Notice",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Color.fromARGB(255, 234, 230, 230)),
            onPressed: _updateNotice,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: GoogleFonts.poppins(fontSize: 16),
                ),
                style: GoogleFonts.poppins(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: GoogleFonts.poppins(fontSize: 16),
                ),
                style: GoogleFonts.poppins(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a description";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}