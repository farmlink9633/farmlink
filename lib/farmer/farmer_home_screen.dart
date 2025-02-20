import 'dart:io';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
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
          title: Text(data['disease_name'] ?? "Unknown Disease"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(data['disease_image_url'], height: 150),
                SizedBox(height: 10),
                Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data['description']),
                SizedBox(height: 10),
                Text("Possible Steps:", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(data['possible_steps']),
                SizedBox(height: 10),
                Text("Supplement:", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Image.network(data['supplement_image_url'], height: 50),
                    SizedBox(width: 10),
                    Expanded(child: Text(data['supplement_name'])),
                  ],
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () => _launchURL(data['buy_url']),
                  child: Text("Buy Supplement", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Close"),
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
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Open URLs in a browser
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("Could not open URL: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 179, 221, 167),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),
        Text('Disease detection'),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : openCamera,
              icon: Icon(Icons.camera_alt, color: Colors.black),
              label: Text('Camera'),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : pickImageFromGallery,
              icon: Icon(Icons.image, color: Colors.black),
              label: Text('Gallery'),
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
    );
  }
}
