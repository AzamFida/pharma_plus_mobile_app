import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pharmaplus_flutter/providers/theme_provider.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isRequired;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    // 🎨 Dynamic colors
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final labelColor = isDarkMode ? Colors.white70 : Colors.black87;
    final fillColor = isDarkMode
        ? Colors
              .white10 // semi-transparent dark
        : Colors.grey.shade100; // soft light background
    final borderColor = isDarkMode
        ? Colors.white54
        : const Color.fromARGB(255, 180, 180, 180);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: TextStyle(color: textColor),
          labelStyle: TextStyle(fontSize: 16, color: labelColor),
          filled: true,
          fillColor: fillColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (isRequired && (value == null || value.isEmpty)) {
            return 'Required';
          }
          if (keyboardType == TextInputType.number &&
              double.tryParse(value!) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}
