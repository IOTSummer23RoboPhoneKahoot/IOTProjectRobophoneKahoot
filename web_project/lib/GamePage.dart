import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';

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
  int _currentQuestionIndex =
      -1; // Initial value set to -1 to show quiz details first

  @override
  void initState() {
    super.initState();
    print(widget.quiz.quizDetails.nameOfQuiz);
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
          onPressed: _showNextQuestion,
          child: Text('Start Game'),
        ),
      ],
    );
  }

  Widget _buildQuestionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(_questionText),
        for (var answer in _answers) Text(answer),
        ElevatedButton(
          onPressed: _showNextQuestion,
          child: Text("Show Next Question"),
        ),
      ],
    );
  }

  void _showNextQuestion() async {
    // 1. Update the local state for the next question
    setState(() {
      _currentQuestionIndex += 1;
      if (_currentQuestionIndex < widget.quiz.questions.length) {
        _questionText = widget.quiz.questions[_currentQuestionIndex].questionID;
        _answers = widget.quiz.questions[_currentQuestionIndex].options;
      } else {
        _questionText = "Quiz completed!";
        _answers = [];
      }
    });

    // 2. Prepare the data for Firebase update
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

    // 3. Update Firebase with the new data
    await _databaseRef
        .child('MahmoudTesting/quizzes/${widget.quiz.quizID}')
        .update(updateData);
  }
}
