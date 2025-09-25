import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_input_field.dart';
import 'package:pharmaplus_flutter/providers/signup_provider.dart';
import 'package:pharmaplus_flutter/providers/email_auth_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // Access providers directly (provided by MultiProvider in main.dart)
    final signupProvider = Provider.of<SignupProvider>(context);
    final authProvider = Provider.of<EmailAuthProvider>(context);

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0BBFF), Color(0xFFC2A3FF), Color(0xFFA0C4FF)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.12),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.08,
                    ),
                  ),
                  Text(
                    "to get started now!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.06,
                    ),
                  ),
                  SizedBox(height: height * 0.05),

                  // Email Field
                  CustomInputFieldWidget(
                    hintText: "Email Address",
                    controller: signupProvider.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),

                  // Password Field
                  CustomInputFieldWidget(
                    hintText: "Password",
                    obscureText: true,
                    controller: signupProvider.passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),

                  // Confirm Password Field
                  CustomInputFieldWidget(
                    hintText: "Confirm Password",
                    obscureText: true,
                    controller: signupProvider.repeatPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != signupProvider.passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.03),

                  // Signup Button
                  authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = await authProvider.signUpWithEmail(
                                email: signupProvider.emailText,
                                password: signupProvider.passwordText,
                                context: context,
                              );

                              if (user != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Verification email sent! Please check your inbox.",
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              } else if (authProvider.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage!),
                                  ),
                                );
                              }
                            }
                          },
                          color: Colors.white,
                          minWidth: width * 0.8,
                          height: height * 0.06,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(height * 0.01),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.06,
                            ),
                          ),
                        ),

                  SizedBox(height: height * 0.05),

                  // Already have account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontSize: width * 0.04,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Login Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: width * 0.04,
                            decorationColor: Colors.white,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
