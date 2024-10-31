import 'package:flutter/material.dart';
import '../widgets/fade_in_animation.dart';

class SplashPage extends StatelessWidget {
  final String title;

  const SplashPage({super.key, required this.title});

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
