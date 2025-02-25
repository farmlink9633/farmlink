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
          ),
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoleButton(
              context,
              icon: Icons.agriculture,
              label: 'Farmer',
              color: const Color.fromARGB(255, 103, 175, 105),
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
              color: const Color.fromARGB(255, 123, 163, 54),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OfficerRegistrationScreen())
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
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 30),
      label: Text(label, style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}



