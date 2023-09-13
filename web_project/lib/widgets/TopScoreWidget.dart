import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  double findHighestScore() {
    double highestScore = -1 *
        (double.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion)) *
        (double.parse(widget.quiz.quizDetails.numOfQuestions));

    for (final player in players) {
      if (player.score > highestScore) {
        highestScore = player.score;
      }
    }

    return highestScore;
  }

  @override
  Widget build(BuildContext context) {
    final highestScore = quiz1.getTopPlayers(1)[0].getScore();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Highest Score'),
      // ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
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
                    'Highest Score:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    highestScore.toString(),
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Add your chart of the top 3 winners here
                  Container(
                    height: 300, // Adjust the height as needed
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
          ),
        ],
      ),
    );
  }
}
