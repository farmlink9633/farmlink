import 'dart:io';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  File? _image;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage(_image!);
    }
  }

  /// Capture an image using the camera
  Future<void> openCamera() async {
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _uploadImage(_image!);
      }
    } else {
      print('Camera permission denied');
    }
  }

  /// Upload the image and get the disease prediction
  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseurl/predict_disease/'),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        _showDiseaseInfo(jsonResponse);
      } else {
        _showErrorDialog("Error: ${response.body}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Failed to upload image. Please try again.");
    }
  }

  /// Show the disease information in a dialog
  void _showDiseaseInfo(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            data['disease_name'] ?? "Unknown Disease",
            style: GoogleFonts.poppins(),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(data['disease_image_url'], height: 150),
                SizedBox(height: 10),
                Text(
                  "Description:",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                Text(
                  data['description'],
                  style: GoogleFonts.poppins(),
                ),
                SizedBox(height: 10),
                Text(
                  "Possible Steps:",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                Text(
                  data['possible_steps'],
                  style: GoogleFonts.poppins(),
                ),
                SizedBox(height: 10),
                Text(
                  "Supplement:",
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Image.network(data['supplement_image_url'], height: 50),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        data['supplement_name'],
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Close",
                style: GoogleFonts.poppins(),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Show error message dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: GoogleFonts.poppins(),
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Fetch notices from the backend
  Future<List<Map<String, dynamic>>> _fetchNotices() async {
    final response = await http.get(Uri.parse('$baseurl/GetNoticesView/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load notices');
    }
  }

  /// Show notices in a dialog
  void _showNoticesDialog() async {
    try {
      List<Map<String, dynamic>> notices = await _fetchNotices();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Notices',
              style: GoogleFonts.poppins(),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: notices.map((notice) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice['title'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        notice['description'],
                        style: GoogleFonts.poppins(),
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey),
                    ],
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Close",
                  style: GoogleFonts.poppins(),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } catch (e) {
      _showErrorDialog("Failed to load notices. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        title: Text(
          '',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 92, 113, 80),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: const Color.fromARGB(255, 246, 244, 244)),
            onPressed: _showNoticesDialog, // Show notices when the icon is clicked
          ),
        ],
      ),
      
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            Image.network(
            
            "https://img.freepik.com/premium-vector/modern-farmer-gardener-take-care-plant-illustration_538984-777.jpg?w=900",
            width: 400, // Set the width of the image
            height: 300, // Set the height of the image
            fit: BoxFit.cover, // Adjust the image to cover the space
          ),
            
            SizedBox(
              height:100
              ),
            Text(
              'Disease Detection',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: const Color.fromARGB(255, 71, 85, 65),
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 23),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : openCamera,
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Camera',
                    style: GoogleFonts.poppins(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 116, 140, 107), // Button color
                    foregroundColor: Colors.white, // Text and icon color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : pickImageFromGallery,
                  icon: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Gallery',
                    style: GoogleFonts.poppins(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 98, 105, 99), // Button color
                    foregroundColor: Colors.white, // Text and icon color
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.file(_image!, height: 200),
              ),
          ],
        ),
      ),
    );
  }
}