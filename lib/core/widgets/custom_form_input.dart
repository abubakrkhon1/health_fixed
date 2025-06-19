import 'package:flutter/material.dart';

class CustomFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? obscureText;
  final String? Function(String?)? validator;

  const CustomFormInput({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        obscureText: obscureText!,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }
}
