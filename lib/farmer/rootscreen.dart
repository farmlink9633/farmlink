import 'package:flutter/material.dart';
class Rootscreen extends StatefulWidget {
  @override
  _RootscreenState createState() => _RootscreenState();
}

class _RootscreenState extends State<Rootscreen> {
  int _selectedIndex = 0;

  // List of widget options corresponding to the bottom navigation items
  static const List<Widget> _widgetOptions = <Widget>[
    ScreenContent(title: 'Home Screen', color: Colors.green), // Home is green
    ScreenContent(title: 'Product Screen', color: Colors.orange), // Product remains orange
    ScreenContent(title: 'Chat Screen', color: Colors.green), // Chat is green
    ScreenContent(title: 'Profile Screen', color: Colors.green), // Profile is green
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Bar Example'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex), // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: const Color.fromARGB(255, 7, 25, 7),
        onTap: _onItemTapped, // Handle tap on bottom navigation items
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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), // Add some opacity for background color
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
