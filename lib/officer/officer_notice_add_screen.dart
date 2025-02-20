import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define Base URL
const String baseurl = 'https://0114-117-205-204-151.ngrok-free.app';

class OfficerNoticeAddScreen extends StatefulWidget {
  @override
  _OfficerNoticeAddScreenState createState() => _OfficerNoticeAddScreenState();
}

class _OfficerNoticeAddScreenState extends State<OfficerNoticeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  bool _isSubmitting = false;

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitNotice() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠ Please fill all fields and select a date')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseurl/notice/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'date': _selectedDate!.toIso8601String(),
          'officer': 3, // 🔹 Replace with actual officer ID (if needed)
        }),
      );

      print('🔹 Response Code: ${response.statusCode}');
      print('🔹 Response Body: ${response.body}');

      setState(() {
        _isSubmitting = false;
      });

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Notice added successfully!')),
        );
        Navigator.pop(context);
      } else {
        Map<String, dynamic> errorData = jsonDecode(response.body);
        String errorMessage = errorData.containsKey('message')
            ? errorData['message']
            : 'Unknown error occurred';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to add notice: $errorMessage')),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠ Error: Unable to connect to server')),
      );
      print('❌ Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notice'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    filled: true,
                    fillColor: Colors.yellow[50],
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Enter a valid title' : null,
                ),
                SizedBox(height: 10),

                // Description Field with Unlimited Size
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      filled: true,
                      fillColor: Colors.yellow[50],
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Enter a valid description' : null,
                  ),
                ),

                SizedBox(height: 10),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select Date',
                      filled: true,
                      fillColor: Colors.yellow[50],
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      _selectedDate == null
                          ? 'Choose a date'
                          : '${_selectedDate!.toLocal()}'.split(' ')[0],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                _isSubmitting
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submitNotice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 46, 121, 49),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Submit'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
