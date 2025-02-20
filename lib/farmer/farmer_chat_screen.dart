import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class QueryScreen extends StatefulWidget {
  @override
  _QueryScreenState createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final TextEditingController _contentController = TextEditingController();
  File? _image;
  bool _isAskedByFarmer = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitQuery() {
    String content = _contentController.text;
    // Handle API call to submit query
    print('Content: $content');
    print('Is Asked by Farmer: $_isAskedByFarmer');
    if (_image != null) {
      print('Image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Query')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Query Content',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                SizedBox(width: 10),
                _image != null ? Image.file(_image!, width: 50, height: 50) : Container()
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Asked by Farmer'),
                Checkbox(
                  value: _isAskedByFarmer,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAskedByFarmer = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitQuery,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
