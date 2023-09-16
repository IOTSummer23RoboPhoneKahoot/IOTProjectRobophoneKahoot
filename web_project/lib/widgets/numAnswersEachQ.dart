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
    super.initState();
    int questionNum = widget.questionNum;

    _streamSubscription =
        listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null) {
        setState(() {
          players = fetchedQuiz.players;
          numAnswers = fetchedQuiz.getNumOfPlayersAnswered(questionNum + 1);
        });
      } else {
        // Handle the case where there was an error or no data was found
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription?.cancel(); // Cancel the stream subscription
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.0, // Set the width of the circular container
      height: 58.0, // Set the height of the circular container
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Make the container circular
        color: Colors.blue, // Set the background color
      ),
      child: Center(
        child: Text(
          '       $numAnswers \n Answers',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: 13, // Set the font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
