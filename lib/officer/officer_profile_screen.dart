import 'dart:convert';
import 'dart:io';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // For profile picture upload
import '../authscreens/splashscreen.dart';

class OfficerProfileScreen extends StatefulWidget {
  @override
  _OfficerProfileScreenState createState() => _OfficerProfileScreenState();
}

class _OfficerProfileScreenState extends State<OfficerProfileScreen> {
  String name = "Loading...";
  String email = "Loading...";
  String phone = "Loading...";
  String officeaddress = "Loading...";
  String role = "Loading...";
  File? _profileImage; // For storing the selected profile picture
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = "$baseurl/officer_profile_view/?officer_id=${prefs.getString('id')}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        print(data['profile']);

        setState(() {
          name = data['profile']['username'] ?? "No Name";
          email = data['profile']['email'] ?? "No Email";
          phone = data['profile']['phone'] ?? "No Phone";
          officeaddress = data['officeaddress'] ?? "No Office Address";
          role = data['profile']['role'] ?? "No Role";
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load profile");
      }
    } catch (e) {
      print("Error fetching profile: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
         backgroundColor: const Color.fromARGB(255, 116, 140, 107) ,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 26,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.green))
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture Section
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : NetworkImage("https://www.w3schools.com/w3images/avatar2.png"),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    name,
                    style: GoogleFonts.rubik(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 102, 112, 102),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildDividerWithIcon("Contact Information"),
                  SizedBox(height: 20),
                  _buildInfoRow(Icons.phone, "Phone", phone),
                  _buildInfoRow(Icons.location_on, "Office Address", officeaddress),
                  _buildInfoRow(Icons.person, "Role", role),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.green[700],
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove('id');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Splashscreen()),
                          (route) => false,
                        );
                      },
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String info) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.green[800], size: 30),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
        trailing: Text(
          info,
          style: TextStyle(
            fontSize: 16,
            color: Colors.green[700],
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithIcon(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.green[300], thickness: 1.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.rubik(
              fontSize: 16,
              color: Colors.green[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.green[300], thickness: 1.5)),
      ],
    );
  }
}