import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/screens/login_screen.dart';

void showLogoutDialog(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: const Color.fromARGB(243, 123, 123, 123),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(
              Icons.logout,
              color: Color.fromARGB(255, 239, 150, 144),
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Confirm Logout',
              style: TextStyle(height: 1.4, color: Colors.white),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of this account?',
          style: TextStyle(fontSize: 16, height: 1.4, color: Colors.white),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        actions: [
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.cancel, size: 18),
            label: const Text('Cancel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 155, 153, 153),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(width: width * 0.1),
          ElevatedButton.icon(
            onPressed: () async {
              // 🔥 TODO: Add Firebase signOut
              await FirebaseAuth.instance.signOut();

              Navigator.of(context).pop(true); // close dialog
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      );
    },
  );
}
