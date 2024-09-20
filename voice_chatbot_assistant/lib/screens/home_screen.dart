import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_chatbot_assistant/constant/messages.dart'; // Import shared_preferences

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _storedName;

  @override
  void initState() {
    super.initState();

  }

  // Load stored name from SharedPreferences
  void _checkStoredName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('userName');

    // Print the stored name for debugging purposes
    print("Stored name: $storedName");

    if (storedName != null) {
      setState(() {
        _storedName = storedName; // Set the stored name
      });
      updateMessage(storedName);
      // Navigate directly to the chat screen if name exists
      Navigator.pushReplacementNamed(context, '/chatScreen');
    } else {
      Navigator.pushNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                // Additional content like welcome text can go here
              ],
            ),
            Image.asset(
              'images/botImage.png',
              width: screenWidth * 0.8,
              height: screenHeight * 0.6,
              fit: BoxFit.contain,
            ),
            const Text(
              'Welcome to My Buddy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _checkStoredName();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                ),
                child: const Text(
                  'Getting Started',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
