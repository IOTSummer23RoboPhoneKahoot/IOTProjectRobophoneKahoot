import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/QuestionsStats.dart';
import 'package:web_project/widgets/before_question_labeled_timer_widget.dart';
import 'package:routemaster/routemaster.dart';
import 'package:web_project/widgets/ShowQuestionWidget.dart';

class InGameWidget extends StatefulWidget {
  final Quiz quiz;

  InGameWidget({required this.quiz});

  @override
  _InGameWidgetState createState() => _InGameWidgetState();
}

class _InGameWidgetState extends State<InGameWidget> {
  String _questionText = '';
  List<String> _answers = [];
  int _currentQuestionIndex = -1;
  int _countdownTime = 2;
  Timer? _countdownTimer;
  int _questionDuration = 10;
  Timer? _questionTimer;
  List<Player>? chart1 = [];
  Map<String, int>? chart2 = {};
  String? correctAnswer = '';
  bool is_game_finished = false;
  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }

  Widget _buildQuestionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _countdownTime > 0
            ? LabelledCountdownTimer(
                duration: _countdownTime,
                onDone: () {},
              )
            : (_questionDuration > 0
                ? QuizGameWidget(
                    quiz: widget.quiz,
                    currentQuestionIndex: _currentQuestionIndex,
                    duration: _questionDuration,
                  )
                : QuestionStats(
                    quiz: widget.quiz,
                    currentQuestionIndex: _currentQuestionIndex,
                  )),
        SizedBox(height: 20.0),
        (_countdownTime == 0 && _questionDuration == 0)
            ? ElevatedButton(
                onPressed:
                    is_game_finished == false ? _startCountdown : _endGame,
                child: (_countdownTime == 0 && _questionDuration == 0)
                    ? (is_game_finished == false
                        ? Text("Show Next Question")
                        : Text("Show Game Summary"))
                    : Container(),
              )
            : Container()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuestionView();
  }

  void _startCountdown() async {
    _currentQuestionIndex += 1; // Increment the index here
    await updateNextQuestionTime(widget.quiz, _currentQuestionIndex, 2);
    await _showNextQuestion(); // Fetch the question here

    setState(() {
      _questionDuration =
          int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion);
      _countdownTime = 2;
    });

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

  Future<void> _showNextQuestion() async {
    if (_currentQuestionIndex < widget.quiz.questions.length) {
      _questionText = widget.quiz.questions[_currentQuestionIndex].questionText;
      _answers = widget.quiz.questions[_currentQuestionIndex].options;
      // print('questions Text is : ' + _questionText);
      // print('answers Text is : ' + _answers.toString());
    }
  }

  void _startQuestionTimer() {
    _questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_questionDuration > 0) {
          print('qustion duration [in in_game_widget]' +
              _questionDuration.toString() +
              '\n');
          _questionDuration--;
        } else {
          timer.cancel();
          if (_currentQuestionIndex + 1 >= widget.quiz.questions.length) {
            _finishGame();
          }
        }
      });
    });
  }

  void _finishGame() {
    setState(() {
      is_game_finished = true;
    });
  }

  void _endGame() {
    Routemaster.of(context).push('/gameSummary/${widget.quiz.quizID}');
  }
}
