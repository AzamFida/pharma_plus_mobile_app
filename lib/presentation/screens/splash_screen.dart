import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/screens/login_screen.dart';
import 'package:pharmaplus_flutter/presentation/screens/signup_screen.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_buttons.dart';
import 'package:pharmaplus_flutter/presentation/widgets/gradient_background.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).isDarkMode;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🌟 Logo Animation (Fade + Slide from Top)
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Image.asset("assets/logo/logo.png"),
              ),

              const SizedBox(height: 40),

              /// 💫 Login Button Animation (Slide from Top)
              SlideInDown(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 300),
                child: CustomButton(
                  border: Border.all(
                    color: theme ? Colors.black : Colors.white,
                    width: 1,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  backgroundColor: Colors.blue,
                  text: "Login",
                  textColor: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              /// ⚡ Sign Up Button Animation (Slide from Top with Delay)
              SlideInDown(
                duration: const Duration(milliseconds: 800),
                delay: const Duration(milliseconds: 500),
                child: CustomButton(
                  border: Border.all(
                    color: theme ? Colors.black : Colors.white,
                    width: 1,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  backgroundColor: Colors.lightBlue,
                  text: "Sign Up",
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
