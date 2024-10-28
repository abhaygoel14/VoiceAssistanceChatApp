import 'package:flutter/material.dart';
import 'package:voice_chatbot_assistant/components/custom_button.dart';
import 'package:voice_chatbot_assistant/components/custom_dialog_box.dart';

void shoppingDialogBox(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const ShoppingDialog();
    },
  );
}

class ShoppingDialog extends StatefulWidget {
  const ShoppingDialog({super.key});

  @override
  _ShoppingDialogState createState() => _ShoppingDialogState();
}

class _ShoppingDialogState extends State<ShoppingDialog> {
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
      content: _isLoading
          ? const SizedBox(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            title: 'Compare iPhone Prices',
            onPressed: () {
              Navigator.of(context).pop();
              connectionErrorCustomDialog(context); // Show loading indicator on button press
            },
          ),
          const SizedBox(height: 8), // Spacing between buttons
          CustomButton(
            title: 'Give Me Best Deals',
            onPressed: () {
              Navigator.of(context).pop();
              connectionErrorCustomDialog(context); // Show loading indicator on button press
            },
          ),
          const SizedBox(height: 16), // Spacing between buttons and icons

          // First row with 3 images
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Center the row of icons
            children: [
              GestureDetector(
                onTap: () => connectionErrorCustomDialog(context),
                child: Image.asset(
                  'images/flipkartLogo.png', // Path to your icon 1
                  height: 40, // Adjust size as needed
                  width: 40,
                ),
              ),
              GestureDetector(
                onTap: () => connectionErrorCustomDialog(context),
                child: Image.asset(
                  'images/ajioLogo.png', // Path to your icon 2
                  height: 40, // Adjust size as needed
                  width: 40,
                ),
              ),
              GestureDetector(
                onTap: () => connectionErrorCustomDialog(context),
                child: Image.asset(
                  'images/myntraLogo.png', // Path to your icon 3
                  height: 40, // Adjust size as needed
                  width: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Spacing between rows

          // Second row with 2 images
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Center the row of icons
            children: [
              GestureDetector(
                onTap: () => connectionErrorCustomDialog(context),
                child: Image.asset(
                  'images/meeshoLogo.png', // Path to your icon 4
                  height: 40, // Adjust size as needed
                  width: 40,
                ),
              ),
              GestureDetector(
                onTap: () => connectionErrorCustomDialog(context),
                child: Image.asset(
                  'images/amazon_logo.png', // Path to your icon 5
                  height: 40, // Adjust size as needed
                  width: 40,
                ),
              ),
            ],
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
