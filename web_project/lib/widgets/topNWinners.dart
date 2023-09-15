import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TopNWinners extends StatefulWidget {
  final Quiz quiz;

  TopNWinners({required this.quiz});

  @override
  _TopNWinners createState() => _TopNWinners();
}

class _TopNWinners extends State<TopNWinners> {
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
        topPlayers = quiz1.getTopPlayers(3);
      });
    });
  }

  Widget temp(BuildContext context) {
    return build(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOP 3 WINNERS:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 100,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<Player, String>(
                    dataSource: topPlayers,
                    xValueMapper: (Player player, _) => player.username,
                    yValueMapper: (Player player, _) => player.score,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
