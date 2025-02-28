import 'dart:convert';
import 'dart:io';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authscreens/splashscreen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Loading...";
  String email = "Loading...";
  String phone = "Loading...";
  String aadhaar = "Loading...";
  String role = "Loading...";
  File? _profileImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String url = "$baseurl/farmer_profile_view/?farmer_id=${prefs.getString('id')}";

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
          aadhaar = data['aadhaar'] ?? "No Aadhaar";
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Log out",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 31, 68, 36),
            ),
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "No",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('id');
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Splashscreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                "Yes",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 79, 94, 73),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController aadhaarController = TextEditingController(text: aadhaar);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Edit Profile",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 31, 68, 36),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                TextField(
                  controller: aadhaarController,
                  decoration: InputDecoration(
                    labelText: "Aadhaar",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Save changes
                final updatedData = {
                  'username': nameController.text,
                  'email': emailController.text,
                  'phone': phoneController.text,
                  'aadhaar': aadhaarController.text,
                };

                SharedPreferences prefs = await SharedPreferences.getInstance();
                final String url = "$baseurl/AdminUpdateFarmer/";
                final response = await http.post(
                  Uri.parse(url),
                  body: jsonEncode({
                    'profileid': prefs.getString('id'),
                    ...updatedData,
                  }),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 200) {
                  setState(() {
                    name = nameController.text;
                    email = emailController.text;
                    phone = phoneController.text;
                    aadhaar = aadhaarController.text;
                  });
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to update profile"),
                    ),
                  );
                }
              },
              child: Text(
                "Save",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 79, 94, 73),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Change Password",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 31, 68, 36),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Old Password",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    labelStyle: GoogleFonts.poppins(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final String url = "$baseurl/password/${prefs.getString('id')}/";
                final response = await http.put(
                  Uri.parse(url),
                  body: jsonEncode({
                    'old_password': oldPasswordController.text,
                    'new_password': newPasswordController.text,
                  }),
                  headers: {'Content-Type': 'application/json'},
                );

                if (response.statusCode == 200) {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Password updated successfully"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to update password"),
                    ),
                  );
                }
              },
              child: Text(
                "Save",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 79, 94, 73),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Delete Profile",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 31, 68, 36),
            ),
          ),
          content: Text(
            "Are you sure you want to delete your profile?",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "No",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                final String url = "$baseurl/AdminUpdateFarmer/?profileid=${prefs.getString('id')}";
                final response = await http.delete(Uri.parse(url));

                if (response.statusCode == 200) {
                  prefs.remove('id');
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Splashscreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to delete profile"),
                    ),
                  );
                }
              },
              child: Text(
                "Yes",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 79, 94, 73),
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
      backgroundColor: const Color.fromARGB(235, 201, 210, 199),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 23,
              color: Colors.white, // Settings icon color
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: const Color.fromARGB(255, 31, 68, 36), // Edit icon color
                        ),
                        title: Text(
                          "Edit Profile",
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 31, 68, 36), // Edit text color
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showEditProfileDialog(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.lock,
                          color: const Color.fromARGB(255, 31, 68, 36), // Change password icon color
                        ),
                        title: Text(
                          "Change Password",
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 31, 68, 36), // Change password text color
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showChangePasswordDialog(context);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.delete,
                          color: const Color.fromARGB(255, 31, 68, 36), // Delete icon color
                        ),
                        title: Text(
                          "Delete Profile",
                          style: GoogleFonts.poppins(
                            color: const Color.fromARGB(255, 31, 68, 36), // Delete text color
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          _showDeleteConfirmationDialog(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 131, 152, 123),
              const Color.fromARGB(255, 179, 197, 175),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: const Color.fromARGB(255, 106, 145, 95),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color.fromARGB(255, 215, 223, 215),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: _profileImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      _profileImage!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.grey[600],
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          email,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildDividerWithIcon("Contact Information"),
                      SizedBox(height: 20),
                      _buildInfoRow(Icons.phone, "Phone", phone),
                      _buildInfoRow(Icons.credit_card, "Aadhaar Number", aadhaar),
                      _buildInfoRow(Icons.person, "Role", role),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: const Color.fromARGB(255, 93, 111, 87),
                          ),
                          onPressed: () {
                            _showLogoutConfirmationDialog(context); // Show confirmation dialog
                          },
                          child: Text(
                            "Log out",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String info) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      shadowColor: Colors.black45,
      child: ListTile(
        tileColor: const Color.fromARGB(255, 199, 204, 199),
        leading: Icon(
          icon,
          color: const Color.fromARGB(255, 74, 90, 75),
          size: 26,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: const Color.fromARGB(255, 59, 102, 62),
          ),
        ),
        trailing: Text(
          info,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color.fromARGB(255, 63, 68, 64),
          ),
        ),
      ),
    );
  }

  Widget _buildDividerWithIcon(String text) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: const Color.fromARGB(255, 9, 86, 13),
            thickness: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.green[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: const Color.fromARGB(255, 9, 86, 13),
            thickness: 1.5,
          ),
        ),
      ],
    );
  }
}