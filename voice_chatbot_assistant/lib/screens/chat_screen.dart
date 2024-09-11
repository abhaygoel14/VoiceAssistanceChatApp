import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import the text-to-speech package
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:voice_chatbot_assistant/api_key.dart';
import 'package:voice_chatbot_assistant/constant/languages.dart';
import 'package:voice_chatbot_assistant/constant/messages.dart';
import '../components/assistant_message.dart';
import '../components/user_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SpeechToText speechToTextInstance = SpeechToText();
  final GoogleTranslator translator = GoogleTranslator();
  final FlutterTts flutterTts = FlutterTts(); // Initialize FlutterTTS
  String recordedAudioString = "";
  String translatedString = "";
  String detectedLanguage = "";

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
  List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'ta', 'name': 'Tamil'},
    {'code': 'kn', 'name': 'Kannada'},
    {'code': 'te', 'name': 'Telugu'}
  ];
  Map<String, Map<String, String>> voiceSettings = {
    'en': {'name': 'en-in-x-iol-local', 'locale': 'en-US'},
    'hi': {'name': 'hi-in-x-iol-local', 'locale': 'hi-IN'},
    'ta': {'name': 'ta-in-x-iol-local', 'locale': 'ta-IN'},
    'kn': {'name': 'kn-in-x-iol-local', 'locale': 'kn-IN'},
    'te': {'name': 'te-in-x-iol-local', 'locale': 'te-IN'}
  };
  // Variables for text-to-speech
  List<Map> _voices = [];
  Map? _currentVoice;
  int? _currentWordStart, _currentWordEnd;
 var  _assistantResponse="";

  @override
  void initState() {
    super.initState();
    initializeSpeechToText();
    initializeTextToSpeech();
  }

  void initializeTextToSpeech() async {
    try {
      final voiceSettingsForLanguage = voiceSettings[selectedLanguageCode];
      await flutterTts.setLanguage(voiceSettingsForLanguage?['locale'] ?? 'en-US');
      await flutterTts.setSpeechRate(0.4); // Adjust speech rate if needed
      await flutterTts.setPitch(1.0); // Adjust the pitch
      await flutterTts.setVolume(1.0); // Adjust the volume
      await flutterTts.setVoice({
        'name': voiceSettingsForLanguage?['name'] ?? 'en-in-x-iol-local',
        'locale': voiceSettingsForLanguage?['locale'] ?? 'en-US'
      });
      flutterTts.setProgressHandler((text, start, end, word) {
        setState(() {
          _currentWordStart = start;
          _currentWordEnd = end;
        });
      });
      var voices = await flutterTts.getVoices;
      List<Map> voiceList = List<Map>.from(voices);
      setState(() {
        _voices = voiceList.where((voice) => voice["name"].contains(selectedLanguageCode)).toList();
        _currentVoice = _voices.first;
        setVoice(_currentVoice!);
      });
    } catch (e) {
      print("Error initializing text-to-speech: $e");
    }
  }

  void setVoice(Map voice) {
    flutterTts.setVoice({"name": voice["name"], "locale": voice["locale"]});
  }

  Future<void> getChatResponse(String message) async {
    setState(() {
      isLoading = true;
    });
    if (message.contains('ನಾನು ಒಂಟಿಯಾಗಿ') || message.contains('ಇಲ್ಲ')) {
      _assistantResponse = "ನಾನು ಇಲ್ಲಿದ್ದೇನೆ ನಿನಗಾಗಿ. ಆದರೆ ನೀನು ನಿನ್ನ ಹಳೆಯ ಸ್ನೇಹಿತರನ್ನು ಸುದೀರ್ಘಕಾಲದಿಂದ ಸಂಪರ್ಕಕ್ಕೆ ಬರಲು ಪ್ರಯತ್ನಿಸುತ್ತಿಲ್ಲ. ಕರೆ ಮಾಡಿ, ಯಾರನ್ನು ನೀನು ಇನ್ನೂ ನಿನ್ನ ಉತ್ತಮ ಸ್ನೇಹಿತರೆಂದು ನಂಬುತ್ತೀಯೋ ಅವರೊಂದಿಗೆ ಮಾತನಾಡು.";
    } else if (message.contains('sleepless') || message.contains('feeling sleepless')) {
      _assistantResponse = "Hey, I’ve been observing you for the last few days. It seems you’re having issues with your boss and also feeling unhappy at home due to a lack of personal time with family. Take a holiday, concentrate on upskilling. Take your family out and spend some quality time, get some good sleep. This may help you.";
    } else {
      // GPT-4 API request for responses not covered by hardcoded cases
      final gptMessages = [
        {
          'role': 'assistant',
          'content': 'Fetch real-time information from the internet and Provide a response to the users question by understanding the local language of the text. Translate the answer into the relevant language (English, Hindi, Kannada, Telugu, Tamil) as needed.'
        },
        {
          'role': 'assistant',
          'content': instruction
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
          _assistantResponse = response.choices.first.message?.content ?? 'No response';
        } else {
          _assistantResponse = 'Sorry, I couldn’t generate a response.';
        }
      } catch (e) {
        _assistantResponse = 'Error fetching response. Please try again.';
        print("Error fetching GPT response: $e");
      }
    }

    // Update UI and speak the assistant's response
    setState(() {
      messages.add({'role': 'assistant', 'content': _assistantResponse});
      isLoading = false;
    });

    await flutterTts.speak(_assistantResponse);
  }


  Future<void> translateText(String text) async {
    final translated = await translator.translate(text, to: selectedLanguageCode);
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
    });
    await speechToTextInstance.listen(onResult: onSpeechToTextResult);
  }

  void stopListeningNow() async {
    await speechToTextInstance.stop();
    setState(() {
      isRecording = false;
    });
    if (recordedAudioString.isNotEmpty) {
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
    print("Speech Result: $recordedAudioString");
  }

  void clear() {
    setState(() {
      messages = List.from(dummyMessages);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Chat Screen"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                      'images/botIcon.gif',
                      height: 160,
                      width: 160,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                                        messageContent: message['content']!);
                                  } else {
                                    return UserMessage(
                                        messageContent: message['content']!);
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
                  // Language Selection Dropdown
                  DropdownButton<String>(
                    value: selectedLanguageCode,
                    items: languages.map((language) {
                      return DropdownMenuItem<String>(
                        value: language['code'],
                        child: Text(language['name']!),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLanguageCode = newValue!;
                        initializeTextToSpeech(); // Reinitialize TTS with new language
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: startListeningNow,
                        child: const Icon(Icons.mic),
                        backgroundColor: isRecording ? Colors.red : Colors.blue, // Indicator
                      ),
                      FloatingActionButton(
                        onPressed: stopListeningNow,
                        child: const Icon(Icons.stop),
                        backgroundColor: Colors.blue,
                      ),
                      FloatingActionButton(
                        onPressed: clear,
                        child: const Icon(Icons.clear),
                        backgroundColor: Colors.blue,
                      ),
                    ],
                  ),
                  if (isRecording)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text('Recording...', style: TextStyle(color: Colors.red, fontSize: 18)),
                    ),
                  if (!isRecording && recordedAudioString.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text('Recording paused.', style: TextStyle(color: Colors.green, fontSize: 18)),
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