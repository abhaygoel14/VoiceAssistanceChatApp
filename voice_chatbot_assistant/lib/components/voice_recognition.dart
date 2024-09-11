// voice_recognition.dart
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/material.dart';

class VoiceRecognition extends StatefulWidget {
  final Function(String) onResult;
  const VoiceRecognition({Key? key, required this.onResult}) : super(key: key);

  @override
  _VoiceRecognitionState createState() => _VoiceRecognitionState();
}

class _VoiceRecognitionState extends State<VoiceRecognition> {
  final SpeechToText _speechToText = SpeechToText();
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
  }

  void _initializeSpeechToText() async {
    await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onResult);
    setState(() {
      isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  void _onResult(SpeechRecognitionResult result) {
    widget.onResult(result.recognizedWords);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isListening ? _stopListening : _startListening,
      child: Image.asset(
        isListening ? 'images/recordingLogo.gif' : 'images/recordingIcon.png',
        height: 40,
        width: 40,
      ),
    );
  }
}