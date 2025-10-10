import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/screens/medicine_list_screen.dart';
import 'package:pharmaplus_flutter/presentation/screens/signup_screen.dart';
import 'package:pharmaplus_flutter/presentation/widgets/gradient_background.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_input_field.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_buttons.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';
import 'package:pharmaplus_flutter/providers/login_providers.dart';
import 'package:pharmaplus_flutter/providers/google_signin_provider.dart';
import 'package:pharmaplus_flutter/providers/email_authenticafion_provider.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart'; // ✅ animate_do package

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

    final loginProvider = Provider.of<LoginProvider>(context);
    final authProvider = Provider.of<EmailAuthenticationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).isDarkMode;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: height * 0.12),

                /// ✨ Animated Header
                FadeInDown(
                  duration: const Duration(milliseconds: 1000),
                  child: Column(
                    children: [
                      Text(
                        "Welcome,",
                        style: TextStyle(
                          color: theme ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.08,
                        ),
                      ),
                      Text(
                        "Glad to see you!",
                        style: TextStyle(
                          color: theme ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: width * 0.07,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.06),

                /// ⚠️ Error message with bounce
                if (_errorMessage != null)
                  BounceInDown(
                    child: Padding(
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
                  ),

                SizedBox(height: height * 0.03),

                /// 📧 Email Field Animation
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 800),
                  child: CustomInputFieldWidget(
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
                ),

                SizedBox(height: height * 0.02),

                /// 🔑 Password Field Animation
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 800),
                  child: CustomInputFieldWidget(
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
                ),

                SizedBox(height: height * 0.07),

                /// 🔘 Login Button Animation
                ZoomIn(
                  delay: const Duration(milliseconds: 700),
                  duration: const Duration(milliseconds: 600),
                  child: authProvider.isLoading
                      ? CircularProgressIndicator(
                          color: theme ? Colors.white : Colors.black,
                        )
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
                                    builder: (_) => const MedicineListScreen(),
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
                          color: Colors.blue,
                          minWidth: width * 0.9,
                          height: height * 0.06,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(height * 0.01),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.05,
                            ),
                          ),
                        ),
                ),

                SizedBox(height: height * 0.06),

                /// Divider Animation
                FadeIn(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: height * 0.002,
                        width: width * 0.2,
                        color: theme ? Colors.white : Colors.black,
                      ),
                      Text(
                        "  Or Login with  ",
                        style: TextStyle(
                          color: theme ? Colors.white : Colors.black,
                          fontSize: width * 0.04,
                        ),
                      ),
                      Container(
                        height: height * 0.002,
                        width: width * 0.2,
                        color: theme ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.05),

                /// 🌐 Google Login Animation
                SlideInUp(
                  delay: const Duration(milliseconds: 1000),
                  duration: const Duration(milliseconds: 800),
                  child: GestureDetector(
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
                                    const MedicineListScreen(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: height * 0.06,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(height * 0.01),
                        border: Border.all(
                          color: theme ? Colors.white : Colors.black,
                          width: 1,
                        ),
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
                ),

                SizedBox(height: height * 0.08),

                /// 🧾 Sign-up Redirect Animation
                FadeInUp(
                  delay: const Duration(milliseconds: 1200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: width * 0.04,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignupScreen()),
                          );
                          Provider.of<LoginProvider>(
                            context,
                            listen: false,
                          ).clearFields();
                        },
                        child: Text(
                          "Sign Up Now",
                          style: TextStyle(
                            color: theme
                                ? Colors.white
                                : const Color.fromARGB(255, 77, 76, 76),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: width * 0.04,
                            decorationColor: theme
                                ? Colors.white
                                : const Color.fromARGB(255, 80, 79, 79),
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
    );
  }
}
