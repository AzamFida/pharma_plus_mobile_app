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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo/logo.png"),
              CustomButton(
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
              CustomButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
