import 'package:farmlink/officer/officer_notice_add_screen.dart';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import Google Fonts

class QueryScreen extends StatefulWidget {
  final String officer_id;

  const QueryScreen({super.key, required this.officer_id});
  @override
  _QueryScreenState createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final TextEditingController _contentController = TextEditingController();
  File? _image;
  bool _isAskedByFarmer = false;
  bool _isLoading = false; // Track loading state

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitQuery() async {
    String content = _contentController.text;

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Query content cannot be empty!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String farmerId = prefs.getString('id') ?? '';

    if (farmerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User not logged in!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Prepare the request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseurl/add-query/'), // Replace with your actual endpoint
    );

    // Add fields to the request
    if (farmerId.isNotEmpty) {
      request.fields['farmer_id'] = farmerId;
    }
    request.fields['asked_by_farmer'] = _isAskedByFarmer.toString();
    request.fields['officer_id'] = widget.officer_id;
    request.fields['content'] = content;

    // Add image file if selected
    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        ),
      );
    }

    // Set loading to true before sending the request
    setState(() {
      _isLoading = true;
    });

    // Send the request
    try {
      final response = await request.send();

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Query submitted successfully!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Clear the form after successful submission
        _contentController.clear();
        setState(() {
          _image = null;
          _isAskedByFarmer = false;
          _isLoading = false; // Set loading to false after submission
        });
      } else {
        setState(() {
          _isLoading = false; // Set loading to false on failure
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to submit query. Please try again.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false if error occurs
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred: $e',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
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
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(235, 214, 232, 210),
              const Color.fromARGB(235, 215, 233, 209),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card for Query Content and Image Picker
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: const Color.fromARGB(255, 223, 233, 223), // Custom background color
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
                            fontSize: 14,
                            color: const Color.fromARGB(255, 95, 121, 97),
                          ),
                          border: InputBorder.none,
                          hintText: 'Describe your query...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400],
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color.fromARGB(255, 94, 123, 96),
                        ),
                      ),
                      Divider(color: const Color.fromARGB(255, 136, 165, 137)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.image, color: const Color.fromARGB(255, 72, 104, 74)),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 111, 134, 112),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: Text(
                              'Pick Image',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
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

              // Card for "Asked by Farmer" Checkbox
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: const Color.fromARGB(255, 223, 233, 223), // Same custom background color
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.person, color: const Color.fromARGB(255, 72, 104, 74)),
                      SizedBox(width: 10),
                      Text(
                        'Asked by Farmer',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 70, 81, 71),
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
                        activeColor: const Color.fromARGB(255, 67, 102, 69),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitQuery, // Disable button when loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 116, 140, 107),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white) // Show loading indicator
                      : Text(
                          'Submit',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
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
