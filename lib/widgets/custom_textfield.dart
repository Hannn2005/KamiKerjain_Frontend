import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      child: TextFormField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: AppColors.biruNavy, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: AppColors.biruNavy, width: 2.0),
          ),
        ),
      ),
    );
  }
}