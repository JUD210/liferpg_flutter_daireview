import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/utils.dart'; // utils.dart에서 함수와 kEvents 가져오기

class TableCalendarPage extends StatefulWidget {
  const TableCalendarPage({super.key});

  @override
  TableCalendarPageState createState() => TableCalendarPageState();
}

class TableCalendarPageState extends State<TableCalendarPage> {
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void showEditRatingDialog(Rating ratingEvent, DateTime day, int index) {
    double rating = ratingEvent.score.toDouble();

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
                    setDialogState(() => rating = value);
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
                    List<dynamic> updatedEvents =
                        List.from(getEventsForDay(day));
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
                      List<dynamic> updatedEvents =
                          List.from(getEventsForDay(day));
                      updatedEvents[index] = Rating(rating.toInt());
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
    double rating = 3;

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
                      List<dynamic> newEvents = List.from(kEvents[day] ?? []);
                      newEvents.add(Rating(rating.toInt()));
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

  void showEditEventDialog(Note noteEvent, DateTime day, int index) {
    // Note의 description을 사용하여 초기화
    TextEditingController controller =
        TextEditingController(text: noteEvent.description);

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
                List<dynamic> updatedEvents = List.from(getEventsForDay(day));
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
                  List<dynamic> updatedEvents = List.from(getEventsForDay(day));
                  updatedEvents[index] =
                      Note(controller.text); // description만 사용
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
                    List<dynamic> newEvents = List.from(kEvents[day] ?? []);
                    newEvents.add(Note(controller.text));
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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = getEventsForDay(selectedDay);
    });
    if (getEventsForDay(selectedDay).isEmpty) {
      showAddRatingEventDialog(selectedDay);
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
              var events = getEventsForDay(selectedDate);
              bool hasRatingEvent = events.any((e) => e is Rating);

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
          TableCalendar<dynamic>(
            locale: 'ko_KR',
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final events = getEventsForDay(day);
                final emoji = getEmojiFromEvents(events);
                return Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)));
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<dynamic>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final event = value[index];
                    return ListTile(
                      leading: event is Rating
                          ? const Icon(Icons.star)
                          : const Icon(Icons.message),
                      title: Text(event.toString()),
                      onTap: () => event is Rating
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
                  DateTime selectedDate = _selectedDay ?? _focusedDay;
                  List<dynamic> selectedEvents = getEventsForDay(selectedDate);

                  Navigator.of(context).pushNamed(
                    '/diary',
                    arguments: {
                      'selectedDate': selectedDate,
                      'events': selectedEvents,
                    },
                  );
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
