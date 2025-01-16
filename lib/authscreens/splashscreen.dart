import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [

        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://img3.wallspic.com/previews/0/0/4/3/3/133400/133400-light-water-leaf-darkness-black-x750.jpg"))),
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
                  Text("Your plants",
                      style: GoogleFonts.nunito(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 10
                  ),
                  Text("deserves the",
                      style: GoogleFonts.nunito(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text("best care",
                      style: GoogleFonts.nunito(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 110,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(350, 15)),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            fontSize: 17,
                            color: const Color.fromARGB(255, 4, 46, 4)),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 4, 46, 4),
                        fixedSize: Size(350, 15)),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
