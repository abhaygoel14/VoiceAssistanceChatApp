import 'package:flutter/material.dart';

class UserMessage extends StatelessWidget {
  final String messageContent;

  const UserMessage({super.key, required this.messageContent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible( // This ensures the container can shrink based on available space
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white60, // White background for user messages
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                messageContent,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                softWrap: true, // Allows text to wrap to the next line
                overflow: TextOverflow.clip, // Prevents overflow issues
              ),
            ),
          ),
        ],
      ),
    );
  }
}
