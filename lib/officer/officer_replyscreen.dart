import 'dart:convert';
import 'package:farmlink/officer/officer_chat_screen.dart'; // Ensure this import is correct
import 'package:farmlink/utils.dart'; // Ensure this import is correct
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For Poppins font
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // For date formatting

class ReplyScreen extends StatefulWidget {
  final Query query;

  const ReplyScreen({Key? key, required this.query}) : super(key: key);

  @override
  _ReplyScreenState createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final TextEditingController _replyController = TextEditingController();
  bool _isLoading = false;
  String? _replyDateTime; // To store the reply's date and time

  
Future<void> _submitReply() async {
  setState(() => _isLoading = true);

  try {
    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseurl/add_query/'),
    );

    // Add headers
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add form fields
    request.fields['content'] = _replyController.text;
    request.fields['farmer_id'] = widget.query.farmerId.toString();
    request.fields['officer_id'] = '9'; // Replace with the actual officer ID
    request.fields['is_askedbyfarmer'] = 'false'; // Officer is replying, so this is false

    // Send the request
    final response = await request.send();

    // Get the response
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      final responseJson = json.decode(responseData);
      final createdAt = responseJson['created_at']; // Get the created_at field from the response
      final formattedDate = createdAt != null
          ? DateFormat('MMM d, yyyy hh:mm a').format(DateTime.parse(createdAt).toLocal())
          : 'No date available';

      setState(() {
        _replyDateTime = formattedDate; // Store the formatted date and time
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reply submitted successfully! Farmers can now view your reply.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color.fromARGB(255, 60, 99, 61),
        ),
      );
    } else {
      throw Exception('Failed to submit reply: $responseData');
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
              ),
            ),
            SizedBox(height: 20),
            if (_replyDateTime != null) // Display the reply's date and time
              Text(
                'Reply sent on: $_replyDateTime',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 116, 140, 107),
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