import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../utils/analyzeDiary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DiaryDetailPage extends StatefulWidget {
  const DiaryDetailPage({super.key});

  @override
  DiaryDetailPageState createState() => DiaryDetailPageState();
}

class DiaryDetailPageState extends State<DiaryDetailPage> {
  double _rating = 3.0;
  final TextEditingController _diaryController = TextEditingController();
  final List<String> _notes = [];
  late DateTime _date;
  late List<dynamic> _events;
  String? apiKey;
  String _analyzedText = "";
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeAPIKey(); // API 키 초기화
  }

  Future<void> _initializeAPIKey() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      apiKey = dotenv.env['GEMINI_API_KEY'];
      // debugPrint("Loaded API Key: $apiKey"); // For debugging purposes
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    _date = args['date'];
    _events = args['events'];
    _notes.addAll(_events
        .where((event) => event is! Rating)
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
    final String date = _date.toLocal().toString().split(' ')[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('Diary Entry - $date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('오늘의 기분은 어떠신가요?', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Text(getEmojiForRating(_rating),
                    style: const TextStyle(fontSize: 24)),
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
            Expanded(child: _buildNotesList()),
            const SizedBox(height: 20),
            if (_isAnalyzing) const CircularProgressIndicator(),
            if (_analyzedText.isNotEmpty) _buildAnalysisResult(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final event = _events[index];
        return ListTile(
          leading: event is Rating
              ? const Icon(Icons.star)
              : const Icon(Icons.message),
          title: Text(event.toString()),
        );
      },
    );
  }

  Widget _buildAnalysisResult() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.teal[50],
          borderRadius: BorderRadius.circular(12.0),
        ),
        width: double.infinity,
        child: SingleChildScrollView(
          child: SelectableText(
            _analyzedText,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.teal[900],
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: _isAnalyzing ? null : _performGeminiAnalysis,
          heroTag: 'GeminiAnalysis',
          child: const Icon(Icons.analytics),
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          onPressed: _addNote,
          heroTag: 'AddNote',
          child: const Icon(Icons.add),
        ),
      ],
    );
  }

  Future<void> _addNote() async {
    final note = await addNoteDialog(context, _diaryController);
    if (note != null) {
      setState(() {
        _notes.add(note);
        _events.add(Note(note));
      });
    }
  }

  Future<void> _performGeminiAnalysis() async {
    if (apiKey == null || apiKey!.isEmpty) {
      debugPrint('API 키가 없습니다. .env 파일을 확인하세요.');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analyzedText = "";
    });

    String diaryContent = '''
      날짜: ${_date.toLocal()}
      별점: ${_rating.toInt()} / 5
      노트:
      ${_notes.join('\n')}
    ''';

    try {
      final String result = await analyzeDiary(context, diaryContent, apiKey!);
      setState(() {
        _analyzedText = result;
      });
    } catch (e) {
      debugPrint('Gemini 분석 중 오류 발생: $e');
      setState(() {
        _analyzedText = '분석 중 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }
}
