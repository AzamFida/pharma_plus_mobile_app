import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/screens/login_screen.dart';
import 'package:pharmaplus_flutter/presentation/screens/medicine_list_screen.dart';
import 'package:pharmaplus_flutter/presentation/screens/signup_screen.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_buttons.dart';
import 'package:pharmaplus_flutter/presentation/widgets/gradient_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/logo/logo.png"),
              CustomButton(
                border: Border.all(color: Colors.white, width: 1),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                backgroundColor: const Color.fromARGB(156, 183, 131, 250),
                text: "Login",
                textColor: Colors.white,
              ),
              CustomButton(
                border: Border.all(color: Colors.white, width: 1),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                backgroundColor: const Color.fromARGB(189, 224, 163, 252),
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
