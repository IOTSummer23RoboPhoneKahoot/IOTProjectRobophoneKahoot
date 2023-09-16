import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/playersjoinWidget.dart';
import 'package:web_project/widgets/endGameScreen.dart';
import 'package:web_project/widgets/numAnswersEachQ.dart';
import 'package:web_project/widgets/QestionAndAsnwers.dart';
import 'package:web_project/widgets/QuestionsStats.dart';
import 'package:web_project/widgets/pre_game_widget.dart';
import 'package:web_project/widgets/in_game_widget.dart';

class GamePage extends StatefulWidget {
  final Quiz quiz;

  GamePage({required this.quiz});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _databaseRef = FirebaseDatabase.instance.ref();
  String _questionText = '';
  List<String> _answers = [];
  int _currentQuestionIndex = -1;
  int _countdownTime = 2;
  Timer? _countdownTimer;
  int _questionDuration = 10;
  Timer? _questionTimer;
  Quiz? quiz = quiz_temp;
  List<Player>? chart1 = [];
  Map<String, int>? chart2 = {};
  String? correctAnswer = '';
  bool is_game_finished = false;
  @override
  void initState() {
    super.initState();

    fetchQuizByID(widget.quiz.quizID.toString()).then((fetchedQuiz) {
      setState(() {
        quiz = fetchedQuiz;
        chart1 = quiz?.getTopPlayers(3);
        _questionDuration =
            int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion) - 1;
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robophone Kahoot Game'),
      ),
      body: Center(
        child: _currentQuestionIndex == -1
            ? PreGameWidget(
                quiz: widget.quiz,
                onStartGame: _onGameStart,
              )
            : InGameWidget(
                quiz: widget.quiz,
                endGameCallback: _endGame,
              ),
      ),
    );
  }

  void showCustomAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startCountdown() async {
    setState(() {
      _questionDuration =
          int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion);
      _currentQuestionIndex += 1;
      _countdownTime = 2;
    });
  }

  void _onGameStart() {
    setState(() {
      _currentQuestionIndex = 0; // Initialize to start game.
    });
  }

  void _endGame() {
    // Navigate to the HighestScorePage with the quiz object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EndGameScreen(quiz: widget.quiz),
      ),
    );
  }
}
