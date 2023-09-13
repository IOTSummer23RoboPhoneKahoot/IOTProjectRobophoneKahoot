import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/charts_stats.dart';

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
  int _countdownTime = 5;
  Timer? _countdownTimer;
  int _questionDuration = 10;
  Timer? _questionTimer;
  Quiz? quiz = quiz_temp;
  List<Player>? chart1 = [];
  Map<String, int>? chart2 = {};
  String? correctAnswer = '';
  @override
  void initState() {
    super.initState();
    _questionDuration =
        int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion);
    listenOnQuizByID(widget.quiz.quizID.toString()).listen((fetchedQuiz) {
      setState(() {
        quiz = fetchedQuiz;
        chart1 = quiz?.getTopPlayers(3);
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
                          chartData: chart1,
                          chartData2: chart2,
                          correctAnswer: correctAnswer,
                        )
                ],
              ),
        SizedBox(height: 20.0),
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

    _countdownTime = 5;
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
      // Update the UI.
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
    print('THE CURRENT QUESTION IS' + _currentQuestionIndex.toString());
    print('THE NUMBER OF  QUESTION IS' +
        widget.quiz.quizDetails.numOfQuestions.toString());
    // updtae correct answer
    correctAnswer = quiz?.getCorrectAnswer(_currentQuestionIndex + 1);
    // update the questions chart
    chart2 = quiz?.getHistogramForQuestion(_currentQuestionIndex + 1);
    if (_currentQuestionIndex <
        int.parse(widget.quiz.quizDetails.numOfQuestions)) {
      _questionText = widget.quiz.questions[_currentQuestionIndex].questionText;
      _answers = widget.quiz.questions[_currentQuestionIndex].options;
    } else {
      print('GOT THE ELSE');
      _questionText = "Quiz completed!";
      _answers = [];
      //TODO: here we got to the end of the quiz so we want to update the state
      //to be end of the game and will show the summary widget,
      // we could add a flag that give us indication for that.
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
  final List<Player>? chartData;
  final Map<String, int>? chartData2;
  String? correctAnswer = '';
  QuestionStats(
      {required this.quiz,
      required this.currentQuestionIndex,
      required this.chartData,
      required this.chartData2,
      required this.correctAnswer});

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
        Text(
          'correct answer is: ${correctAnswer}',
          style: TextStyle(fontSize: 18),
        ),
        // chart for players
        ChartScreen(chartData: chartData),
        // chart for questions
        ChartScreen(chartData: chartData2),
      ],
    );
  }
}
