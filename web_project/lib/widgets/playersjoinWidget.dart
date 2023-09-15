import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async'; // Import needed for StreamSubscription

class PlayerListScreen extends StatefulWidget {
  final Quiz quiz;
  PlayerListScreen({required this.quiz});
  @override
  _PlayerListScreenState createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  int playersNum = 0;
  List<Player> players = [];
  Quiz quiz1 = Quiz(
    quizID: '',
    questions: [],
    quizDetails: QuizDetails(
      nameOfQuiz: '',
      numOfQuestions: '',
      timeToAnswerPerQuestion: '',
    ),
    players: [],
  );

  StreamSubscription?
      _quizSubscription; // Declare a StreamSubscription at the class level

  @override
  void initState() {
    super.initState();
    _quizSubscription =
        listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null && mounted) {
        // Check for mounted before setState
        setState(() {
          quiz1 = fetchedQuiz;
          players = fetchedQuiz.players;
          playersNum = players.length;
        });
      } else {
        // Handle the case where there was an error or no data was found
      }
    });
  }

  @override
  void dispose() {
    _quizSubscription?.cancel(); // Cancel the StreamSubscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Number of Players: $playersNum'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(players[index].username),
              );
            },
          ),
        ),
      ],
    );
  }
}
