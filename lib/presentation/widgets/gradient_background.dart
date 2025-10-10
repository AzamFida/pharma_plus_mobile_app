import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [
                  Color.fromARGB(173, 141, 140, 140),
                  Color.fromARGB(172, 249, 249, 249),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: child,
    );
  }
}
