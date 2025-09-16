import 'package:flutter/material.dart';

class CustomInputFieldWidget extends StatefulWidget {
  final String? label;
  final String? hintText;
  final double? hintFontSize;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final double? height;
  final double? width;
  final int? maxLines;
  final bool showErrorBelow;
  final Widget Function(String error)? errorBuilder;
  final void Function(String)? onChanged;

  const CustomInputFieldWidget({
    super.key,
    this.label,
    this.hintText,
    this.hintFontSize,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.height,
    this.width,
    this.maxLines = 1,
    this.showErrorBelow = true,
    this.errorBuilder,
    this.onChanged,
  });

  @override
  State<CustomInputFieldWidget> createState() => _CustomInputFieldWidgetState();
}

class _CustomInputFieldWidgetState extends State<CustomInputFieldWidget> {
  late final ValueNotifier<bool> _obscureNotifier;
  String? _customErrorText;

  @override
  void initState() {
    super.initState();
    _obscureNotifier = ValueNotifier<bool>(widget.obscureText);
  }

  @override
  void dispose() {
    _obscureNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double effectiveWidth = widget.width ?? screenWidth * 0.85;
    final double effectiveHeight =
        widget.height ?? (widget.maxLines == 1 ? screenHeight * 0.06 : 60);
    final double fontSize = widget.hintFontSize ?? 14;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: screenHeight * 0.02,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: effectiveWidth,
          child: Column(
            children: [
              SizedBox(
                height: effectiveHeight,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _obscureNotifier,
                  builder: (context, isObscure, _) {
                    return TextFormField(
                      controller: widget.controller,
                      obscureText: isObscure,
                      validator: (value) {
                        final error = widget.validator?.call(value);
                        if (widget.showErrorBelow) {
                          setState(() {
                            _customErrorText = error;
                          });
                          return error == null ? null : '';
                        }
                        return error;
                      },
                      keyboardType: widget.keyboardType,
                      maxLines: widget.maxLines,
                      style: TextStyle(fontSize: fontSize, color: Colors.black),
                      cursorHeight: fontSize + 6,
                      cursorWidth: 2,
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? '',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 196, 185, 254),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        errorStyle: const TextStyle(height: 0, fontSize: 0),
                        suffixIcon: widget.obscureText
                            ? IconButton(
                                icon: Icon(
                                  isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color.fromARGB(
                                    255,
                                    104,
                                    101,
                                    124,
                                  ),
                                ),
                                onPressed: () {
                                  _obscureNotifier.value = !isObscure;
                                },
                              )
                            : null,
                      ),
                      onChanged: widget.onChanged,
                    );
                  },
                ),
              ),
              if (widget.showErrorBelow && _customErrorText != null) ...[
                const SizedBox(height: 5),
                widget.errorBuilder != null
                    ? widget.errorBuilder!(_customErrorText!)
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _customErrorText!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
