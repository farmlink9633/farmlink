import 'dart:convert';
import 'package:farmlink/officer/officer_replyscreen.dart'; // Ensure this import is correct
import 'package:farmlink/utils.dart'; // Ensure this import is correct
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart'; // For image zooming

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
      farmerName: json['farmer']?['profile']['username'].toString() ?? 'Unknown Farmer',
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
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: const Color.fromARGB(255, 116, 140, 107),
              ),
            ) // Loading Indicator
          : isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load queries',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchQueries,
                        child: Text(
                          'Retry',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 116, 140, 107),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: queryList.length,
                  itemBuilder: (context, index) {
                    final query = queryList[index];
                    return Card(
                      color: const Color.fromARGB(255, 202, 216, 201), // Color of the queries box
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              query.farmerName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              query.content,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                              ),
                            ),
                            if (query.imageUrl != null)
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        appBar: AppBar(
                                          title: Text(
                                            'Image Preview',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        body: PhotoView(
                                          imageProvider: NetworkImage(baseurl + query.imageUrl!),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Image.network(
                                    baseurl + query.imageUrl!,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReplyScreen(query: query),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Reply',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 106, 126, 99), // Color of the reply button
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}