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
      home: GamePage(),
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
            // ElevatedButton(
            //   onPressed: () {
            //     // This can be filled in with answer handling logic.
            //   },
            //   child: Text(answer),
            // ),
            ElevatedButton(
              onPressed: _showNextQuestion,
              child: Text("Show Next Question"),
            ),
          ],
        ),
      ),
    );
  }

  void _showNextQuestion() async {
    // Update next question time for all players to 1 minute from now.
    DateTime nextQuestionTime = DateTime.now().add(Duration(minutes: 1));
    String formattedTime =
        "${nextQuestionTime.hour}:${nextQuestionTime.minute}:${nextQuestionTime.second}";
    _databaseRef.child('Robophone/players').once().then((DatabaseEvent event) {
      Map<dynamic, dynamic> players =
          event.snapshot.value as Map<dynamic, dynamic>;
      for (var playerId in players.keys) {
        _databaseRef.child('Robophone/players').child(playerId).update({
          "nextQuestionTime": formattedTime,
          "nextQuestionNumber": _currentQuestionNumber + 1
        });
      }
    });

// Fetch the next question from the database and update UI.
    _databaseRef
        .child('Robophone/questions')
        .child('${_currentQuestionNumber + 1}')
        .once()
        .then((DatabaseEvent event) {
      Map<dynamic, dynamic> questionData =
          event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        _questionText = questionData['text'];
        _answers = List<String>.from(questionData['options']);
        _currentQuestionNumber += 1;
      });
    });
  }
}
