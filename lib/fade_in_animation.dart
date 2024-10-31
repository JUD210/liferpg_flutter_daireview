import 'package:flutter/material.dart';

class FadeInAnimation extends StatefulWidget {
  final VoidCallback onAnimationComplete; // 애니메이션 완료 시 호출할 콜백 함수입니다.

  const FadeInAnimation({super.key, required this.onAnimationComplete});

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation> {
  double _opacity = 0.0; // 애니메이션의 초기 투명도입니다.

  @override
  void initState() {
    super.initState();
    _startAnimation(); // 애니메이션을 시작합니다.
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // 투명도를 변경하여 페이드 인 효과를 줍니다.
      });
    });

    Future.delayed(const Duration(seconds: 3),
        widget.onAnimationComplete); // 3초 후에 콜백을 호출합니다.
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity, // 현재 투명도를 설정합니다.
      duration: const Duration(seconds: 2), // 애니메이션 지속 시간을 설정합니다.
      child: const Text(
        'Welcome to DaiReview', // 화면에 표시할 텍스트입니다.
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
