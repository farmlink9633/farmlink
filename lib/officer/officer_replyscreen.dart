import 'dart:convert';
import 'package:farmlink/officer/officer_chat_screen.dart'; // Ensure this import is correct
import 'package:farmlink/utils.dart'; // Ensure this import is correct
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For Poppins font
import 'package:http/http.dart' as http;

class ReplyScreen extends StatefulWidget {
  final Query query;

  const ReplyScreen({Key? key, required this.query}) : super(key: key);

  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final TextEditingController _replyController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitReply() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$baseurl/add_query/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'content': _replyController.text,
          'farmer_id': widget.query.farmerId,
          'officer_id': 9, // Replace with the actual officer ID
          'is_askedbyfarmer': false, // Officer is replying, so this is false
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reply submitted successfully! Farmers can now view your reply.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color.fromARGB(255, 60, 99, 61),
          ),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        throw Exception('Failed to submit reply');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to submit reply: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212), // Scaffold background color
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107), // App bar color
        title: Text(
          'Reply to Query',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Back button color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Replying to Farmer: ${widget.query.farmerName}",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(221, 34, 48, 30),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 209, 221, 206),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: TextField(
                controller: _replyController,
                decoration: InputDecoration(
                  labelText: 'Your Reply',
                  labelStyle: GoogleFonts.poppins(),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16.0),
                ),
                maxLines: 5,
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(221, 34, 48, 30), // Text color
                ),
                cursorColor: const Color.fromARGB(255, 116, 140, 107), // Cursor color
                cursorWidth: 2.0,
                cursorHeight: 20.0,
                cursorRadius: Radius.circular(2.0),
                selectionControls: MyCustomTextSelectionControls(), // Custom selection handles
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator(
                      color: const Color.fromARGB(255, 116, 140, 107),
                    )
                  : ElevatedButton(
                      onPressed: _submitReply,
                      child: Text(
                        'Submit',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 116, 140, 107), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Text Selection Handles
class MyCustomTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textLineHeight, [VoidCallback? onTap]) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 116, 140, 107), // Custom handle color
        shape: BoxShape.circle,
      ),
    );
  }
}