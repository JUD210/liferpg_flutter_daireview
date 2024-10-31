import 'package:flutter/material.dart';
import 'splash_screen.dart'; // SplashScreen 파일을 임포트합니다.
import 'home_screen.dart'; // 홈 화면 파일을 임포트합니다.

void main() {
  runApp(const DaiReviewApp());
}

class DaiReviewApp extends StatelessWidget {
  const DaiReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeRPG - DaiReview',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/intro',
      routes: {
        '/intro': (context) =>
            const SplashScreen(title: 'Welcome to DaiReview'),
        '/home': (context) =>
            const DaiReviewHomePage(title: 'Homepage of DaiReview App'),
      },
    );
  }
}
