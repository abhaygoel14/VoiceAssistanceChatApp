import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:voice_chatbot_assistant/api_key.dart';
import 'package:voice_chatbot_assistant/constant/languages.dart';
import 'package:voice_chatbot_assistant/constant/messages.dart';
import 'package:voice_chatbot_assistant/screens/tts.dart';
import '../components/assistant_message.dart';
import '../components/user_message.dart';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TtsService ttsService = TtsService();
  final SpeechToText speechToTextInstance = SpeechToText();
  final GoogleTranslator translator = GoogleTranslator();
  String recordedAudioString = "";
  String translatedString = "";
  String detectedLanguage = "";
  Timer? _silenceTimer;
  bool _isSilenceDetected = false;

  final _openAI = OpenAI.instance.build(
    token: apiKey,
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 10)),
    enableLog: true,
  );
  List<Map<String, String>> messages = dummyMessages;
  bool isLoading = false;
  bool isRecording = false; // Variable to track recording status

  // List of languages for the user to select
  String selectedLanguageCode = 'en'; // Default language
  List<Map<String, String>> languages = language;
  Map<String, Map<String, String>> voiceSettings = voiceSetting;

  var _assistantResponse = "";
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    initializeSpeechToText();
    initializeTextToSpeech();
    speakDummyMessages();
  }

  void speakDummyMessages() async {
    for (var message in messages) {
      if (message['role'] == 'assistant') {
        await ttsService.setLanguage('en-IN');
        // await ttsService.setVoice(voiceSettings['en']!);
        await ttsService.setSpeechRate(
            0.4 + Random().nextDouble() * 0.1); // Adjust speech rate if needed
        await ttsService
            .setPitch(1.3 + Random().nextDouble() * 0.2); // Adjust pitch
        await ttsService.setVolume(1.0);
        await ttsService.speak(message['content']!);
      }
    }
  }

  // Initialize text-to-speech and log available voices
  void initializeTextToSpeech() async {
    try {
      // Get the voice settings for the selected language
      // Log all available voices
      final langSettings = langSetting[selectedLanguageCode];
      // Set the language, speech rate, pitch, and volume for the selected language
      await ttsService.setLanguage(langSettings!);
      await ttsService.setSpeechRate(
          0.4 + Random().nextDouble() * 0.1); // Adjust speech rate if needed
      await ttsService
          .setPitch(1.3 + Random().nextDouble() * 0.1); // Adjust pitch
      await ttsService.setVolume(1.0); // Adjust volume
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing text-to-speech: $e");
      }
    }
  }

  Future<void> getChatResponse(String message) async {
    setState(() {
      isLoading = true;
    });
    initializeTextToSpeech();
    // Custom hardcoded responses for specific phrases
    if (message.contains('ನಾನು ಒಂಟಿಯಾಗಿ') || message.contains('ಇಲ್ಲ')) {
      _assistantResponse =
          "ನಾನು ಇಲ್ಲಿದ್ದೇನೆ ನಿನಗಾಗಿ. ಆದರೆ ನೀನು ನಿನ್ನ ಹಳೆಯ ಸ್ನೇಹಿತರನ್ನು ಸುದೀರ್ಘಕಾಲದಿಂದ ಸಂಪರ್ಕಕ್ಕೆ ಬರಲು ಪ್ರಯತ್ನಿಸುತ್ತಿಲ್ಲ. ಕರೆ ಮಾಡಿ, ಯಾರನ್ನು ನೀನು ಇನ್ನೂ ನಿನ್ನ ಉತ್ತಮ ಸ್ನೇಹಿತರೆಂದು ನಂಬುತ್ತೀಯೋ ಅವರೊಂದಿಗೆ ಮಾತನಾಡು.";
    } else if (message.contains('sleepless') ||
        message.contains('feeling sleepless')) {
      _assistantResponse =
          "Hey, I’ve been observing you for the last few days. It seems you’re having issues with your boss and also feeling unhappy at home due to a lack of personal time with family. Take a holiday, concentrate on upskilling. Take your family out and spend some quality time, get some good sleep. This may help you.";
    } else {
      // GPT-4 API request for other responses
      final gptMessages = [
        {
          'role': 'assistant',
          'content':
              'Fetch real-time information... Translate the answer into the relevant language.'
        },
        {
          'role': 'assistant',
          'content':
              'Provide answer in a clear, concise, and conversational way.Add natural fillers like "um" and "uh huh" to make the conversation flow more organically.'
        },
        {'role': 'user', 'content': message}
      ];

      final request = ChatCompleteText(
        model: Gpt4O2024ChatModel(),
        messages: gptMessages.map((msg) => Map.of(msg)).toList(),
        maxToken: 200,
      );

      try {
        final response = await _openAI.onChatCompletion(request: request);
        if (response != null && response.choices.isNotEmpty) {
          _assistantResponse =
              response.choices.first.message?.content ?? 'No response';
        } else {
          _assistantResponse = 'Sorry, I couldn’t generate a response.';
        }
      } catch (e) {
        _assistantResponse = 'Error fetching response. Please try again.';
        if (kDebugMode) {
          print("Error fetching GPT response: $e");
        }
      }
    }

    // Update UI and speak the assistant's response
    setState(() {
      messages.add({'role': 'assistant', 'content': _assistantResponse});
      isLoading = false;
    });

    await ttsService
        .speak(_assistantResponse); // Using TtsService to speak the response
  }

  Future<String> detectLanguage(String text) async {
    // Translate the text to a known language (e.g., English) to infer the source language
    var translation = await translator.translate(text, to: 'en');
    // If the text is not in English, the source language is detected by translation
    return translation.sourceLanguage
        .toString(); // This will give you the detected language
  }

  Future<void> translateText(String text) async {
    String detectedLanguage = await detectLanguage(text);
    if (kDebugMode) {
      print("Detected Language: $detectedLanguage");
    }
    for (var lang in languages) {
      if (lang['name']!.toLowerCase() == detectedLanguage.toLowerCase()) {
        selectedLanguageCode = lang['code']!;
        break;
      } else {
        selectedLanguageCode = 'en';
      }
    }
    if (kDebugMode) {
      print("SelectedLanguageCode : $selectedLanguageCode");
    }

    final translated =
        await translator.translate(text, from: 'en', to: selectedLanguageCode);
    setState(() {
      translatedString = translated.text;
      messages = List<Map<String, String>>.from(messages);
      messages.add({'role': 'user', 'content': translatedString});
    });

    await getChatResponse(translatedString.toLowerCase());
  }

  void initializeSpeechToText() async {
    await speechToTextInstance.initialize();
    setState(() {});
  }

  void startListeningNow() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isRecording = true;
      errorMessage = "";
      _isSilenceDetected = false;
      _silenceTimer?.cancel();
    });
    await speechToTextInstance.listen(
        onResult: onSpeechToTextResult,
        listenFor: const Duration(seconds: 15), // Adjust duration if necessary
        pauseFor: const Duration(
            seconds: 10), // Time to pause if no speech is detected
        onSoundLevelChange: (level) {
          if (kDebugMode) {
            print("Sound level: $level");
          }
          // Reset the timer every time there's noise (i.e., sound level > threshold)

          if (level > 1) {
            // Adjust threshold if needed
            // Sound detected, reset timer
            _silenceTimer?.cancel();
            _isSilenceDetected = false;
          } else if (!_isSilenceDetected) {
            // If silence has not yet been detected
            _silenceTimer?.cancel(); // Cancel any previous timer
            _silenceTimer = Timer(const Duration(seconds: 2), () {
              if (kDebugMode) {
                print("4 seconds of silence detected, stopping recording...");
              }
              setState(() {
                _isSilenceDetected = true; // Mark silence as detected
                isRecording = false;
              });
              stopListeningNow();
            });
          }
        });
  }

  void stopListeningNow() async {
    await speechToTextInstance.stop();
    setState(() {
      isRecording = false;
      _isSilenceDetected = true;
      _silenceTimer?.cancel();
    });
    if (recordedAudioString.isEmpty) {
      setState(() {
        errorMessage =
            "No speech detected. Please try again."; // Show error if no speech
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          errorMessage = "";
        });
      });
    } else {
      await translateText(recordedAudioString);
      setState(() {
        recordedAudioString = '';
      });
    }
  }

  void onSpeechToTextResult(SpeechRecognitionResult recognitionResult) {
    setState(() {
      recordedAudioString = recognitionResult.recognizedWords;
    });
    if (kDebugMode) {
      print("Speech Result: $recordedAudioString");
    }
  }

  void clear() async {
    setState(() {
      messages = List.from(dummyMessages);
      errorMessage = "";
    });
    await ttsService.stop();
  }

  @override
  void dispose() {
    super.dispose();
    speechToTextInstance.stop();
    ttsService.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Chat"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/homeScreen');
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (errorMessage.isNotEmpty) // Show error if exists
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            messages.isEmpty
                ? const Center(
                    child: Text(
                      'Start a conversation!',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Image.asset(
                            'images/botImage.png',
                            height: 160,
                            width: 160,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: messages.map((message) {
                                        if (message['role'] == 'assistant') {
                                          return AssistantMessage(
                                              messageContent:
                                                  message['content']!);
                                        } else {
                                          return UserMessage(
                                              messageContent:
                                                  message['content']!);
                                        }
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                if (isLoading)
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isRecording) {
                            stopListeningNow();
                          } else {
                            startListeningNow();
                          }
                        },
                        child: Image.asset(
                          isRecording
                              ? 'images/recordingLogo.gif'
                              : 'images/recordingIcon.png',
                          height: 70,
                          width: 70,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        iconSize: 40,
                        color: Colors.redAccent,
                        onPressed: clear,
                      ),
                    ],
                  ),
                  if (isRecording)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text('Recording...',
                          style: TextStyle(color: Colors.red, fontSize: 18)),
                    ),
                  if (!isRecording && recordedAudioString.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text('Recording paused.',
                          style: TextStyle(color: Colors.green, fontSize: 18)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
