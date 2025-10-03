import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String get emailText => emailController.text;
  String get passwordText => passwordController.text;

  /// 🔹 Clear all fields
  void clearFields() {
    emailController.clear();
    passwordController.clear();
    notifyListeners(); // optional (useful if you rebuild UI on clear)
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
