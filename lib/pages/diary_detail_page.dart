import 'package:flutter/material.dart';

class DiaryDetailPage extends StatefulWidget {
  const DiaryDetailPage({super.key});

  @override
  DiaryDetailPageState createState() => DiaryDetailPageState();
}

class DiaryDetailPageState extends State<DiaryDetailPage> {
  double _rating = 3.0; // Default rating
  final TextEditingController _diaryController = TextEditingController();

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            onPressed: () {
              // Handle Gemini review action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              '별점 설정',
              style: TextStyle(fontSize: 18),
            ),
            Slider(
              min: 1,
              max: 5,
              divisions: 4,
              value: _rating,
              onChanged: (value) {
                setState(() {
                  _rating = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _diaryController,
              decoration: const InputDecoration(
                labelText: '다이어리 적기',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
