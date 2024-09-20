import 'package:flutter/foundation.dart';

List<Map<String, String>> dummyMessages = [
  {'role': 'assistant', 'content': 'How may I help you?'}
];

void updateMessage(String name) {
  String formattedName = name[0].toUpperCase() + name.substring(1).toLowerCase();
  final currentTime = DateTime.now();
  final hour = currentTime.hour;
  if (kDebugMode) {
    print("Hour : $hour");
  }
  String greeting;

  if (hour >= 5 && hour < 12) {
    greeting = 'Good Morning';
  } else if (hour >= 12 && hour < 17) {
    greeting = 'Good Afternoon';
  } else {
    greeting = 'Good Evening';
  }

  // Update the dummyMessages list with the new content
  dummyMessages = [
    {
      'role': 'assistant',
      'content': '$greeting $formattedName! how can I assist you today?'
    }
  ];
}