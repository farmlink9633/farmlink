import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 4, 56, 4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              "Welcome back",
              style: GoogleFonts.rubik(
                  fontSize: 35,
                  color: const Color.fromARGB(255, 4, 46, 4),
                  fontWeight: FontWeight.bold,
                  ), 
            ),
            SizedBox(
               height: 16
            ),
            Text(
              "Login to Your Account",
              style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 198, 180, 180)),
            ),
            SizedBox(
              height: 18,
            ),
            TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xFFC1DFCB),
                filled: true,
                label: Text("Username",
                    style: TextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 4, 56, 4),
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(
              height: 15,
            ),

            TextField(
                decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              fillColor: Color(0xFFC1DFCB),
              filled: true,
              label: Text("Email",
                  style: TextStyle(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 4, 56, 4),
                      fontWeight: FontWeight.bold)),
            )),
            SizedBox(
              height: 15,
            ),



       ]),
      ),
    );
  }
}