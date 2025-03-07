import 'dart:async';
import 'package:farmlink/authscreens/choosescreen.dart';
import 'package:farmlink/authscreens/login.dart';
import 'package:farmlink/authscreens/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    // Removed the Future.delayed block
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  "https://i.pinimg.com/736x/cc/c0/fd/ccc0fdc34cd11ebad966ed249761890d.jpg",
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            bottom: 100,
            left: 15,
            right: 15,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your plants",
                      style: GoogleFonts.josefinSans(
                        fontSize: 45,
                        color: const Color.fromARGB(255, 92, 113, 80),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 11),
                    Text(
                      "deserve the",
                      style: GoogleFonts.josefinSans(
                        fontSize: 45,
                        color: const Color.fromARGB(255, 92, 113, 80),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 11),
                    Text(
                      "best care",
                      style: GoogleFonts.josefinSans(
                        fontSize: 45,
                        color: const Color.fromARGB(255, 92, 113, 80),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 60), // Added space between text and button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RoleSelectionScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 92, 113, 80), // Same color as the text
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Let's get started",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: Colors.white, // White text color
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
        ],
      ),
    );
  }
}