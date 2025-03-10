import 'dart:convert';
import 'package:farmlink/officer/officer_notice_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

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
    print('farmer');
    fetchFarmers();
  }

  Future<void> fetchFarmers() async {
    try {
      final response = await http.get(Uri.parse('$baseurl/list/'));
      print(response.body);

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
                (farmer['profile']['username'] ?? 'Unknown')
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
        title: Text(
          'Farmers List',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
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
                hintStyle: GoogleFonts.poppins(), // Apply Poppins to hint text
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: const Color.fromARGB(255, 35, 79, 29),
                        ),
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
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.black),
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
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredFarmers.length,
                    itemBuilder: (context, index) {
                      final farmer = filteredFarmers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              farmer['id'].toString(),
                              style: GoogleFonts.poppins(), // Apply Poppins
                            ),
                          ),
                          title: Text(
                            farmer['profile']['username'] ?? "Unknown", // Display the farmer's name
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID: ${farmer['id']}',
                                style: GoogleFonts.poppins(), // Apply Poppins
                              ),
                              Text(
                                'Location: ${farmer['location'] ?? "Unknown"}',
                                style: GoogleFonts.poppins(), // Apply Poppins
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
