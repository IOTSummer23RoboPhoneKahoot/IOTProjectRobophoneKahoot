import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robophone Kahoot Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  introPage(),
    );
  }
}
class introPage extends StatefulWidget {
  @override
  _introPageState createState() => _introPageState();
}

class _introPageState extends State<introPage> {
  final _databaseRef = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robophone Kahoot Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
              Text('Kahoot Game'), // Move 'Text' widget inside 'child'
                ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GamePage()),
                );
              },
              child: Text('Start Game'), // Move 'Text' widget inside 'child'
            ),
           ],
          // children: <Widget>[
          //   Text(_questionText),
          //   for (var answer in _answers) Text(answer),
          //   ElevatedButton(
          //     onPressed: _showNextQuestion,
          //     child: Text("Show Next Question"),
          //   ),
          // ],
        ),
      ),
    );
  }
}
class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _databaseRef = FirebaseDatabase.instance.ref();
  String _questionText = '';
  List<String> _answers = [];
  int _currentQuestionNumber = 0;

  @override
  void initState() {
    super.initState();
    _loadCurrentQuestionNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robophone Kahoot Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_questionText),
            for (var answer in _answers) Text(answer),
            ElevatedButton(
              onPressed: _showNextQuestion,
              child: Text("Show Next Question"),
            ),
          ],
        ),
      ),
    );
  }

  void _loadCurrentQuestionNumber() async {
    await _databaseRef
        .child('Robophone/currentQuestion')
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        setState(() {
          _currentQuestionNumber =
              int.tryParse(event.snapshot.value.toString()) ??
                  0; // Try to parse, if it fails, default to 0
        });
        _loadQuestion(
            _currentQuestionNumber); // Load question according to the number fetched from the database
      } else {
        // Handle the case where the snapshot value is null, e.g. by setting a default question number or showing an error.
      }
    });
  }

  void _loadQuestion(int questionNumber) async {
    await _databaseRef
        .child('Robophone/questions')
        .child('$questionNumber')
        .once()
        .then((DatabaseEvent event) {
      Map<dynamic, dynamic> questionData =
          event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _questionText = questionData['text'];
        _answers = List<String>.from(questionData['options']);
      });
    });
  }

  void _showNextQuestion() async {
    // Update next question time for all players to 1 minute from now.
    DateTime questionTime = DateTime.now().add(Duration(seconds: 5));
    String nextQuestionTime =
        "${questionTime.hour}:${questionTime.minute}:${questionTime.second}";

    _currentQuestionNumber += 1;

    await _databaseRef.child('Robophone').update({
      "nextHourTime": questionTime.hour,
      "nextMinuteTime": questionTime.minute,
      "nextSecondTime": questionTime.second,
      "nextQuestionTime": nextQuestionTime,
      "currentQuestion": _currentQuestionNumber
    });

    // Fetch and display the next question
    _loadQuestion(_currentQuestionNumber);
  }
}
