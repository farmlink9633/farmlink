import 'dart:convert';
import 'package:farmlink/authscreens/login.dart';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class OfficerRegistrationScreen extends StatefulWidget {
  @override
  _OfficerRegistrationScreenState createState() =>
      _OfficerRegistrationScreenState();
}

class _OfficerRegistrationScreenState extends State<OfficerRegistrationScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _officeaddressController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Function to register an officer
  Future<void> _registerOfficer() async {
    final url = Uri.parse('$baseurl/AdminAddOfficer/');

    // Check if all fields are filled
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _designationController.text.isEmpty ||
        _officeaddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required! ⚠️')),
      );
      return;
    }

    // Email validation using regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address! 📧')),
      );
      return;
    }

    // Password length validation
    if (_passwordController.text.trim().length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters long! 🔒')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "number": _phoneController.text.trim(),
          "designation": _designationController.text.trim(),
          "officeaddress": _officeaddressController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Officer registered successfully! ✅')),
        );
        _clearFields();
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Registration failed! ❌')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error. Please try again later! 🌐')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _clearFields() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _designationController.clear();
    _officeaddressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212), 
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),  
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 61, 67, 61),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Create your new account",
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 114, 125, 111),
                ),
              ),
              SizedBox(height: 35),
              _buildTextField(_usernameController, 'Username', Icons.person),
              _buildTextField(_emailController, 'Email', Icons.email),
              _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone),
              _buildTextField(_designationController, 'Designation', Icons.work),
              _buildTextField(_officeaddressController, 'Office Address', Icons.location_city, maxLines: 3),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator() // Show loading spinner
                  : ElevatedButton(
                      onPressed: _isLoading ? null : _registerOfficer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 102, 121, 96), 
                        fixedSize: Size(500, 50),
                      ),
                      child: Text(
                        "Sign up",
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account",
                    style: TextStyle(
                      fontSize: 11,
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
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                        color: Color.fromARGB(255, 37, 55, 37),
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

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        maxLines: maxLines,
        enabled: !_isLoading, // Disables input when loading
        decoration: InputDecoration(
          labelText: hint,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: const Color.fromARGB(235, 216, 227, 214), 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}