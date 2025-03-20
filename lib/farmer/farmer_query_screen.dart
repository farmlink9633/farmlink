import 'package:farmlink/farmer/farmer_chat_screen.dart';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date formatting

class FarmerChatScreen extends StatefulWidget {
  final String officerId;
  final String farmerId;

  const FarmerChatScreen({super.key, required this.officerId, required this.farmerId});

  @override
  _FarmerChatScreenState createState() => _FarmerChatScreenState();
}

class _FarmerChatScreenState extends State<FarmerChatScreen> {
  List<dynamic> messages = [];
  bool isLoading = true;
  bool isNavigating = false; // Track button loading state

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final url = Uri.parse('$baseurl/chatview/?officerid=${widget.officerId}&farmerid=${widget.farmerId}');
    final response = await http.get(url);
    print(response.body); // Debugging: Print API response

    if (response.statusCode == 200) {
      setState(() {
        messages = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load messages')),
      );
    }
  }

  void navigateToQueryScreen() async {
    setState(() {
      isNavigating = true; // Show loading indicator
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulating delay

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QueryScreen(officer_id: widget.officerId),
        ),
      ).then((_) {
        setState(() {
          isNavigating = false; // Hide loading indicator after returning
        });
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
          'Chat',
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isFarmer = message['is_farmer'] == true; // Check if the message is from the farmer
                      final createdAt = message['created_at']; // Get the 'created_at' field
                      print('Message $index - created_at: $createdAt'); // Debugging

                      // Handle null and convert UTC to local time
                      final dateTime = createdAt != null
                          ? DateTime.parse(createdAt).toLocal() // Convert to local time
                          : null; // Handle null case
                      final formattedDate = dateTime != null
                          ? DateFormat('MMM d, yyyy hh:mm a').format(dateTime) // Format local time
                          : 'No date available'; // Provide a fallback for null dates

                      return Column(
                        children: [
                          // Farmer's Chat (Right Side)
                          if (isFarmer)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                  child: Card(
                                    color: const Color.fromARGB(255, 200, 224, 195), // Farmer's message color
                                    margin: const EdgeInsets.all(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message['content'] ?? 'No message',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          if (message['image'] != null)
                                            Image.network(
                                              '$baseurl${message['image']}',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          const SizedBox(height: 4),
                                          Text(
                                            formattedDate,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: const Color.fromARGB(255, 89, 112, 89), // Change date color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          // Officer's Reply (Left Side)
                          if (!isFarmer)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                                  child: Card(
                                    color: const Color.fromARGB(255, 229, 243, 226), // Officer's reply color
                                    margin: const EdgeInsets.all(8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            message['content'] ?? 'No message',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          if (message['image'] != null)
                                            Image.network(
                                              '$baseurl${message['image']}',
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          const SizedBox(height: 4),
                                          Text(
                                            formattedDate,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: const Color.fromARGB(255, 89, 112, 89), // Change date color
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: isNavigating ? null : navigateToQueryScreen, // Disable when loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 116, 140, 107),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isNavigating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 125, 150, 127),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Chat with Officer',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}