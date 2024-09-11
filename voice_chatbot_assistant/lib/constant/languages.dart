List<Map<String, String>> language = [
  {'code': 'en', 'name': 'English'},
  {'code': 'hi', 'name': 'Hindi'},
  {'code': 'ta', 'name': 'Tamil'},
  {'code': 'kn', 'name': 'Kannada'},
  {'code': 'te', 'name': 'Telugu'}
];

String instruction="Instructions: Determine the language of the users question.Translate your response into the same language as the user’s question.Example:Avoid writing language name.Only answer is the final output.If the question is in Hindi, answer and translate the response in Hindi.If the question is in Kannada, answer and translate the response in Kannada.";