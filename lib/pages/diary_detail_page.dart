import 'package:flutter/material.dart';
import '../utils/utils.dart';

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
  void initState() {
    super.initState();
    // arguments로 전달된 데이터를 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic> args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      DateTime selectedDate = args['selectedDate'];
      List<dynamic> events = args['events'];

      // 초기 값을 설정
      setState(() {
        _notes.addAll(events
            .where((event) => event is! Rating) // Note 타입의 이벤트만 추가
            .map((event) => event.toString()));
        var ratingEvent =
            events.firstWhere((event) => event is Rating, orElse: () => null);
        _rating = ratingEvent?.score?.toDouble() ?? 3.0;
      });
    });
  }

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String date = DateTime.now().toLocal().toString().split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Diary Entry - $date'),
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
                  getEmojiForRating(_rating), // Display emoji
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

  Future<void> _addNote() async {
    final note = await addNoteDialog(context, _diaryController);
    if (note != null) {
      setState(() {
        _notes.add(note); // 입력된 텍스트를 _notes에 추가
      });
    }
  }
}
