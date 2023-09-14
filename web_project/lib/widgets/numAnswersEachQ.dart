import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

class AnswersEachQuestion extends StatefulWidget {
  final Quiz quiz;
  final int questionNum;
  AnswersEachQuestion({required this.quiz, required this.questionNum});

  @override
  _AnswersEachQuestion createState() => _AnswersEachQuestion();
}

class _AnswersEachQuestion extends State<AnswersEachQuestion> {
  int options = 0;
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

  @override
  void initState() {
    super.initState();
    int questionNum = widget.questionNum;

    listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null) {
        setState(() {
          quiz1 = fetchedQuiz;
          players = fetchedQuiz.players;
        });
        if (players.isNotEmpty) {
          for (final player in players) {
            int answer = player.answers[questionNum].answer;
            if (answer != 0) {
              options++;
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Number of Players:',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(
          options.toString(),
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
