import 'dart:io';
import 'package:farmlink/farmer/farmer_chat_screen.dart';
import 'package:farmlink/farmer/farmer_home_screen.dart';
import 'package:farmlink/farmer/farmer_product_screen.dart';
import 'package:farmlink/farmer/farmerprofilescreen.dart';
import 'package:farmlink/farmer/officers_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
class Rootscreen extends StatefulWidget {
  @override
  _RootscreenState createState() => _RootscreenState();
}
class _RootscreenState extends State<Rootscreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    FarmersProductScreen(),
    OfficerListScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor:  const Color.fromARGB(236, 215, 228, 212),
      
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107), 
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.production_quantity_limits),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 6, 50, 10),
        unselectedItemColor: const Color.fromARGB(255, 199, 196, 196),
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}




class ScreenContent extends StatelessWidget {
  final String title;
  final Color color;

  const ScreenContent({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Rootscreen(),
  ));
}
