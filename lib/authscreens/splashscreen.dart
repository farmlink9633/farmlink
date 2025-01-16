import 'package:flutter/material.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: 
            BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover ,
                image:NetworkImage(
              "https://img3.wallspic.com/previews/0/0/4/3/3/133400/133400-light-water-leaf-darkness-black-x750.jpg"))
        ),
            )
      ]),
    );
  }
}
