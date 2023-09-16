import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/numAnswersEachQ.dart';
import 'package:web_project/widgets/QestionAndAsnwers.dart';
import 'package:web_project/widgets/QuestionsStats.dart';

class InGameWidget extends StatefulWidget {
  final Quiz quiz;
  final Function endGameCallback;

  InGameWidget({required this.quiz, required this.endGameCallback});

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
            ? Text('Starting in: $_countdownTime seconds')
            : (_questionDuration > 0
                ? Column(
                    children: <Widget>[
                      Text('Time left: $_questionDuration seconds'),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: QuestionAndAnswers(
                              questionText: _questionText,
                              answers: _answers,
                            ),
                          ),
                          // Expanded(
                          //   child: AnswersEachQuestion(
                          //     quiz: widget.quiz,
                          //     questionNum: _currentQuestionIndex,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  )
                : QuestionStats(
                    quiz: widget.quiz,
                    currentQuestionIndex: _currentQuestionIndex,
                    correctAnswer: correctAnswer,
                  )),
        SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: is_game_finished == false ? _startCountdown : _endGame,
          child: (_countdownTime == 0 && _questionDuration == 0)
              ? (is_game_finished == false
                  ? Text("Show Next Question")
                  : Text("Show Game Summary"))
              : Container(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuestionView();
  }

  void _startCountdown() async {
    _currentQuestionIndex += 1; // Increment the index here
    await updateNextQuestionTime(widget.quiz, _currentQuestionIndex, 15);
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
    // Fetch the latest quiz data
    Quiz? updatedQuiz = await fetchQuizByID(widget.quiz.quizID.toString());
    if (updatedQuiz != null) {
      chart1 = updatedQuiz.getTopPlayers(3);
      chart2 = updatedQuiz.getHistogramForQuestion(_currentQuestionIndex + 1);
      print('we are shwoing the quiz number:' +
          (_currentQuestionIndex).toString());
      print('Chart 1 is : ' + chart1.toString());
      print('Chart 2 is : ' + chart2.toString());
      if (_currentQuestionIndex < updatedQuiz.questions.length) {
        _questionText =
            updatedQuiz.questions[_currentQuestionIndex].questionText;
        _answers = updatedQuiz.questions[_currentQuestionIndex].options;
        print('questions Text is : ' + _questionText);
        print('answers Text is : ' + _answers.toString());
      }
    } else {
      // Handle the case when the updatedQuiz is null.
    }
  }

  void _startQuestionTimer() {
    _questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_questionDuration > 0) {
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
    widget.endGameCallback();
  }
}
