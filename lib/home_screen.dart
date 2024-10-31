import 'package:flutter/material.dart';

class DaiReviewHomePage extends StatefulWidget {
  const DaiReviewHomePage({super.key, required this.title});

  final String title; // 화면의 제목을 저장하는 변수입니다.

  @override
  State<DaiReviewHomePage> createState() => _DaiReviewHomePageState();
}

class _DaiReviewHomePageState extends State<DaiReviewHomePage> {
  int _counter = 0; // 버튼 클릭 횟수를 저장하는 변수입니다.

  void _incrementCounter() {
    setState(() {
      _counter++; // 버튼 클릭 시 카운터를 증가시킵니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title), // AppBar에 제목을 표시합니다.
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:', // 설명 텍스트입니다.
            ),
            Text(
              '$_counter', // 현재 카운터 값을 표시합니다.
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter, // 버튼 클릭 시 카운터를 증가시킵니다.
        tooltip: 'Increment', // 버튼에 대한 설명을 제공합니다.
        child: const Icon(Icons.add), // 버튼에 표시할 아이콘입니다.
      ),
    );
  }
}
