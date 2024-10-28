import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? backgroundColor; // Optional background color parameter

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor, // Initialize with a default of null
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        side: const BorderSide(color: Colors.grey), // Border color
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        backgroundColor: backgroundColor ?? Colors.transparent, // Use provided background color or transparent
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black, // Text color
          fontSize: 14,
        ),
      ),
    );
  }
}