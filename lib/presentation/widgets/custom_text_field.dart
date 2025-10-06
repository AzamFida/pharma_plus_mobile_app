import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.characters,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
        ), // 🔹 this changes typed text color
        decoration: InputDecoration(
          labelText: label,
          floatingLabelStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
          filled: true,
          fillColor: Colors.white24, // Light blackish background
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 220, 220, 220),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 2),
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
