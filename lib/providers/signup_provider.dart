import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  String get emailText => emailController.text;
  String get passwordText => passwordController.text;
  String get repeatPasswordText => repeatPasswordController.text;

  /// 🔹 Clear all fields
  void clearFields() {
    emailController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
    notifyListeners(); // optional (if UI depends on changes)
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }
}
