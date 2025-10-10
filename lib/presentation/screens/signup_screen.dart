import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pharmaplus_flutter/presentation/screens/login_screen.dart';
import 'package:pharmaplus_flutter/presentation/widgets/animation_widget.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_input_field.dart';
import 'package:pharmaplus_flutter/presentation/widgets/gradient_background.dart';
import 'package:pharmaplus_flutter/providers/login_providers.dart';
import 'package:pharmaplus_flutter/providers/signup_provider.dart';
import 'package:pharmaplus_flutter/providers/email_authenticafion_provider.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final signupProvider = Provider.of<SignupProvider>(context);
    final authProvider = Provider.of<EmailAuthenticationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).isDarkMode;

    return GradientBackground(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: SizedBox(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.04),

                    // 🌟 Logo Animation (optional)
                    BounceInDown(
                      duration: const Duration(milliseconds: 1500),
                      child: Image.asset(
                        "assets/logo/logo.png",
                        height: height * 0.27,
                      ),
                    ),
                    SizedBox(height: height * 0.01),

                    // Title Animation
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: theme ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.08,
                        ),
                      ),
                    ),

                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      child: Text(
                        "to get started now!",
                        style: TextStyle(
                          color: theme ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.06,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.05),

                    // Email Field
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      child: CustomInputFieldWidget(
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
                    ),
                    SizedBox(height: height * 0.02),

                    // Password Field
                    FadeInLeft(
                      delay: const Duration(milliseconds: 400),
                      child: CustomInputFieldWidget(
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
                    ),
                    SizedBox(height: height * 0.02),

                    // Confirm Password Field
                    FadeInLeft(
                      delay: const Duration(milliseconds: 500),
                      child: CustomInputFieldWidget(
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
                    ),
                    SizedBox(height: height * 0.06),

                    // Signup Button
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: authProvider.isLoading
                          ? CircularProgressIndicator(
                              color: theme ? Colors.white : Colors.black,
                            )
                          : MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final user = await authProvider
                                      .signUpWithEmail(
                                        email: signupProvider.emailText,
                                        password: signupProvider.passwordText,
                                        context: context,
                                      );

                                  if (user != null) {
                                    Provider.of<SignupProvider>(
                                      context,
                                      listen: false,
                                    ).clearFields();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Verification email sent! Please check your inbox.",
                                        ),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else if (authProvider.errorMessage !=
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          authProvider.errorMessage ?? "",
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              color: Colors.blue,
                              minWidth: width * 0.9,
                              height: height * 0.06,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: theme ? Colors.black : Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(
                                  height * 0.01,
                                ),
                              ),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.05,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: height * 0.05),

                    // Already have an account
                    FadeInUp(
                      delay: const Duration(milliseconds: 700),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: width * 0.042,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                createFadeScaleRoute(const LoginScreen()),
                              );
                              Provider.of<SignupProvider>(
                                context,
                                listen: false,
                              ).clearFields();
                            },
                            child: Text(
                              "Login Now",
                              style: TextStyle(
                                color: theme
                                    ? Colors.white
                                    : const Color.fromARGB(255, 89, 89, 89),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                fontSize: width * 0.04,
                                decorationColor: theme
                                    ? Colors.white
                                    : const Color.fromARGB(255, 88, 88, 88),
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
