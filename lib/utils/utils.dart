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
