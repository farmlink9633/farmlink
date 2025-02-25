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

  // Function to show logout confirmation dialog
  Future<void> _showLogoutConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Logout",
            style: GoogleFonts.poppins(
              fontSize: 20, // Font size for dialog title
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to logout?",
            style: GoogleFonts.poppins(
              fontSize: 16, // Font size for dialog content
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "No",
                style: GoogleFonts.poppins(
                  fontSize: 16, // Font size for "No" button
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
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
                "Yes",
                style: GoogleFonts.poppins(
                  fontSize: 16, // Font size for "Yes" button
                  color: const Color.fromARGB(255, 39, 82, 41),
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
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        flexibleSpace: Container(
          decoration: BoxDecoration(),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 24, // Font size for app bar title
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color.fromARGB(255, 95, 125, 96),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture Section
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: const Color.fromARGB(255, 199, 204, 200),
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!) as ImageProvider
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.person,
                                size: 60,
                                color: const Color.fromARGB(255, 146, 151, 147),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 90, 122, 92),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 24, // Font size for name
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 64, 82, 64),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.normal, 
                      color: const Color.fromARGB(255, 50, 49, 49),
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
                        backgroundColor: const Color.fromARGB(255, 100, 120, 92),
                      ),
                      onPressed: _showLogoutConfirmation,
                      child: Text(
                        "Log out",
                        style: GoogleFonts.poppins(
                          fontSize: 18, // Font size for logout button
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
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
        tileColor: const Color.fromARGB(255, 190, 197, 183),
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 75, 100, 77),
          size: 25,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16, // Font size for info row title
            fontWeight: FontWeight.normal,
            color: const Color.fromARGB(255, 49, 75, 51),
          ),
        ),
        trailing: Text(
          info,
          style: GoogleFonts.poppins(
            fontSize: 14, // Font size for info row trailing text
            color: const Color.fromARGB(255, 60, 74, 60),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithIcon(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color:  const Color.fromARGB(255, 116, 143, 118), thickness: 1.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16, // Font size for divider text
              color: Colors.green[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: const Color.fromARGB(255, 116, 143, 118), thickness: 1.5)),
      ],
    );
  }
}