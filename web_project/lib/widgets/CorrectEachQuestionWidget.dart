import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

class CorrectAnswersWidget extends StatefulWidget {
  final Quiz quiz;
  CorrectAnswersWidget({required this.quiz});

  @override
  _CorrectAnswersWidgetState createState() => _CorrectAnswersWidgetState();
}

class ChartData {
  final String x;
  final int y1;
  final Color color;

  ChartData(this.x, this.y1, this.color);
}

class _CorrectAnswersWidgetState extends State<CorrectAnswersWidget> {
  List<Question> questions = [];
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
    fetchQuizByID(widget.quiz.quizID).then((fetchedQuiz) {
      setState(() {
        quiz1 = fetchedQuiz ?? quiz1;
        players = quiz1.players;
        questions = quiz1.questions;
      });
    });
  }

  List<ChartData> computeCorrectAnswers() {
    final List<ChartData> correctAnswersCount = List.generate(
      questions.length,
      (index) {
        final correctAnswer = questions[index].correctOptionIndex;
        int count = 0;

        for (final player in players) {
          final playerAnswer = player.answers[index];

          if (playerAnswer.answer == int.parse(correctAnswer)) {
            count++;
          }
        }

        return ChartData('Question ${index + 1}', count, Colors.blue);
      },
    );

    return correctAnswersCount;
  }

  @override
  Widget build(BuildContext context) {
    final correctAnswersCount = computeCorrectAnswers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Correct Answers Count'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Correct Answers Count for Each Question:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              series: <ChartSeries>[
                ColumnSeries<ChartData, String>(
                  dataSource: correctAnswersCount,
                  xValueMapper: (ChartData ch, _) => ch.x,
                  yValueMapper: (ChartData ch, _) => ch.y1,
                  pointColorMapper: (ChartData ch, _) => ch.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
