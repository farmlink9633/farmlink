import 'dart:convert';
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
  
        backgroundColor: const Color.fromARGB(255, 13, 35, 14),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
              SizedBox(height: 10),
              Text(
                'Fill in the details below to register an officer.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 30),

              _buildTextField(_emailController, 'Email', Icons.email),
              _buildTextField(_passwordController, 'Password', Icons.lock, isPassword: true),
              _buildTextField(_usernameController, 'Username', Icons.person),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone),
              _buildTextField(_qualificationController, 'Qualification', Icons.school),
              _buildTextField(_officeAddressController, 'Office Address', Icons.location_city, maxLines: 3),

              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _isLoading ? null : _registerOfficer, // Disables button when loading
                      icon: Icon(Icons.app_registration),
                      label: Text('Register', style: GoogleFonts.roboto(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 13, 35, 14),
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 41),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        textStyle: TextStyle(fontSize: 16),
                      ),
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
        obscureText: isPassword,
        maxLines: maxLines,
        enabled: !_isLoading, // Disables input when loading
        decoration: InputDecoration(
          labelText: hint,
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 51, 96, 54)),
          filled: true,
          fillColor: const Color.fromARGB(255, 189, 224, 190), // Light green fill color
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
}
