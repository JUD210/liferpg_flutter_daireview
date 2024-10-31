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
  late DateTime _date; // 선택한 날짜
  late List<dynamic> _events; // 선택한 날짜의 이벤트 목록

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // arguments로 전달된 데이터를 초기화
    final Map<String, dynamic> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _date = args['date']; // 선택한 날짜
    _events = args['events']; // 선택한 날짜의 이벤트 목록

    // 초기 값을 설정
    _notes.addAll(_events
        .where((event) => event is! Rating) // Note 타입의 이벤트만 추가
        .map((event) => event.toString()));
    var ratingEvent =
        _events.firstWhere((event) => event is Rating, orElse: () => null);
    _rating = ratingEvent?.score?.toDouble() ?? 3.0;
  }

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String date = _date.toLocal().toString().split(' ')[0]; // 날짜 형식

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
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  final event = _events[index];
                  return ListTile(
                    leading: event is Rating
                        ? const Icon(Icons.star)
                        : const Icon(Icons.message),
                    title: Text(event.toString()),
                    onTap: () => event is Rating
                        ? showEditRatingDialog(
                            context,
                            event,
                            _date,
                            index,
                            selectedEvents: ValueNotifier(_events),
                            updateEvents: (date, events) => setState(() {
                              _events = events;
                            }),
                          )
                        : showEditEventDialog(
                            context,
                            event,
                            _date,
                            index,
                            selectedEvents: ValueNotifier(_events),
                            updateEvents: (date, events) => setState(() {
                              _events = events;
                            }),
                          ),
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
        _events.add(Note(note)); // 추가된 노트를 이벤트 리스트에 포함
      });
    }
  }
}
