import 'package:farmlink/authscreens/register.dart';
import 'package:farmlink/officer/officer_admin_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        title: Text(
          'Select Your Role',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to FarmLink',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 88, 101, 83),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Please choose your role to continue',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 40),
            _buildRoleButton(
              context,
              icon: Icons.agriculture,
              label: 'Farmer',
              color: const Color.fromARGB(255, 112, 127, 113),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registration()), // Navigate to Farmer Screen
                );
              },
            ),
            SizedBox(height: 20),
            _buildRoleButton(
              context,
              icon: Icons.admin_panel_settings,
              label: 'Officer',
              color: const Color.fromARGB(255, 116, 143, 119),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OfficerRegistrationScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context,
      {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 30),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }
}