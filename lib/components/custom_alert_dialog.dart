import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  const CustomAlertDialog({
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Color(0xFF8F94A3),
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: Color(0xFF6E7491),
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: TextStyle(
              color: Color(0xFF4A44C6),
            ),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFE9E9FF)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
                side: BorderSide.none,
              ),
            ),
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
