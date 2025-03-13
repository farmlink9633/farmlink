import 'dart:convert';

import 'package:farmlink/officer/officer_chat_screen.dart';
import 'package:farmlink/officer/officer_query_detail_screen.dart';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
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
          SnackBar(content: Text('Reply submitted successfully!')),
        );
        Navigator.pop(context); // Go back to the previous screen
      } else {
        throw Exception('Failed to submit reply');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit reply: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reply to Query')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Replying to Farmer: ${widget.query.farmerName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              controller: _replyController,
              decoration: InputDecoration(
                labelText: 'Your Reply',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitReply,
                      child: Text('Submit Reply'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}