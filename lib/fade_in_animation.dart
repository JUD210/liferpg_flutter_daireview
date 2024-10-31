import 'package:flutter/material.dart';

class FadeInAnimation extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const FadeInAnimation({super.key, required this.onAnimationComplete});

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward().whenComplete(widget.onAnimationComplete);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: const Center(
        child: Image(
          // FIXME: shiny_magikarp.png 이미지를 life_rpg.png 로고로 변경.
          image: AssetImage(
              'assets/images/logos/shiny_magikarp.png'), // 이미지 경로를 설정하세요.
          width: 200, // 이미지의 초기 크기를 설정합니다.
          height: 200,
        ),
      ),
    );
  }
}
