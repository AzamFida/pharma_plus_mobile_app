import 'package:flutter/material.dart';

class SignupProvider with ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  String get emailText => emailController.text;
  String get passwordText => passwordController.text;
  String get repeatPasswordText => repeatPasswordController.text;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }
}
