import 'dart:convert';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Officer {
  final int id;
  final String designation;
  final String officeaddress;
  final Map profile;

  Officer( {required this.id, required this.designation, required this.officeaddress,required this.profile});

  factory Officer.fromJson(Map<String, dynamic> json) {
    return Officer(
      id: json['id'],
      designation: json['designation'],
      officeaddress: json['officeaddress'],
      profile: json['profile'],
    );
  }
}

class OfficerListScreen extends StatefulWidget {
  @override
  _OfficerListScreenState createState() => _OfficerListScreenState();
}

class _OfficerListScreenState extends State<OfficerListScreen> {
  List<Officer> officerList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOfficers();
  }

  Future<void> fetchOfficers() async {
    final response = await http.get(Uri.parse('$baseurl/officerlist/'));

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        officerList = data.map((json) => Officer.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load officers');
    }
  }

  void navigateToQueryScreen(BuildContext context, Officer officer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QueryScreen(officer: officer), // Navigate to QueryScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107), 
        title: Text(
        'Officer List',
        style: GoogleFonts.poppins(
              fontSize: 23,
              color: Colors.white,
            ),
        )
        ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: officerList.length,
              itemBuilder: (context, index) {
                final officer = officerList[index];
                return Card(
                  child: ListTile(
                    tileColor:const Color.fromARGB(235, 204, 215, 202), 
                    title: Text(officer.profile['']),
                    subtitle: Text(officer.officeaddress),
                    leading: CircleAvatar(child: Text(officer.id.toString())),
                    onTap: () => navigateToQueryScreen(context, officer), // Navigate on tap
                  ),
                );
              },
            ),
    );
  }
}

class QueryScreen extends StatelessWidget {
  final Officer officer;

  QueryScreen({required this.officer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Officer ID: ${officer.id}'),
            Text('Designation: ${officer.designation}'),
            Text('Office address: ${officer.officeaddress}'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OfficerListScreen(),
  ));
}