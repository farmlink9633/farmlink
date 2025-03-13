import 'dart:convert';
import 'package:farmlink/officer/officer_query_detail_screen.dart';
// import 'package:farmlink/officer/officer_query_reply_screen.dart';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Query {
  final int id;
  final String content;
  final String? imageUrl;
  final int farmerId;
  final String farmerName;
  final String farmerLocation;
  final String farmerMethods;
  final bool isAskedByFarmer;

  Query({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.farmerId,
    required this.farmerName,
    required this.farmerLocation,
    required this.farmerMethods,
    required this.isAskedByFarmer,
  });

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      id: json['id'],
      content: json['content'] ?? 'No content available',
      imageUrl: json['image'] ?? null,
      farmerId: json['farmer']?['id'] ?? 0,
      farmerName: json['farmer']?['profile']['username'].toString() ?? 'Unknown Farmer', // Assuming profile contains the name
      farmerLocation: json['farmer']?['location'] ?? 'Unknown Location',
      farmerMethods: json['farmer']?['methods'] ?? 'Unknown Methods',
      isAskedByFarmer: json['is_askedbyfarmer'],
    );
  }
}

class OfficerQueryListScreen extends StatefulWidget {
  @override
  _OfficerQueryListScreenState createState() => _OfficerQueryListScreenState();
}

class _OfficerQueryListScreenState extends State<OfficerQueryListScreen> {
  List<Query> queryList = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchQueries();
  }

  Future<void> fetchQueries() async {
    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse('$baseurl/officerquerylist/?officerid=9'));
      print(response.body);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          queryList = data.map((json) => Query.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load queries');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        title: Text(
          'Farmer Queries',
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading Indicator
          : isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load queries', style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchQueries,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: queryList.length,
                  itemBuilder: (context, index) {
                    final query = queryList[index];
                    return Card(
                      child: ListTile(
                        title: Text(query.farmerName, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(query.content),
                            if (query.imageUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Image.network(baseurl+query.imageUrl!, height: 100, fit: BoxFit.cover),
                              ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => QueryDetailScreen(query: query )
                          //   ),
                          // );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

