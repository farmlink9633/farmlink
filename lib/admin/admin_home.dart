import 'package:flutter/material.dart';

class Adminhomescreen extends StatelessWidget {
  const Adminhomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.search),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 4, 56, 4),
      
      ),
    );
  }
}