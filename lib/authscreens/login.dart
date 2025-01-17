import 'package:farmlink/authscreens/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 4, 56, 4),
      ),
      body: Column(children: [
        Container(width: 1800,height: 300,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage("https://images.pexels.com/photos/1353938/pexels-photo-1353938.jpeg")),

                  ),
        ),
      
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            Text(
              "Welcome back",
              style: GoogleFonts.josefinSans(
                  fontSize: 35,
                  color: const Color.fromARGB(255, 7, 75, 7),
                  fontWeight: FontWeight.bold,
                  ), 
            ),
            SizedBox(
               height: 16
            ),
            Text(
              "Login to your account",
              style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 198, 180, 180)),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Color(0xFFC1DFCB),
                filled: true,
                label: Text("Email",
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
              label: Text("Password",
                  style: TextStyle(
                      fontSize: 15,
                      color: const Color.fromARGB(255, 4, 56, 4),
                      fontWeight: FontWeight.bold)),
            )),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(value: false, onChanged: (value) {
                  
                },),
              Text("Remember Me",style: TextStyle(
              fontSize: 11,color: const Color.fromARGB(255, 4, 46, 4) ,fontWeight: FontWeight.bold
              )),
              SizedBox(
                width: 90 
              ),
              
              Text("Forgot Password",style: TextStyle(
                fontSize: 12,color: const Color.fromARGB(255, 4, 46, 4) ,fontWeight: FontWeight.bold
              ),
              ),
              SizedBox(
                height: 120 ,
              ),
        
          ],),
              ElevatedButton(
                onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 46, 4),
                  fixedSize: Size(500, 11)),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Don't have an account?",style: TextStyle(
                fontSize: 12,color: Colors.black,fontWeight: FontWeight.normal
              )),
              SizedBox(
                width: 6,
              ),
            GestureDetector (
              onTap:() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> Registration()));
              },
                child: Text("Sign up",style: TextStyle(decoration:TextDecoration.underline,fontSize: 14,color: Color.fromARGB(255, 4, 46, 4),fontWeight: FontWeight.bold
                ),
                ),
              ),
            ],)
          
        ]),
    ),
    ],
    ),
    );
  }
}