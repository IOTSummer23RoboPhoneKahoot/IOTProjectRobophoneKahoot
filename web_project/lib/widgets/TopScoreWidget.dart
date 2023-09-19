import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

class HighestScoreWidget extends StatefulWidget {
  final Quiz quiz;

  HighestScoreWidget({required this.quiz});

  @override
  _HighestScoreWidgetState createState() => _HighestScoreWidgetState();
}

class _HighestScoreWidgetState extends State<HighestScoreWidget> {
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
  List<Player> topPlayers = [];

  @override
  void initState() {
    super.initState();
    fetchQuizByID(widget.quiz.quizID).then((fetchedQuiz) {
      setState(() {
        quiz1 = fetchedQuiz ?? quiz1;
        players = quiz1.players;
        topPlayers = quiz1.getTopPlayers(3);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var topPlayers = quiz1.getTopPlayers(1);
    final highestScore = (topPlayers.isNotEmpty)
        ? topPlayers[0].getScore()
        : null; // or some default value
    return Container(
      constraints: BoxConstraints(maxWidth: 50),
      child: Column(
        children: [
          Card(
            elevation: 2.0,
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Highest Score\n ' + '         ' + highestScore.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
