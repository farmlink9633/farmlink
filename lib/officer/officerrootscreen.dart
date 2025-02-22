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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 84, 129, 78),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 64, 92, 66),
        unselectedItemColor: Colors.grey,
         
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