import 'package:flutter/material.dart';

import 'package:farmlink/officer/officer_notice_screen.dart';
import 'package:farmlink/officer/officer_chat_screen.dart';
import 'package:farmlink/officer/officer_profile_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class OfficerRootScreen extends StatefulWidget {
  @override
  _OfficerRootScreenState createState() => _OfficerRootScreenState();
}

class _OfficerRootScreenState extends State<OfficerRootScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    OfficerNoticeScreen(),
    ChatScreen(),
    OfficerProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 9, 72, 13),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notices'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Home Screen with Search Bar




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  List<dynamic> farmers = [];
  List<dynamic> filteredFarmers = [];

  @override
  void initState() {
    super.initState();
    fetchFarmers();
  }

  Future<void> fetchFarmers() async {
    try {
      final response = await http.get(Uri.parse('YOUR_BACKEND_URL/list_view/'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          farmers = data['data'];
          filteredFarmers = farmers;
        });
      } else {
        print('Failed to load farmers');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void filterFarmers(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredFarmers = farmers;
      } else {
        filteredFarmers = farmers
            .where((farmer) =>
                farmer['id'].toString().contains(query) ||
                (farmer['methods'] ?? 'Unknown')
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farmers List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: filterFarmers,
              decoration: InputDecoration(
                hintText: 'Search Farmers...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF094F0C)),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            searchQuery = "";
                            filteredFarmers = farmers;
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Color(0xFFC3E08B),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredFarmers.isEmpty
                ? Center(
                    child: Text(
                      searchQuery.isEmpty
                          ? 'No Farmers Registered'
                          : 'No results for "$searchQuery"',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredFarmers.length,
                    itemBuilder: (context, index) {
                      final farmer = filteredFarmers[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(farmer['id'].toString()),
                        ),
                        title: Text('ID: ${farmer['id']}'),
                        subtitle: Text(
                            'Method: ${farmer['methods'] ?? "Unknown"}'), // Handle null case
                        trailing: Icon(Icons.arrow_forward_ios),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
