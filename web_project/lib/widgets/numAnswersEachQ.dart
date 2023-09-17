import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';

class AnswersEachQuestion extends StatefulWidget {
  final Quiz quiz;
  final int questionNum;
  AnswersEachQuestion({required this.quiz, required this.questionNum});

  @override
  _AnswersEachQuestionState createState() => _AnswersEachQuestionState();
}

class _AnswersEachQuestionState extends State<AnswersEachQuestion> {
  int numAnswers = 0;
  List<Player> players = [];

  StreamSubscription? _streamSubscription; // Add this line

  @override
  void initState() {
    int questionNum = widget.questionNum;
    super.initState();
    _streamSubscription =
        listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null && mounted) {
        setState(() {
          players = fetchedQuiz.players;
          numAnswers = fetchedQuiz.getNumOfPlayersAnswered(questionNum + 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel(); // Cancel the stream subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
