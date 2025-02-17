import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Define baseurl in your utils.dart or replace it directly here.
const String baseurl = 'https://796a-117-243-231-206.ngrok-free.app';

class OfficerNoticeScreen extends StatefulWidget {
  @override
  _OfficerNoticeScreenState createState() => _OfficerNoticeScreenState();
}

class _OfficerNoticeScreenState extends State<OfficerNoticeScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

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
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final response = await http.post(
        Uri.parse('$baseurl/notice/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'date': _selectedDate!.toIso8601String(),
          'officer': 3, // Replace with actual officer ID
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notice added successfully!')),
        );
        Navigator.pop(context);
      } else {
        print('Error: ${response.body}'); // Debugging purpose
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add notice')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and select a date')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notice'),
        backgroundColor: Colors.green,
      ),
      body: Container(
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
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                  fillColor: Colors.yellow[50],
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
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
              ElevatedButton(
                onPressed: _submitNotice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitNotice,
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: 'Add Notice',
      ),
    );
  }
}
