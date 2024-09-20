import 'package:flutter/material.dart';
import 'package:voice_chatbot_assistant/screens/chat_screen.dart';
import 'package:voice_chatbot_assistant/screens/home_screen.dart';
import 'package:voice_chatbot_assistant/screens/profile_screen.dart';
import 'package:voice_chatbot_assistant/screens/tts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/homeScreen':(context)=>const HomeScreen(),
        '/chatScreen': (context) => const ChatScreen(),
        '/profile':(context)=> const ProfileScreen(),
      },
      home: const HomeScreen(),
    );
  }
}
