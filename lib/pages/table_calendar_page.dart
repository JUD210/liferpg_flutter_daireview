import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/utils.dart';

final Map<int, String> ratingToEmoji = {
  1: '😭',
  2: '😟',
  3: '😐',
  4: '🙂',
  5: '😊',
};

class TableCalendarPage extends StatefulWidget {
  const TableCalendarPage({super.key});

  @override
  TableCalendarPageState createState() => TableCalendarPageState();
}

class TableCalendarPageState extends State<TableCalendarPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  String getEmojiFromEvents(List<Event> events) {
    for (Event event in events) {
      if (event.title.startsWith('오늘의 평점')) {
        int rating = int.parse(event.title.split(' ')[2][0]);
        return ratingToEmoji[rating] ?? '❓';
      }
    }
    return '❓'; // 평점이 없는 경우 기본 이모티콘
  }

  void showEditRatingDialog(Event event, DateTime day, int index) {
    double rating =
        double.tryParse(event.title.split(' ')[2].split('/')[0]) ?? 3.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
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
                  onChanged: (double value) {
                    setDialogState(
                        () => rating = value); // 슬라이더 값을 조정할 때마다 로컬 상태 업데이트
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text("취소"),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                child: const Text("삭제"),
                onPressed: () {
                  setState(() {
                    List<Event> updatedEvents =
                        List.from(_getEventsForDay(day));
                    updatedEvents.removeAt(index);
                    kEvents[day] = updatedEvents;
                    _selectedEvents.value = updatedEvents;
                  });
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text("저장"),
                  onPressed: () {
                    setState(() {
                      List<Event> updatedEvents =
                          List.from(_getEventsForDay(day));
                      updatedEvents[index] =
                          Event('오늘의 평점: ${rating.toInt()}/5', isRating: true);
                      kEvents[day] = updatedEvents;
                      _selectedEvents.value = updatedEvents;
                    });
                    Navigator.of(context).pop();
                  }),
            ],
          );
        },
      ),
    );
  }

  void showAddRatingEventDialog(DateTime day) {
    double rating = 3; // 기본 평점 값

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
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
                  onChanged: (double value) {
                    setState(() => rating = value);
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text("취소"),
                  onPressed: () => Navigator.of(context).pop()),
              TextButton(
                  child: const Text("저장"),
                  onPressed: () {
                    setState(() {
                      List<Event> newEvents = List.from(kEvents[day] ?? []);
                      newEvents.add(
                          Event('오늘의 평점: ${rating.toInt()}/5', isRating: true));
                      kEvents[day] = newEvents;
                      _selectedEvents.value = newEvents;
                    });
                    Navigator.of(context).pop();
                  }),
            ],
          );
        },
      ),
    );
  }

  void showEditEventDialog(Event event, DateTime day, int index) {
    TextEditingController controller = TextEditingController(text: event.title);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("기록 수정하기"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "오늘 하루는 어떠셨나요?"),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("취소"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("삭제"),
            onPressed: () {
              setState(() {
                List<Event> updatedEvents = List.from(_getEventsForDay(day));
                updatedEvents.removeAt(index);
                kEvents[day] = updatedEvents;
                _selectedEvents.value = updatedEvents;
              });
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("저장"),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  List<Event> updatedEvents = List.from(_getEventsForDay(day));
                  updatedEvents[index] =
                      Event(controller.text, isRating: event.isRating);
                  kEvents[day] = updatedEvents;
                  _selectedEvents.value = updatedEvents;
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void showAddMessageEventDialog(DateTime day) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("기록 추가하기"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "오늘 하루는 어떠셨나요?"),
        ),
        actions: <Widget>[
          TextButton(
              child: const Text("취소"),
              onPressed: () => Navigator.of(context).pop()),
          TextButton(
              child: const Text("저장"),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    List<Event> newEvents = List.from(kEvents[day] ?? []);
                    newEvents.add(Event(controller.text, isRating: false));
                    kEvents[day] = newEvents;
                    _selectedEvents.value = newEvents;
                  });
                  Navigator.of(context).pop();
                }
              }),
        ],
      ),
    );
  }

  void updateEvents(DateTime day, List<Event> updatedEvents) {
    // 이벤트를 평점 이벤트가 앞에 오도록 정렬
    updatedEvents.sort((a, b) {
      if (a.isRating && !b.isRating) return -1;
      if (!a.isRating && b.isRating) return 1;
      return 0;
    });
    setState(() {
      kEvents[day] = updatedEvents;
      _selectedEvents.value = updatedEvents;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
    if (_getEventsForDay(selectedDay).isEmpty) {
      showAddRatingEventDialog(
          selectedDay); // Only show rating dialog if no events exist
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('[오늘하루] 캘린더뷰'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              DateTime selectedDate = _selectedDay ?? _focusedDay;
              var events = _getEventsForDay(selectedDate);
              bool hasRatingEvent = events.any((e) => e.isRating);

              if (!hasRatingEvent) {
                showAddRatingEventDialog(selectedDate);
              } else {
                showAddMessageEventDialog(selectedDate);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            locale: 'ko_KR',
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final events = _getEventsForDay(day);
                final emoji = getEmojiFromEvents(events);
                return Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)));
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final event = value[index];
                    return ListTile(
                      leading: event.isRating
                          ? const Icon(Icons.star)
                          : const Icon(Icons.message),
                      title: Text(event.title),
                      onTap: () => event.isRating
                          ? showEditRatingDialog(event, _selectedDay!, index)
                          : showEditEventDialog(event, _selectedDay!, index),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/diary');
                },
                child: const Text('자세히 보기'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
