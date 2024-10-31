import 'package:flutter/material.dart';
import 'dart:collection';
import 'dart:math';

import 'package:table_calendar/table_calendar.dart';

class Rating {
  final int score;
  Rating(this.score);

  @override
  String toString() => 'Rating: $score';
}

// 평점 수정 다이얼로그
Future<void> showEditRatingDialog(
    BuildContext context, Rating ratingEvent, DateTime day, int index,
    {required ValueNotifier<List<dynamic>> selectedEvents,
    required Function(DateTime, List<dynamic>) updateEvents}) async {
  double rating = ratingEvent.score.toDouble();

  return showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text("오늘의 평점을 매겨주세요!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${ratingToEmoji[rating.toInt()]} ${rating.toInt()} / 5"),
              Slider(
                min: 1,
                max: 5,
                divisions: 4,
                value: rating,
                onChanged: (value) {
                  setDialogState(() => rating = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("취소"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("삭제"),
              onPressed: () {
                List<dynamic> updatedEvents = List.from(getEventsForDay(day));
                updatedEvents.removeAt(index);
                updateEvents(day, updatedEvents);
                selectedEvents.value = updatedEvents;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("저장"),
              onPressed: () {
                List<dynamic> updatedEvents = List.from(getEventsForDay(day));
                updatedEvents[index] = Rating(rating.toInt());
                updateEvents(day, updatedEvents);
                selectedEvents.value = updatedEvents;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ),
  );
}

// 평점 추가 다이얼로그
Future<void> showAddRatingEventDialog(BuildContext context, DateTime day,
    {required ValueNotifier<List<dynamic>> selectedEvents,
    required Function(DateTime, List<dynamic>) updateEvents}) async {
  double rating = 3;

  return showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text("오늘의 평점을 매겨주세요!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${ratingToEmoji[rating.toInt()]} ${rating.toInt()} / 5"),
              Slider(
                min: 1,
                max: 5,
                divisions: 4,
                value: rating,
                onChanged: (value) {
                  setDialogState(() => rating = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("취소"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("저장"),
              onPressed: () {
                List<dynamic> newEvents = List.from(getEventsForDay(day));
                newEvents.add(Rating(rating.toInt()));
                updateEvents(day, newEvents);
                selectedEvents.value = newEvents;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ),
  );
}

// 메모 수정 다이얼로그
Future<void> showEditEventDialog(
    BuildContext context, Note noteEvent, DateTime day, int index,
    {required ValueNotifier<List<dynamic>> selectedEvents,
    required Function(DateTime, List<dynamic>) updateEvents}) async {
  TextEditingController controller =
      TextEditingController(text: noteEvent.description);

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("기록 수정하기"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "오늘 하루는 어떠셨나요?"),
      ),
      actions: [
        TextButton(
          child: const Text("취소"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("삭제"),
          onPressed: () {
            List<dynamic> updatedEvents = List.from(getEventsForDay(day));
            updatedEvents.removeAt(index);
            updateEvents(day, updatedEvents);
            selectedEvents.value = updatedEvents;
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("저장"),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              List<dynamic> updatedEvents = List.from(getEventsForDay(day));
              updatedEvents[index] = Note(controller.text);
              updateEvents(day, updatedEvents);
              selectedEvents.value = updatedEvents;
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}

// 메모 추가 다이얼로그
Future<void> showAddMessageEventDialog(BuildContext context, DateTime day,
    {required ValueNotifier<List<dynamic>> selectedEvents,
    required Function(DateTime, List<dynamic>) updateEvents}) async {
  TextEditingController controller = TextEditingController();

  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("기록 추가하기"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "오늘 하루는 어떠셨나요?"),
      ),
      actions: [
        TextButton(
          child: const Text("취소"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("저장"),
          onPressed: () {
            if (controller.text.isNotEmpty) {
              List<dynamic> newEvents = List.from(getEventsForDay(day));
              newEvents.add(Note(controller.text));
              updateEvents(day, newEvents);
              selectedEvents.value = newEvents;
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    ),
  );
}

class Note {
  final String description;

  Note(this.description);

  @override
  String toString() => description;
}

final Map<int, String> ratingToEmoji = {
  1: '😭',
  2: '😟',
  3: '😐',
  4: '🙂',
  5: '😊',
};

String getEmojiForRating(double rating) {
  final Map<int, String> ratingToEmoji = {
    1: '😭',
    2: '😟',
    3: '😐',
    4: '🙂',
    5: '😊',
  };
  return ratingToEmoji[rating.toInt()] ?? '❓';
}

String getEmojiFromEvents(List<dynamic> events) {
  for (var event in events) {
    if (event is Rating) {
      return ratingToEmoji[event.score] ?? '❓';
    }
  }
  return '❓';
}

Future<String?> addNoteDialog(
    BuildContext context, TextEditingController controller) {
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('노트 추가하기'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '노트를 입력하세요'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // '취소' 눌렀을 때 null 반환
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final noteText = controller.text;
                controller.clear();
                Navigator.of(context).pop(noteText); // 입력된 텍스트를 반환
              }
            },
            child: const Text('저장'),
          ),
        ],
      );
    },
  );
}

List<dynamic> getEventsForDay(DateTime day) {
  return kEvents[day] ?? [];
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
final Random random = Random();

// 더미 이벤트 생성 함수
List<dynamic> createRandomEvents() {
  return [
    Rating(random.nextInt(5) + 1),
    Note('${random.nextInt(1400) + 200}/1600kcal'), // 섭취 칼로리 Note
    Note('${random.nextInt(120) + 1}분 운동'), // 운동 시간 Note
  ];
}

// 더미 이벤트 맵 생성
final _kEventSource = {
  for (var item in List<DateTime>.generate(
      kToday.difference(kFirstDay).inDays + 1,
      (index) =>
          DateTime.utc(kFirstDay.year, kFirstDay.month, kFirstDay.day + index)))
    item: createRandomEvents()
};

final kEvents = LinkedHashMap<DateTime, List<dynamic>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}
