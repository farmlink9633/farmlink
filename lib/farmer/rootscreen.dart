import 'dart:io';

import 'package:farmlink/farmer/farmer_chat_screen';
import 'package:farmlink/farmer/farmer_product_screen.dart';
import 'package:farmlink/farmer/farmerprofilescreen.dart';
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
    Scaffold(),
    const ScreenContent(title: 'Chat Screen', color: Colors.blue),
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
      appBar: AppBar(
        title: const Text('Welcome')
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: const Color.fromARGB(255, 8, 86, 14),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';

  // Method to handle the plant disease detection
  void _openDiseaseDetection() {
    // Navigate to the disease detection screen (can be a new page or dialog)
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Plant Disease Detection'),
          content: Text('This is a feature for detecting plant diseases using the camera.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  File? _image; // To store the captured image
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance


    /// Method to handle camera permissions and image capture
  Future<void> openCamera() async {
    // Request camera permission
    final permissionStatus = await Permission.camera.request();

    if (permissionStatus.isGranted) {
      try {
        // Open the camera and capture an image
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path); // Update the UI with the captured image
          });
        } else {
          print('No image captured.');
        }
      } catch (e) {
        print('Error capturing image: $e');
      }
    } else {
      print('Camera permission denied');
      _showPermissionDeniedDialog(); // Show a dialog if permission is denied
    }
  }

  /// Show a dialog when camera permission is denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Camera access is required to capture images.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search,color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 191, 213, 184),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value; // Update search query
              });
            },
          ),
        ),
                // Plant Disease Detection Button
        Padding(
          padding: const EdgeInsets.all(60.0),
          child: ElevatedButton.icon(
            onPressed: openCamera,
            icon: Icon(Icons.camera_alt,color: Colors.black), // Camera icon
            label: Text('Detect Plant Disease'),
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 49, 88, 45), padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
               backgroundColor: const Color.fromARGB(255, 217, 233, 221), // White text
            ),
          ),
        ),

        // Content Below the Search Bar
        Expanded(
          child: Center(
            child: Text(
              searchQuery.isEmpty
                  ? 'Type something to search!'
                  : 'Search Query: $searchQuery',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ),
        ),
      ],
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
