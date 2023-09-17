import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async'; // Import needed for StreamSubscription
import 'dart:math';

class FastestPlayerWidget extends StatefulWidget {
  final Quiz quiz;

  FastestPlayerWidget({required this.quiz});
  @override
  _FastestPlayerWidgetState createState() => _FastestPlayerWidgetState();
}

class _FastestPlayerWidgetState extends State<FastestPlayerWidget> {
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

  Player fastestPlayer = Player(
    username: '',
    answers: [],
    learn: 0,
    rate: 0,
    score: 0,
  );

  String username = '';
  double totalDiffTime = 0.0;

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  // Fetch quiz data by ID
  void fetchQuizData() {
    fetchQuizByID(widget.quiz.quizID.toString()).then((fetchedQuiz) {
      if (fetchedQuiz != null) {
        setState(() {
          quiz1 = fetchedQuiz;
          players = fetchedQuiz.players;
        });
        totalDiffTime = double.parse(quiz1.quizDetails.numOfQuestions) *
            double.parse(quiz1.quizDetails.timeToAnswerPerQuestion);

        if (players.isNotEmpty) {
          for (final player in players) {
            double PlayerDiffTime = 0.0;
            for (final answer in player.answers) {
              PlayerDiffTime += answer.diffTime.toDouble();
            }
            if (totalDiffTime > PlayerDiffTime) {
              username = player.username;
              totalDiffTime = PlayerDiffTime;
            }
          }
        }
      } else {
        // Handle the case where there was an error or no data was found
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(maxWidth: 250),
          //margin: EdgeInsets.symmetric(horizontal: 70.0),
          child: Card(
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.pink,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Fastest Player:  ' + username,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.purple,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'diffTime:  ' + totalDiffTime.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
