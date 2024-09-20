import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'package:voice_chatbot_assistant/constant/messages.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  late String _currentTime;
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(); // For form validation
  bool _isNameValid = true; // To track if the name input is valid
  String? _storedName; // To store the name locally

  @override
  void initState() {
    super.initState();
    _updateTime();
    _loadStoredName(); // Load stored name when screen initializes
  }

  // Load stored name from SharedPreferences
  void _loadStoredName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('userName');
    if (storedName != null) {
      setState(() {
        _storedName = storedName;
        _nameController.text = storedName; // Autofill name in TextFormField
      });
    }
  }

  // Save name to SharedPreferences
  void _saveName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  void _updateTime() {
    setState(() {
      // Format the current time to IST
      _currentTime = DateFormat('hh:mm a').format(
          DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)));
    });
  }



  bool _validateName(String name) {
    final nameRegExp = RegExp(r"^[a-zA-Z]+$");
    return nameRegExp.hasMatch(name);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  const Text(
                    'Welcome to My Buddy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Image.asset(
                    'images/botImage.png',
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.5,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: screenHeight * 0.05)
                ],
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Enter your name',
                  border: const OutlineInputBorder(),
                  errorText: _isNameValid ? null : 'Please enter a valid name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  } else if (!_validateName(value)) {
                    return 'Name should only contain letters';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (_validateName(value)) {
                    setState(() {
                      _isNameValid = true;
                    });
                  } else {
                    setState(() {
                      _isNameValid = false;
                    });
                  }
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String userName = _nameController.text;
                      _saveName(userName);
                      updateMessage(userName);
                      Navigator.pushNamed(context, '/chatScreen');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  ),
                  child: const Text('Start a Conversation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}