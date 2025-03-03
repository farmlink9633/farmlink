import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:farmlink/authscreens/login.dart';
import 'package:farmlink/farmer/rootscreen.dart';

class Registration extends StatefulWidget {
  Registration({super.key});

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // Controllers for input fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController aadhaarController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController methodsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();


  bool isLoading = false; // Loading state
  bool isPasswordHidden = true; // Password visibility state

  // Function to validate email
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Function to handle form submission
  Future<void> register(BuildContext context) async {
    // Validate email
    if (!isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    // Validate password length
    if (passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 6 characters long")),
      );
      return;
    }

    // Validate phone number length
    if (phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone number must be 10 digits long")),
      );
      return;
    }

    String url = "${baseurl.trim()}/register/"; // Replace with your API endpoint

    setState(() {
      isLoading = true;
    });

    try {
      print(Uri.parse(url));
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "username": usernameController.text,
          "email": emailController.text,
          "password": passwordController.text,
          "aadhaar": aadhaarController.text,
          "number": phoneController.text,
          "methods": methodsController.text,
          "location": locationController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Successful!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Rootscreen()),
        );
      } else {
        final error = json.decode(response.body)['message'] ?? "Something went wrong";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212), 
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        foregroundColor: const Color.fromARGB(255, 200, 212, 200),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Text(
                "Register",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  color: const Color.fromARGB(255, 74, 83, 74),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Create your new account",
                style: TextStyle(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 111, 117, 109),
                ),
              ),
              SizedBox(height: 19),
              buildTextField("Username", usernameController),
              SizedBox(height: 15),
              buildTextField("Email", emailController),
              SizedBox(height: 15),
              buildTextField(
                "Password",
                passwordController,
                isPassword: true,
                isPasswordHidden: isPasswordHidden,
                togglePasswordVisibility: () {
                  setState(() {
                    isPasswordHidden = !isPasswordHidden;
                  });
                },
              ),
              SizedBox(height: 15),
              buildTextField("Aadhaar", aadhaarController),
              SizedBox(height: 15),
              buildTextField("Phone", phoneController),
              SizedBox(height: 15),
              buildTextField("Methods", methodsController),
              SizedBox(height: 15),
              buildTextField("Location", locationController),
              SizedBox(height: 36),
            
              isLoading
                  ? CircularProgressIndicator() // Show loading spinner
                  : ElevatedButton(
                      onPressed: () => register(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 102, 121, 96), 
                        fixedSize: Size(500, 50),
                      ),
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                      ),
                    ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: const Color.fromARGB(255, 51, 54, 52),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.poppins(
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        color: Color.fromARGB(255, 52, 65, 52),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to create a text field
  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool isPasswordHidden = true,
    VoidCallback? togglePasswordVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? isPasswordHidden : false,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        fillColor: Color.fromARGB(255, 221, 228, 223),
        filled: true,
        labelStyle: TextStyle(
          fontSize: 14,
          color: const Color.fromARGB(255, 41, 47, 41),
          fontWeight: FontWeight.normal
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  
                  isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: const Color.fromARGB(255, 76, 86, 76),
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
      ),
    );
  }
}