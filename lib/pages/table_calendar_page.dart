import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/utils.dart';

class TableCalendarPage extends StatefulWidget {
  const TableCalendarPage({super.key});

  @override
  TableCalendarPageState createState() => TableCalendarPageState();
}

class TableCalendarPageState extends State<TableCalendarPage> {
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month; // final 제거
  final DateTime _focusedDay = DateTime.now();
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

  void updateEvents(DateTime day, List<dynamic> events) {
    setState(() {
      kEvents[day] = events;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _selectedEvents.value = getEventsForDay(selectedDay);
    });
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
                showAddRatingEventDialog(
                  context,
                  selectedDate,
                  selectedEvents: _selectedEvents,
                  updateEvents: updateEvents,
                );
              } else {
                showAddMessageEventDialog(
                  context,
                  selectedDate,
                  selectedEvents: _selectedEvents,
                  updateEvents: updateEvents,
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<dynamic>(
            locale: 'ko_KR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            eventLoader: getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final events = getEventsForDay(day);
                final emoji = getEmojiFromEvents(events); // 날짜별 이모지 표시
                return Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                );
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
                          ? showEditRatingDialog(
                              context,
                              event,
                              _selectedDay!,
                              index,
                              selectedEvents: _selectedEvents,
                              updateEvents: updateEvents,
                            )
                          : showEditEventDialog(
                              context,
                              event,
                              _selectedDay!,
                              index,
                              selectedEvents: _selectedEvents,
                              updateEvents: updateEvents,
                            ),
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
                      'date': selectedDate,
                      'events': selectedEvents,
                    },
                  );
                },
                child: const Text('자세히 보기'), // 자세히 보기 버튼 추가
              ),
            ),
          ),
        ],
      ),
    );
  }
}
