List<Map<String, String>> language = [
  {'code': 'en', 'name': 'English'},
  {'code': 'hi', 'name': 'Hindi'},
  {'code': 'ta', 'name': 'Tamil'},
  {'code': 'kn', 'name': 'Kannada'},
  {'code': 'te', 'name': 'Telugu'}
];
Map<String, Map<String, String>> voiceSetting = {
  'en': {'name': 'en-IN-Neural2-D', 'locale': 'en-IN'},
  'hi': {'name': 'hi-IN-Neural2-A', 'locale': 'hi-IN'},
  'ta': {'name': 'ta-IN-Wavenet-C', 'locale': 'ta-IN'},
  'kn': {'name': 'kn-IN-Wavenet-C', 'locale': 'kn-IN'},
  'te': {'name': 'te-IN-Standard-A', 'locale': 'te-IN'}
};

Map<String,String> langSetting = {
  'en':  'en-IN',
  'hi': 'hi-IN',
  'ta': 'ta-IN',
  'kn': 'kn-IN',
  'te': 'te-IN'
};
String instruction="Instructions: Determine the language of the users question.Translate your response into the same language as the user’s question.Example:Avoid writing language name.Only answer is the final output.If the question is in Hindi, answer and translate the response in Hindi.If the question is in Kannada, answer and translate the response in Kannada.";