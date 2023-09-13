import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:web_project/widgets/playersjoinWidget.dart';
import 'package:web_project/widgets/TopScoreWidget.dart';
import 'package:web_project/widgets/fastestPlayerWidget.dart';
import 'package:web_project/widgets/correctEachQuestionWidget.dart';

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
  bool _quizCompleted = false; // Track quiz completion

  @override
  void initState() {
    super.initState();
    _questionDuration =
        int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion);
    print(widget.quiz.quizDetails.nameOfQuiz);
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
        child: _quizCompleted
            ? _buildQuizCompletedView()
            : _currentQuestionIndex == -1
                ? _buildQuizDetails()
                : _buildQuestionView(),
      ),
    );
  }

  void _joinPlayers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerListScreen(quiz: widget.quiz),
      ),
    );
  }

  Widget _buildQuizDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.quiz.quizDetails.nameOfQuiz,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text('Number of Questions: ${widget.quiz.quizDetails.numOfQuestions}'),
        Text(
          'Time per Question: ${widget.quiz.quizDetails.timeToAnswerPerQuestion} seconds',
        ),
        Text(
          'QuizPIN: ${widget.quiz.quizID}',
        ),
        SizedBox(height: 10.0),
        ElevatedButton(
          onPressed: _startCountdown,
          child: Text('Start Game'),
        ),
        ElevatedButton(
          onPressed: _joinPlayers,
          child: Text('Join Players'),
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
                  _questionDuration > 0
                      ? Column(
                          children: <Widget>[
                            Text('Time left: $_questionDuration seconds'),
                            QuestionAndAnswers(
                                questionText: _questionText, answers: _answers),
                          ],
                        )
                      : QuestionStats(
                          quiz: widget.quiz,
                          currentQuestionIndex: _currentQuestionIndex,
                        ),
                ],
              ),
        SizedBox(height: 20.0),
        if (!_quizCompleted) // Display "Show Next Question" button conditionally
          _questionDuration == 0
              ? ElevatedButton(
                  onPressed: _startCountdown,
                  child: Text("Show Next Question"),
                )
              : Container(),
      ],
    );
  }

  void _startCountdown() {
    setState(() {
      _questionDuration =
          int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion);
      _currentQuestionIndex += 1;
    });

    _countdownTime = 2;
    _showNextQuestion();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownTime > 0) {
          _countdownTime--;
        } else {
          timer.cancel();

          _startQuestionTimer();
        }
      });
    });
  }

  void _startQuestionTimer() {
    if (_questionTimer != null) {
      _questionTimer!.cancel();
    }

    _questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_questionDuration > 0) {
          _questionDuration--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _showNextQuestion() async {
    if (_currentQuestionIndex <
        int.parse(widget.quiz.quizDetails.numOfQuestions)) {
      _questionText = widget.quiz.questions[_currentQuestionIndex].questionText;
      _answers = widget.quiz.questions[_currentQuestionIndex].options;
    } else {
      _questionText = "Quiz completed!";
      _answers = [];
      setState(() {
        _quizCompleted = true;
      });
    }

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
        .child('Robophone/quizzes/${widget.quiz.quizID}')
        .update(updateData);
  }

  Widget _buildQuizCompletedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Quiz Completed',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: _endGame,
          child: Text("End Game"),
        ),
      ],
    );
  }

  void _endGame() {
    // Navigate to the HighestScorePage with the quiz object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HighestScoreWidget(quiz: widget.quiz),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FastestPlayerWidget(quiz: widget.quiz),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CorrectAnswersWidget(quiz: widget.quiz),
      ),
    );
  }
}

class QuestionAndAnswers extends StatelessWidget {
  final String questionText;
  final List<String> answers;

  QuestionAndAnswers({required this.questionText, required this.answers});

  @override
  Widget build(BuildContext context) {
    if (questionText.isEmpty) {
      return Text('Waiting for question...');
    }

    return Column(
      children: <Widget>[
        Text(questionText,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.0),
        ...answers
            .map((answer) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(answer),
                ))
            .toList(),
      ],
    );
  }
}

class QuestionStats extends StatelessWidget {
  final Quiz quiz;
  final int currentQuestionIndex;

  QuestionStats({required this.quiz, required this.currentQuestionIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Question ${currentQuestionIndex + 1} finished!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Text(
          'Quiz ID: ${quiz.quizID}',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
