import 'package:farmlink/authscreens/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

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
              "Register",
              style: GoogleFonts.nunitoSans(
                  fontSize: 35,
                  color: const Color.fromARGB(255, 7, 75, 7),
                  fontWeight: FontWeight.bold,
                  ),
            
            ),
            SizedBox(
              height: 8,
            ),
            
            Text(
              "Create your new account",
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
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xFFC1DFCB),
                filled: true,
                label: Text("Password",
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
                label: Text("Aadhaar",
                    style: TextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 4, 56, 4),
                        fontWeight: FontWeight.bold)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xFFC1DFCB),
                filled: true,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                  label: Text(
                    "Phone",
                    style: TextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 4, 56, 4),
                        fontWeight: FontWeight.bold),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  fillColor:Color(0xFFC1DFCB),
                  filled: true, 
                  ),
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xFFC1DFCB),
                filled: true,
                label: Text("Methods",
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
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xFFC1DFCB),
                filled: true,
                label: Text("Role, eg:farmer",
                    style: TextStyle(
                        fontSize: 15,
                        color: const Color.fromARGB(255, 4, 56, 4),
                        fontWeight: FontWeight.bold)),
              ),
            ),

            SizedBox(
              height: 35
            ),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 46, 4),
                  fixedSize: Size(500, 11)),
              child: Text(
                "Sign up",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(
              height: 25,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Already have an account",style: TextStyle(
                fontSize: 11,color: Colors.black,fontWeight: FontWeight.bold
              )),
              SizedBox(
                width: 6,
              ),
            GestureDetector (
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (contex)=> LoginScreen()));
              },
                child: Text("Login",style: TextStyle(decoration:TextDecoration.underline,fontSize: 13,color: Color.fromARGB(255, 4, 46, 4),fontWeight: FontWeight.bold
                )),
              )
            ],)
          ],
        ),
      ),
    );
  }
}
