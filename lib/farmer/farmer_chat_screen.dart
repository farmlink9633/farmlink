import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

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

    // Simulate API call or submission logic
    bool isSuccess = true; // Change this based on your actual logic

    if (content.isEmpty) {
      isSuccess = false; // If content is empty, submission fails
    }

    // Show SnackBar based on success or failure
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSuccess ? 'Query submitted successfully!' : 'Submission failed. Please try again.',
          style: GoogleFonts.poppins(), // Apply Poppins font
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );

    // Print details for debugging
    print('Content: $content');
    print('Is Asked by Farmer: $_isAskedByFarmer');
    if (_image != null) {
      print('Image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212), 
      appBar: AppBar(
        title: Text(
          'Submit Query',
          style: GoogleFonts.poppins(
            fontSize: 21,
            fontWeight: FontWeight.normal,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 116, 140, 107), 
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _contentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Query Content',
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.green[800],
                          ),
                          border: InputBorder.none,
                          hintText: 'Describe your query...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.green[900],
                        ),
                      ),
                      Divider(color: Colors.green[200]),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.image, color: Colors.green[800]),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                            child: Text(
                              'Pick Image',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(_image!, width: 50, height: 50),
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.green[800]),
                      SizedBox(width: 10),
                      Text(
                        'Asked by Farmer',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.green[800],
                        ),
                      ),
                      Spacer(),
                      Checkbox(
                        value: _isAskedByFarmer,
                        onChanged: (bool? value) {
                          setState(() {
                            _isAskedByFarmer = value!;
                          });
                        },
                        activeColor: Colors.green[700],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitQuery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 116, 140, 107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}