import 'package:flutter/material.dart';
import 'package:pharmaplus_flutter/presentation/screens/medicine_list_screen.dart';
import 'package:pharmaplus_flutter/presentation/widgets/custom_buttons.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 141, 255),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MedicineListScreen()),
                );
              },
              backgroundColor: Colors.white,
              text: "Login",
              textColor: Colors.black,
            ),
            CustomButton(
              border: Border.all(color: Colors.white, width: 1),
              onPressed: () {},
              backgroundColor: const Color.fromARGB(255, 235, 133, 253),
              text: "Sign Up",
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
