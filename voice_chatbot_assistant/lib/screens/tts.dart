import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  late FlutterTts flutterTts;
  String? language;
  bool isCurrentLanguageInstalled = false;
  double _volume = 1.0; // Default volume
  double _pitch = 1.3; // Default pitch
  double _speechRate=0.4;

  TtsService() {
    initTts();
  }

  void initTts() {
    flutterTts = FlutterTts();
    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      print("Playing");
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
    });

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
    });
  }

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  Future<void> _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print("Default engine: $engine");
    }
  }

  Future<void> _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print("Default voice: $voice");
    }
  }

  // Method to set language
  Future<void> setLanguage(String selectedLanguage) async {
    language = selectedLanguage;
    await flutterTts.setLanguage(language!);
    if (isAndroid) {
      // Check if the selected language is installed on the device.
      bool isInstalled = await flutterTts.isLanguageInstalled(language!) as bool;
      isCurrentLanguageInstalled = isInstalled;
      print("Language $language installed: $isInstalled");
    }
  }

  // Method to set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await flutterTts.setVolume(_volume);
    print("Volume set to: $_volume");
  }
  Future<void> setSpeechRate(double speechRate) async {
    _speechRate = speechRate.clamp(0.0, 1.0);
    await flutterTts.setSpeechRate(_speechRate);
    print("Speech set to: $_volume");
  }

  // Method to set pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    await flutterTts.setPitch(_pitch);
    print("Pitch set to: $_pitch");
  }

  // Method to speak the given text with the set volume and pitch
  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.setSpeechRate(_speechRate);
      await flutterTts.setVolume(_volume);
      await flutterTts.setPitch(_pitch);
      await flutterTts.speak(text);
    } else {
      print("Text is empty, cannot speak.");
    }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }
}