import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async'; // needed for Timer

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
  int _countdownTime = 5; // assuming countdown is for 5 seconds
  Timer? _countdownTimer; // a timer for countdown

  @override
  void initState() {
    super.initState();
    print(widget.quiz.quizDetails.nameOfQuiz);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
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
            ? _buildQuizDetails()
            : _buildQuestionView(),
      ),
    );
  }

  Widget _buildQuizDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.quiz.quizDetails.nameOfQuiz,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Text('Number of Questions: ${widget.quiz.quizDetails.numOfQuestions}'),
        Text(
            'Time per Question: ${widget.quiz.quizDetails.timeToAnswerPerQuestion} seconds'),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _startCountdown,
          child: Text('Start Game'),
        ),
      ],
    );
  }

  Widget _buildQuestionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _countdownTime > 0
            ? Text('Starting in: $_countdownTime seconds')
            : Column(
                children: [
                  Text(_questionText),
                  for (var answer in _answers) Text(answer),
                  SizedBox(
                      height: 20.0), // adding a little space for visual appeal
                  ElevatedButton(
                    onPressed: _showNextQuestion,
                    child: Text("Show Next Question"),
                  ),
                ],
              ),
      ],
    );
  }

  void _startCountdown() {
    setState(() {
      _currentQuestionIndex += 1;
    });

    _countdownTime = 5; // reset countdown time to 5 seconds

    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownTime > 0) {
          _countdownTime--;
        } else {
          timer.cancel();
          _showNextQuestion();
        }
      });
    });
  }

  void _showNextQuestion() async {
    setState(() {
      if (_currentQuestionIndex < widget.quiz.questions.length) {
        _questionText = widget.quiz.questions[_currentQuestionIndex].questionID;
        _answers = widget.quiz.questions[_currentQuestionIndex].options;
      } else {
        _questionText = "Quiz completed!";
        _answers = [];
      }
    });

    DateTime questionTime = DateTime.now().add(Duration(seconds: 5));
    String nextQuestionTime =
        "${questionTime.hour}:${questionTime.minute}:${questionTime.second}";

    Map<String, dynamic> updateData = {
      "nextHourTime": questionTime.hour,
      "nextMinuteTime": questionTime.minute,
      "nextSecondTime": questionTime.second,
      "nextQuestionTime": nextQuestionTime,
      "currentQuestion": _currentQuestionIndex
    };

    await _databaseRef
        .child('MahmoudTesting/quizzes/${widget.quiz.quizID}')
        .update(updateData);
  }
}
