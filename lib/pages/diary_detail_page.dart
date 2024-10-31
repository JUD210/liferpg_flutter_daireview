import 'package:flutter/material.dart';

class DiaryDetailPage extends StatefulWidget {
  const DiaryDetailPage({super.key});

  @override
  DiaryDetailPageState createState() => DiaryDetailPageState();
}

class DiaryDetailPageState extends State<DiaryDetailPage> {
  double _rating = 3.0; // Default rating
  final TextEditingController _diaryController = TextEditingController();
  final List<String> _notes = []; // List to store notes

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String date =
        DateTime.now().toLocal().toString().split(' ')[0]; // Get current date

    return Scaffold(
      appBar: AppBar(
        title: Text('Diary Entry - $date'), // Show the date in the title
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '오늘의 기분은 어떠신가요?',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  _getEmojiForRating(_rating), // Display emoji
                  style: const TextStyle(fontSize: 24),
                ),
              ],
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
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_notes[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getEmojiForRating(double rating) {
    final Map<int, String> ratingToEmoji = {
      1: '😭',
      2: '😟',
      3: '😐',
      4: '🙂',
      5: '😊',
    };
    return ratingToEmoji[rating.toInt()] ?? '❓';
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('노트 추가하기'),
          content: TextField(
            controller: _diaryController,
            decoration: const InputDecoration(hintText: '노트를 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                if (_diaryController.text.isNotEmpty) {
                  setState(() {
                    _notes.add(_diaryController.text);
                    _diaryController.clear();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('저장'),
            ),
          ],
        );
      },
    );
  }
}
