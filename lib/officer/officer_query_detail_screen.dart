// import 'package:farmlink/officer/officer_chat_screen.dart';
// import 'package:farmlink/officer/officer_replyscreen.dart';
// import 'package:farmlink/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:farmlink/officer/officer_query_detail_screen.dart';

// class Query {
//   final int id;
//   final String content;
//   final String? imageUrl;
//   final int farmerId;
//   final String farmerName; // Farmer's name from profile
//   final String farmerLocation;
//   final String farmerMethods;
//   final bool isAskedByFarmer;

//   Query({
//     required this.id,
//     required this.content,
//     this.imageUrl,
//     required this.farmerId,
//     required this.farmerName,
//     required this.farmerLocation,
//     required this.farmerMethods,
//     required this.isAskedByFarmer,
//   });

//   factory Query.fromJson(Map<String, dynamic> json) {
//     return Query(
//       id: json['id'],
//       content: json['content'] ?? 'No content available',
//       imageUrl: json['image'] ?? null,
//       farmerId: json['farmer']?['id'] ?? 0,
//       farmerName: json['farmer']?['profile'] ?? 'Unknown Farmer', // Extract name from profile
//       farmerLocation: json['farmer']?['location'] ?? 'Unknown Location',
//       farmerMethods: json['farmer']?['methods'] ?? 'Unknown Methods',
//       isAskedByFarmer: json['is_askedbyfarmer'],
//     );
//   }
// }

// class QueryDetailScreen extends StatelessWidget {
//   final Query query;

//   const QueryDetailScreen({Key? key, required this.query}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(236, 215, 228, 212), // Background color for the scaffold
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 116, 140, 107), // App bar color
//         title: Text('Query Details'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Farmer ID: ${query.farmerId}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Text("Farmer Name: ${query.farmerName}", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 10),
//             Text("Location: ${query.farmerLocation}", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 10),
//             Text("Methods: ${query.farmerMethods}", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 10),
//             Text("Query: ${query.content}", style: TextStyle(fontSize: 16)),
//             SizedBox(height: 10),
//             if (query.imageUrl != null)
//               Image.network(query.imageUrl!, height: 200, fit: BoxFit.cover),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Navigate to the ReplyScreen
//                   // Navigator.push(
//                   //   context,
//                   //   MaterialPageRoute(
//                   //     builder: (context) => ReplyScreen(query: query),
//                   //   ),
//                   // );
//                 },
//                 child: Text('Reply'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

