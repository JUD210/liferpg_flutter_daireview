import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/splash_page.dart';
import 'pages/table_calendar_page.dart';

void main() {
  initializeDateFormatting().then((_) {
    runApp(const DaiReviewApp());
  });
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
        '/home': (context) => TableCalendarPage(),
        '/diary': (context) => DiaryDetailPage(), // Add the new route
      },
    );
  }
}
