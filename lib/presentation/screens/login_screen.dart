import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/screens/medicine_list_screen.dart';
import 'package:pharmaplus_flutter/presentation/screens/signup_screen.dart';
import 'package:pharmaplus_flutter/presentation/widgets/animation_widget.dart';
import 'package:pharmaplus_flutter/presentation/widgets/gradient_background.dart';
import 'package:provider/provider.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_input_field.dart';
import 'package:pharmaplus_flutter/providers/login_providers.dart';
import 'package:pharmaplus_flutter/providers/google_signin_provider.dart';
import 'package:pharmaplus_flutter/providers/email_authenticafion_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // Access existing providers from main.dart
    final loginProvider = Provider.of<LoginProvider>(context);
    final authProvider = Provider.of<EmailAuthenticationProvider>(context);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: width,
          height: height,

          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: height * 0.12),
                  Text(
                    "Welcome,",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.08,
                    ),
                  ),
                  Text(
                    "Glad to see you!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: width * 0.07,
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  SizedBox(height: height * 0.06),

                  // ✉️ Email Field
                  CustomInputFieldWidget(
                    hintText: "Email Address",
                    controller: loginProvider.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.015),

                  // 🔑 Password Field
                  CustomInputFieldWidget(
                    hintText: "Password",
                    controller: loginProvider.passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.07),

                  // 🔘 Login Button
                  authProvider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : MaterialButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = await authProvider.signInWithEmail(
                                email: loginProvider.emailText,
                                password: loginProvider.passwordText,
                                context: context,
                              );

                              if (user != null) {
                                Provider.of<LoginProvider>(
                                  context,
                                  listen: false,
                                ).clearFields();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MedicineListScreen(),
                                  ),
                                );
                              } else if (authProvider.errorMessage != null) {
                                setState(() {
                                  _errorMessage = "Incorrect email or password";
                                });
                                Provider.of<LoginProvider>(
                                  context,
                                  listen: false,
                                ).clearFields();
                              }
                            }
                          },
                          color: const Color.fromARGB(188, 189, 138, 244),
                          minWidth: width * 0.9,
                          height: height * 0.06,

                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(height * 0.01),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.05,
                            ),
                          ),
                        ),
                  SizedBox(height: height * 0.06),

                  // Divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.002,
                        width: width * 0.2,
                        color: Colors.white,
                      ),
                      Text(
                        "  Or Login with  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                        ),
                      ),
                      Container(
                        height: height * 0.002,
                        width: width * 0.2,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.05),

                  // 🌐 Google Login
                  GestureDetector(
                    onTap: () async {
                      final googleProvider = context
                          .read<GoogleSignInProvider>();
                      final user = await googleProvider.signInWithGoogle(
                        context,
                      );
                      if (user != null) {
                        Provider.of<LoginProvider>(
                          context,
                          listen: false,
                        ).clearFields();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Google sign-in successful"),
                          ),
                        );
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    MedicineListScreen(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: height * 0.065,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 211, 189, 255),
                        borderRadius: BorderRadius.circular(height * 0.01),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/logo/google.png",
                            height: height * 0.04,
                          ),
                          SizedBox(width: width * 0.02),
                          Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.08),

                  // 🧾 Sign-up Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 170, 113, 196),
                          fontSize: width * 0.04,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            createFadeScaleRoute(SignupScreen()),
                          );
                          Provider.of<LoginProvider>(
                            context,
                            listen: false,
                          ).clearFields();
                        },
                        child: Text(
                          "Sign Up Now",
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
