import 'dart:convert';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Query {
  final int id;
  final String content;
  final String? imageUrl;
  final String farmerName;
  final bool isAskedByFarmer;

  Query({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.farmerName,
    required this.isAskedByFarmer,
  });

  factory Query.fromJson(Map<String, dynamic> json) {
    return Query(
      id: json['id'],
      content: json['content'] ?? 'No content available',
      imageUrl: json['image'] ?? null,
      farmerName: json['farmer']?['name'] ?? 'Unknown Farmer',
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
          ? Center(child: CircularProgressIndicator())  // Loading Indicator
          : isError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load queries', style: TextStyle(color: Colors.red)),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchQueries, 
                        child: Text('Retry')
                      )
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
                                child: Image.network(query.imageUrl!, height: 100, fit: BoxFit.cover),
                              ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QueryDetailScreen(query: query),
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

class QueryDetailScreen extends StatelessWidget {
  final Query query;

  const QueryDetailScreen({Key? key, required this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query Details')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Farmer: ${query.farmerName}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Query: ${query.content}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            if (query.imageUrl != null)
              Image.network(query.imageUrl!, height: 200, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
