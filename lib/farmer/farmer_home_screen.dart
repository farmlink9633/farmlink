import 'dart:io';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  final List<String> plantTips = [
    "Water your plants early in the morning to reduce evaporation.",
    "Use organic fertilizers to keep your plants healthy and chemical-free.",
    "Prune your plants regularly to promote growth and remove dead parts.",
    "Ensure your plants get enough sunlight for photosynthesis.",
    "Rotate your plants to ensure even growth on all sides.",
  ];
  int _currentPage = 0;
  List<Map<String, dynamic>> notices = [];

  @override
  void initState() {
    super.initState();
    _fetchNotices(); // Fetch notices when the screen loads
  }

  /// Fetch notices from the backend
  Future<void> _fetchNotices() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/GetNoticesView/'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          notices = data.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load notices');
      }
    } catch (e) {
      _showErrorDialog("Failed to load notices. Please try again.");
    }
  }

  /// Show notices in a dialog
  void _showNoticesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 220, 245, 223), // Changed background color
          title: Text(
            'Notices',
            style: GoogleFonts.poppins(),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: notices.map((notice) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoticeDetailsScreen(noticeId: notice['id'].toString()),
                      ),
                    );
                  },
                  child: Column(
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
                      SizedBox(height: 5),
                      if (notice['date'] != null)
                        Text(
                          'Date: ${DateFormat('MMM d, yyyy hh:mm a').format(DateTime.parse(notice['date']))}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: const Color.fromARGB(255, 57, 73, 56), // Grey color for the date
                          ),
                        ),
                      SizedBox(height: 10),
                      Divider(color: Colors.grey),
                    ],
                  ),
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
  }

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

    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 207, 221, 198), // Custom color
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                'Please wait...\nDisease detection is in progress.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 71, 85, 65),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

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

      // Close the loading dialog
      Navigator.pop(context);

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
      // Close the loading dialog
      Navigator.pop(context);
      _showErrorDialog("Failed to upload image. Please try again.");
    }
  }

  /// Show the disease information in a dialog
  void _showDiseaseInfo(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 207, 221, 198), // Custom color
          title: Text(
            data['disease_name'] ?? "Unknown Disease",
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 71, 85, 65),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(data['disease_image_url'], height: 150),
                SizedBox(height: 10),
                Text(
                  "Description:",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 71, 85, 65),
                  ),
                ),
                Text(
                  data['description'],
                  style: GoogleFonts.poppins(),
                ),
                SizedBox(height: 10),
                Text(
                  "Possible Steps:",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 71, 85, 65),
                  ),
                ),
                Text(
                  data['possible_steps'],
                  style: GoogleFonts.poppins(),
                ),
                SizedBox(height: 10),
                Text(
                  "Supplement:",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 71, 85, 65),
                  ),
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
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 12, 34, 3),
                ),
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
          backgroundColor: const Color.fromARGB(255, 207, 221, 198), // Custom color
          title: Text(
            'Error',
            style: GoogleFonts.poppins(
              color: const Color.fromARGB(255, 71, 85, 65),
            ),
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
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 71, 85, 65),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        title: Text(
          'Home',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        elevation: 0,
        actions: [
          // Notification Icon without a rectangular box
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white, // Icon color
            ),
            onPressed: _showNoticesDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Add space at the top of the network image
            Padding(
              padding: const EdgeInsets.only(top: 20), // Add space here
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "https://img.freepik.com/premium-vector/modern-farmer-gardener-take-care-plant-illustration_538984-777.jpg?w=900",
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Overlay text on the image
                    Positioned(
                      bottom: 2, // Position the text at the bottom
                      child: Text(
                        'Grow Green, Live Healthy!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: const Color.fromARGB(255, 62, 92, 62),
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            // Plant Tips Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Plant Tips',
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      color: const Color.fromARGB(255, 71, 85, 65),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 170,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: plantTips.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 134, 160, 125),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              plantTips[index],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  // Dot Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      plantTips.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? const Color.fromARGB(255, 116, 140, 107)
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(_image!, height: 200),
                ),
              ),
          ],
        ),
      ),
      // Bottom Navigation Bar with Disease Detection
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 207, 221, 198),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Disease Detection',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 71, 85, 65),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera Button
                InkWell(
                  onTap: _isLoading ? null : openCamera,
                  child: Container(
                    width: 110,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 116, 140, 107),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Camera',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
                // Gallery Button
                InkWell(
                  onTap: _isLoading ? null : pickImageFromGallery,
                  child: Container(
                    width: 110,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 115, 122, 116),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.image,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Gallery',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

/// Notice Details Screen
class NoticeDetailsScreen extends StatelessWidget {
  final String noticeId;

  NoticeDetailsScreen({required this.noticeId});

  Future<Map<String, dynamic>> _fetchNoticeDetails() async {
    final response = await http.get(Uri.parse('$baseurl/noticesingleview/?notice_id=$noticeId'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load notice details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        title: Text(
          'Notice Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchNoticeDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load notice details'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No details available'));
          } else {
            final notice = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    notice['description'],
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  if (notice['date'] != null)
                    Text(
                      'Date: ${DateFormat('MMM d, yyyy hh:mm a').format(DateTime.parse(notice['date']))}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color.fromARGB(255, 71, 83, 71), // Grey color for the date
                      ),
                    ),
                  SizedBox(height: 20),
                  if (notice['officer'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Posted by:',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Name: ${notice['officer']['profile']['username']}',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        Text(
                          'Designation: ${notice['officer']['designation']}',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        Text(
                          'Office Address: ${notice['officer']['officeaddress']}',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}