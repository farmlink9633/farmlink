import 'package:flutter/material.dart';
import 'package:farmlink/utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:farmlink/farmer/farmer_chat_screen.dart'; // Import the QueryScreen

class Officer {
  final String name;
  final String designation;
  final String officeaddress;

  Officer({required this.name, required this.designation,required this.officeaddress});

  factory Officer.fromJson(Map<String, dynamic> json) {
    return Officer(
      name: json['name'] ?? 'Unknown',
      designation: json['designation'] ?? 'Unknown',
      officeaddress: json['officeaddress'] ?? 'Unknown',
    );
  }
}

class OfficerListScreen extends StatefulWidget {
  @override
  _OfficerListScreenState createState() => _OfficerListScreenState();
}

class _OfficerListScreenState extends State<OfficerListScreen> {
  List<Officer> _officers = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOfficers();
  }

  Future<void> fetchOfficers() async {
    final String url = '$baseurl/officerlist/'; // Replace with your API URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'success') {
          setState(() {
            _officers = (data['data'] as List).map((json) => Officer.fromJson(json)).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to load officers';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Officer List')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _officers.length,
                  itemBuilder: (context, index) {
                    final officer = _officers[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(officer.name, style: TextStyle(fontWeight: FontWeight.bold)),                        
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QueryScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
