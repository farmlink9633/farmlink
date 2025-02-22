import 'dart:convert';
import 'dart:io';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OfficerHomescreen extends StatefulWidget {
  @override
  _OfficerHomeScreenState createState() => _OfficerHomeScreenState();
}

class _OfficerHomeScreenState extends State<OfficerHomescreen> {
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
      final response = await http.get(Uri.parse('$baseurl/list/'));
      
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
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: filterFarmers,
              decoration: InputDecoration(
                hintText: 'Search Farmers...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: const Color.fromARGB(255, 35, 79, 29)),
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
                fillColor: const Color.fromARGB(236, 215, 228, 212),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.black), // Set border color to black
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.black), // Set border color to black
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.black), // Set border color to black
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