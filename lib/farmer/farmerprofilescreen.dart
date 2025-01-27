import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700], // Green color for AppBar
        title: Text("Profile", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add settings functionality here
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img.freepik.com/free-vector/leaves-background-with-metallic-foil_79603-914.jpg?semt=ais_hybrid'), // Leaf background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView( // Makes the screen scrollable in case of overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture with shadow and round container
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://www.w3schools.com/w3images/avatar2.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Name in a container with padding for better spacing
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[50], // Slight green background
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "John Doe",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700], // Green text color
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Email with a lighter green shade
                Center(
                  child: Text(
                    "johndoe@example.com",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green[500], // Lighter green for email
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Custom Divider with Icon
                _buildDividerWithIcon("Contact Information"),
                SizedBox(height: 20),
                // Info Rows with icons inside a card for more prominence
                _buildInfoRow(Icons.phone, "Phone", "+1 234 567 890"),
                _buildInfoRow(Icons.credit_card, "Aadhar Number", "XXXX-XXXX-XXXX"),
                SizedBox(height: 20),
                // Log out button with gradient and rounded corners
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green[600], // Green button color
                      shadowColor: Colors.green[700], // Green shadow color
                      elevation: 12, // More elevation for the button
                    ),
                    onPressed: () {
                      // Log out or perform any action here
                    },
                    child: Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for the info rows with icons and Card styling for better prominence
  Widget _buildInfoRow(IconData icon, String title, String info) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5, // Higher elevation for prominence
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 30), // Icon next to text
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green[800], // Darker green for titles
          ),
        ),
        trailing: Text(
          info,
          style: TextStyle(
            fontSize: 16,
            color: Colors.green[600], // Lighter green for info
          ),
        ),
      ),
    );
  }

  // Custom Divider with Icon
  Widget _buildDividerWithIcon(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.green[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: const Color.fromARGB(255, 65, 171, 70), // Green color for section title
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.green[300])),
      ],
    );
  }
}
