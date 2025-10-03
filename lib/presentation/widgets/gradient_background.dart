import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 45, 44, 45),
            Color.fromARGB(255, 45, 44, 45),
            Color.fromARGB(255, 45, 44, 45),
          ],
        ),
      ),
      child: child,
    );
  }
}
