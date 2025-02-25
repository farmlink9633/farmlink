import 'package:flutter/material.dart';
import 'package:farmlink/officer/officer_homescreen.dart';
import 'package:farmlink/officer/officer_notice_screen.dart';
import 'package:farmlink/officer/officer_chat_screen.dart';
import 'package:farmlink/officer/officer_profile_screen.dart';

class OfficerRootScreen extends StatefulWidget {
  @override
  _OfficerRootScreenState createState() => _OfficerRootScreenState();
}

class _OfficerRootScreenState extends State<OfficerRootScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    OfficerHomescreen(),
    OfficerNoticeScreen(),
    OfficerQueryListScreen(),
    OfficerProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building OfficerRootScreen"); // Debugging statement

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent the screen from resizing when the keyboard appears
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107), // Set the background color
        currentIndex: _selectedIndex, // Set the currently selected index
        onTap: _onItemTapped, // Handle item taps
        selectedItemColor: const Color.fromARGB(255, 64, 92, 66), // Color for the selected item
        unselectedItemColor: Colors.grey, // Color for unselected items
        type: BottomNavigationBarType.fixed, // Ensure all items are visible
        elevation: 0, // Remove elevation/shadow
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notices'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}