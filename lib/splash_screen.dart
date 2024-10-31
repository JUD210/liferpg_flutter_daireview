import 'package:flutter/material.dart';
import 'fade_in_animation.dart'; // 애니메이션 파일을 임포트합니다.

class SplashScreen extends StatelessWidget {
  final String title;

  const SplashScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // 화면의 제목을 설정합니다.
      ),
      body: Center(
        child: FadeInAnimation(
          onAnimationComplete: () {
            Navigator.of(context)
                .pushReplacementNamed('/home'); // 애니메이션이 완료되면 홈 화면으로 전환합니다.
          },
        ),
      ),
    );
  }
}
