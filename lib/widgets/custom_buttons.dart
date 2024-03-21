import 'package:flutter/material.dart';
// import 'package:sign_in_button/sign_in_button.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final  TextStyle style;
  const CustomButton({super.key, required this.text, required this.onPressed, required this.style});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)))),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
