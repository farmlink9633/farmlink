import 'package:farmlink/authscreens/register.dart';
import 'package:farmlink/officer/officer_admin_add_screen.dart';
import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Role'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRoleButton(
              context,
              icon: Icons.agriculture,
              label: 'Farmer',
              color: Colors.green,
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
              color: const Color.fromARGB(255, 153, 201, 69),
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



