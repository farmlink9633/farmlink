import 'package:farmlink/authscreens/choosescreen.dart';
import 'package:farmlink/authscreens/forgotpasswordscreen.dart';
import 'package:farmlink/authscreens/register.dart';
import 'package:farmlink/farmer/rootscreen.dart';
import 'package:farmlink/officer/officerrootscreen.dart';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _terms = false;
  bool _isLoading = false;
  bool _isPasswordHidden = true; // For password visibility toggle

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to validate email format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Validate email
    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid email address.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      );
      return;
    }

    // Validate password length
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password must be at least 6 characters long.',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final Uri url = Uri.parse('${baseurl.trim()}/login/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Save user ID
        await prefs.setString('id', data['data']['id'].toString());

        // Check user role and navigate accordingly
        String role = data['data']['role'] ?? ''; // Assuming role is returned in JSON
        print("Full Response: $data");

        if (role == 'Farmer') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('id', data['data']['id'].toString());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Rootscreen()),
          );
        } else if (role == 'Officer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OfficerRootScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid role. Please try again.',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          );
        }
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Login failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'An error occurred: $e',
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(236, 215, 228, 212), // Background color
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 260,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://images.pexels.com/photos/1353938/pexels-photo-1353938.jpeg",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Welcome back",
                style: GoogleFonts.poppins(
                  fontSize: 29,
                  color: const Color.fromARGB(255, 89, 105, 84), 
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 17),
              Text(
                "Login to your account",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: const Color.fromARGB(255, 140, 148, 139),
                ),
              ),
              SizedBox(height: 21),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: const Color.fromARGB(235, 201, 208, 199),  
                    filled: true,
                    label: Text(
                      "Email",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color.fromARGB(255, 54, 73, 54),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordHidden, // Toggle password visibility
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: const Color.fromARGB(235, 201, 208, 199),
                    filled: true,
                    label: Text(
                      "Password",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color.fromARGB(255, 70, 94, 70),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 62, 87, 62),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 13),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [],
                    ),
                    TextButton(
                      onPressed: () {Navigator.push(
                        context,
                         MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen(),
                          ),
                            );
                        },
                        // Add your forgot password logic here
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color.fromARGB(255, 69, 94, 69),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 105),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:const Color.fromARGB(255, 102, 121, 96),  
                        fixedSize: Size(300, 50),
                      ),
                      child: Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color.fromARGB(255, 43, 43, 43),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoleSelectionScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: GoogleFonts.poppins(
                        decoration: TextDecoration.underline,
                        fontSize: 14,
                        color: Color.fromARGB(255, 67, 83, 67),
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
}