import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';

class AnswersEachQuestion extends StatefulWidget {
  final String quizID;
  final int questionNum;
  // final int numAnswers;
  AnswersEachQuestion({
    required this.quizID,
    required this.questionNum,
  });
  // required this.numAnswers});
  //required this.numAnswers});

  @override
  _AnswersEachQuestionState createState() => _AnswersEachQuestionState();
}

class _AnswersEachQuestionState extends State<AnswersEachQuestion> {
  int numAnswers = 0;
  List<Player> players = [];

  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = listenOnQuizByID(widget.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null && mounted) {
        setState(() {
          players = fetchedQuiz.players;
          numAnswers =
              fetchedQuiz.getNumOfPlayersAnswered(widget.questionNum, players);
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
    return Padding(
      padding: EdgeInsets.only(left: 20.0), // Add left margin
      child: Container(
        width: 50.0, // Set a fixed width for the circle
        height: 50.0, // Set a fixed height for the circle
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue, // Set the circle color
        ),
        child: Center(
          child: Text(
            '$numAnswers',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          // child: Text(
          //   'Answers',
          //   style: TextStyle(fontSize: 20),
          // ),
        ),
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(right: 20.0), // Add right margin
  //     child: Column(
  //       children: <Widget>[
  //         Text(
  //           '$numAnswers',
  //           style: TextStyle(fontSize: 20),
  //         ),
  //         Text(
  //           'Answers',
  //           style: TextStyle(fontSize: 20),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
