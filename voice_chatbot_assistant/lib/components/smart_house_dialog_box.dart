import 'package:flutter/material.dart';
import 'package:voice_chatbot_assistant/components/custom_button.dart';

import 'custom_dialog_box.dart';

void smartHouseDialogBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const SmartHouseDialog();
    },
  );
}

class SmartHouseDialog extends StatefulWidget {
  const SmartHouseDialog({super.key});

  @override
  _SmartHouseDialogState createState() => _SmartHouseDialogState();
}

class _SmartHouseDialogState extends State<SmartHouseDialog> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a 3-second delay before showing the actual content
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false; // Update state to show the dialog content
      });
    });
  }

  void _onButtonPressed() {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    // Simulate a delay to show the loading indicator again
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false; // Update state to show dialog content
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Operate Your Smart House",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomButton(
            title: 'Turn on the living room lights.',
            onPressed: () {
              Navigator.of(context).pop();
              connectionErrorCustomDialog(context); // Show loading indicator on button press
            },
          ),
          const SizedBox(height: 8), // Spacing between buttons
          CustomButton(
            title: 'Set the AC to 24°C.',
            onPressed: () {
              Navigator.of(context).pop();
              connectionErrorCustomDialog(context); // Show loading indicator on button press
            },
          ),
          const SizedBox(height: 8), // Spacing between buttons
          CustomButton(
            title: 'Lock the front door.',
            onPressed: () {
              Navigator.of(context).pop();
              connectionErrorCustomDialog(context); // Show loading indicator on button press
            },
          ),
          const SizedBox(height: 8), // Spacing between buttons
          CustomButton(
            title: 'Play relaxing music in the bedroom.',
            onPressed: () {
              Navigator.of(context).pop();
              connectionErrorCustomDialog(context); // Show loading indicator on button press
            },
          ),
          const SizedBox(height: 8), // Spacing between buttons
          CustomButton(
            title: 'Check the security camera feed.',
            onPressed: () {
              Navigator.of(context).pop();
              connectionErrorCustomDialog(context);// Show loading indicator on button press
            },
          ),
        ],
      ),
      actions: _isLoading
          ? []
          : [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
