import 'package:farmlink/authscreens/login.dart';
import 'package:farmlink/authscreens/register.dart';
import 'package:farmlink/authscreens/splashscreen.dart';
import 'package:farmlink/officer/officer_admin_add_screen.dart';
import 'package:farmlink/officer/officer_rootscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     
      home:OfficerRootScreen ()
    );
  }
}
