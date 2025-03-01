import 'package:farmlink/farmer/farmer_chat_screen.dart';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    print(response.body);

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
                      return ListTile(
                        title: Text(
                          messages[index]['content'] ?? 'No message',
                          style: GoogleFonts.poppins(),
                        ),
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
                        color: Colors.white,
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
