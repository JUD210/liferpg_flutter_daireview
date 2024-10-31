import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

Future<String> analyzeDiary(
    BuildContext context, String diaryContent, String apiKey) async {
  // Gemini model setup
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
    safetySettings: [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
    ],
  );

  String prompt = '''
  하루 일기를 다음의 KPT 방법론에 따라 평가해 주세요:
  - Keep: 잘한 점과 유지할 부분.
  - Problem: 개선할 점과 문제점.
  - Try: 앞으로 시도해 볼 만한 조언.
  
  다음은 하루 일기에 대한 내용입니다:
  "$diaryContent"
  
  KPT 분석을 제공해 주세요.
  ''';

  // Pass the text as Content for Gemini
  final content = [Content.text(prompt)];

  // Generate the KPT response
  final response = await model.generateContent(content);

  return response.text ?? '분석 결과를 받을 수 없습니다.';
}
