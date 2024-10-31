import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart'; // intl 패키지의 로케일 데이터를 초기화하기 위해 임포트합니다.

import 'splash_screen.dart'; // SplashScreen 파일을 임포트합니다.
import 'home_screen.dart'; // 홈 화면 파일을 임포트합니다.
import 'table_calendar.dart'; // 이벤트 예제 파일을 임포트합니다.

void main() {
  // 로케일 데이터를 초기화합니다. 이 작업이 완료된 후에 runApp을 호출합니다.
  initializeDateFormatting().then((_) {
    runApp(const DaiReviewApp()); // 앱의 시작점입니다.
  });
}

class DaiReviewApp extends StatelessWidget {
  const DaiReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeRPG - DaiReview', // 앱의 제목을 설정합니다.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple), // 앱의 테마 색상을 설정합니다.
        useMaterial3: true, // Material 3 디자인을 사용합니다.
      ),
      initialRoute: '/intro', // 앱이 시작될 때 처음으로 표시할 경로를 설정합니다.
      routes: {
        '/intro': (context) => const SplashScreen(
            title: 'Welcome to DaiReview'), // 인트로 화면 경로를 설정합니다.
        '/home': (context) => TableEventsExample(), // 이벤트 예제 화면 경로를 설정합니다.
      },
    );
  }
}
