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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _officeAddressController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Function to register an officer
  Future<void> _registerOfficer() async {
    final url = Uri.parse('$baseurl/AdminAddOfficer/');

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _qualificationController.text.isEmpty ||
        _officeAddressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required! ⚠️')),
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
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
          "username": _usernameController.text.trim(),
          "number": _phoneController.text.trim(),
          "qualification": _qualificationController.text.trim(),
          "officeaddress": _officeAddressController.text.trim(),
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
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();
    _phoneController.clear();
    _qualificationController.clear();
    _officeAddressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50], // Light green background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 53, 16),
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
                style: GoogleFonts.rubik(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 10, 62, 12),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Create your new account",
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 154, 166, 151),
                ),
              ),
              SizedBox(height: 35),
              _buildTextField(_emailController, 'Email', Icons.email),
              _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
              _buildTextField(_usernameController, 'Username', Icons.person),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone),
              _buildTextField(_qualificationController, 'Qualification', Icons.school),
              _buildTextField(_officeAddressController, 'Office Address', Icons.location_city, maxLines: 3),
              SizedBox(height: 30),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _isLoading ? null : _registerOfficer, // Disables button when loading
                      child: Text(
                        'Sign up',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 14, 53, 16),
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        textStyle: TextStyle(fontSize: 18),
                        fixedSize: Size(500, 50),
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
                      color: Colors.black,
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
                        color: Color.fromARGB(255, 4, 46, 4),
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
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 51, 96, 54)),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ) : null,
          filled: true,
          fillColor: const Color.fromARGB(255, 189, 224, 190), // Light green fill color
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
