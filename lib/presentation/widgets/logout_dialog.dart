import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/screens/login_screen.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void showLogoutDialog(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final isDark = themeProvider.isDarkMode;
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  final isSmall = width < 380;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: isDark
            ? const Color.fromARGB(255, 71, 71, 71)
            : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),

        // 🧠 Title Section
        title: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.redAccent.shade200,
              size: width * 0.07,
            ),
            SizedBox(width: width * 0.025),
            Expanded(
              child: Text(
                'Confirm Logout',
                style: TextStyle(
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),

        // 📜 Content Section
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width * 0.8,
            maxHeight: height * 0.25,
          ),
          child: Text(
            'Are you sure you want to log out of this account?',
            style: TextStyle(
              fontSize: width * 0.04,
              height: 1.4,
              color: isDark ? Colors.grey[200] : Colors.black87,
            ),
          ),
        ),

        // 🎯 Action Buttons
        actions: [
          if (isSmall)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _cancelButton(context, isDark),
                const SizedBox(height: 10),
                _logoutButton(context),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: _cancelButton(context, isDark)),
                const SizedBox(width: 16),
                Expanded(child: _logoutButton(context)),
              ],
            ),
        ],
      );
    },
  );
}

// 🚫 Cancel Button
Widget _cancelButton(BuildContext context, bool isDark) {
  return ElevatedButton.icon(
    onPressed: () => Navigator.of(context).pop(false),
    icon: const Icon(Icons.cancel, size: 18),
    label: const Text('Cancel'),
    style: ElevatedButton.styleFrom(
      backgroundColor: isDark ? const Color(0xFF555555) : Colors.grey.shade300,
      foregroundColor: isDark ? Colors.white : Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  );
}

// 🔒 Logout Button
Widget _logoutButton(BuildContext context) {
  return ElevatedButton.icon(
    onPressed: () async {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pop(true);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    },
    icon: const Icon(Icons.logout, size: 18),
    label: const Text('Logout'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  );
}
