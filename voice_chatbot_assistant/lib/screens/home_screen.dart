import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Column(
              children: [
                Text(
                  'Company Name',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'The Future is here, powered by AI.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Image.asset(
              'images/botIcon.gif',
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.contain,
            ),
            const Column(
              children: [
                Text(
                  'Welcome to Voice Chatbot',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Your personal assistant for all your needs',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context,'/chatScreen');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, disabledForegroundColor: Colors.green.withOpacity(0.38), disabledBackgroundColor: Colors.green.withOpacity(0.12), // Color when pressed or disabled
                  padding: const EdgeInsets.symmetric(vertical: 16), // Padding
                ),
                child: const Text('Getting Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
