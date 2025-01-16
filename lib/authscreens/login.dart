import 'package:farmlink/authscreens/register.dart';
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
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage("https://img3.wallspic.com/previews/0/0/4/3/3/133400/133400-light-water-leaf-darkness-black-x750.jpg")),

                  ),
        ),
      
      Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [

            Text(
              "Welcome back",
              style: GoogleFonts.rubik(
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
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Remember Me",style: TextStyle(
              fontSize: 11,color: const Color.fromARGB(255, 4, 46, 4) ,fontWeight: FontWeight.bold
              )),
              SizedBox(
                width: 20 
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Forgot Password",style: TextStyle(
                fontSize: 12,color: const Color.fromARGB(255, 4, 46, 4) ,fontWeight: FontWeight.bold
              ),
              ),
              SizedBox(
                height: 120 ,
              ),
          ]),
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