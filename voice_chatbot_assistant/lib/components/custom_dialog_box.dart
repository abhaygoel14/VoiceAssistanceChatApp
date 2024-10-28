import 'package:flutter/material.dart';
import 'package:voice_chatbot_assistant/components/custom_button.dart';

void connectionErrorCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const CustomLoadingDialog();
    },
  );
}

class CustomLoadingDialog extends StatefulWidget {
  const CustomLoadingDialog({super.key});

  @override
  _CustomLoadingDialogState createState() => _CustomLoadingDialogState();
}

class _CustomLoadingDialogState extends State<CustomLoadingDialog> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a 3-4 second delay before showing the actual content
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _onConnectAccountPressed() {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    // Simulate a delay to show the loading indicator again
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      title: _isLoading
          ? const SizedBox(
        height: 50,
      ):Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the image
        children: [
          Image.asset(
            'images/error_logo.png', // Path to your asset image
            height: 80, // Adjust size as needed
            width: 80,
          ),
        ],
      ),
      content: _isLoading
          ? const SizedBox(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      )
          : const Text(
        "It seems like your account isn't connected.",
        textAlign: TextAlign.left,
      ),
      actions: _isLoading
          ? []
          : [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space buttons evenly
          children: [
            CustomButton(
              title: 'Later',
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            CustomButton(
              title: 'Connect Account',
              backgroundColor: Colors.cyan,
              onPressed: _onConnectAccountPressed, // Updated to show loading indicator again
            ),
          ],
        ),
      ],
    );
  }
}
