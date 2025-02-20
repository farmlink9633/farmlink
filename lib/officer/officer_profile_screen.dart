import 'dart:convert';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  String avatarUrl = "https://www.w3schools.com/w3images/avatar2.png";
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
          String address = data['officeaddress'] ?? "No Office Address";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green[700]!, Colors.green[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
         
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img.freepik.com/free-vector/leaves-background-with-metallic-foil_79603-914.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.green))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(66, 149, 128, 128),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(avatarUrl),
                              ),
                              SizedBox(height: 15),
                              Text(
                                name,
                                style: GoogleFonts.rubik(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 26, 53, 19),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      _buildDividerWithIcon("Contact Information"),
                      SizedBox(height: 20),
                      _buildInfoRow(Icons.phone, "Phone", phone),
                      _buildInfoRow(Icons.credit_card, "Office Address", ''),
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
                          onPressed: () async{

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.remove('id');
                            
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Splashscreen(),), (route) => false,);
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
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String info) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 6,
      shadowColor: Colors.black45,
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
            style: TextStyle(
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
