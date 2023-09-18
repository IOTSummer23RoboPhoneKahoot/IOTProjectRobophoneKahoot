import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/charts_stats.dart';
import 'package:web_project/widgets/topNWinners.dart';
import 'package:web_project/optionStatWidget.dart';

class QuestionStats extends StatefulWidget {
  final Quiz quiz;
  final int currentQuestionIndex;
  QuestionStats({required this.quiz, required this.currentQuestionIndex});

  @override
  _QuestionStatsState createState() => _QuestionStatsState();
}

class _QuestionStatsState extends State<QuestionStats> {
  late Future<List<dynamic>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    Quiz? updatedQuiz = await fetchQuizByID(widget.quiz.quizID.toString());
    List<Player>? chart1;
    Map<String, int>? chart2;

    if (updatedQuiz != null) {
      chart1 = updatedQuiz.getTopPlayers(3);
      chart2 =
          updatedQuiz.getHistogramForQuestion(widget.currentQuestionIndex + 1);
    }
    await Future.delayed(
        const Duration(seconds: 5)); // Introducing a delay of 2 seconds

    return [chart1, chart2];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print('the error is : ' + snapshot.error.toString());
            return Text("Error fetching data.");
          }

          List<Player>? topPlayers = snapshot.data?[0];
          Map<String, int>? histogram = snapshot.data?[1];
          //Map<int, int> histogram2 = snapshot.data?[1];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 16.0),
              Text(
                'Question ${widget.currentQuestionIndex + 1} finished!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                'Correct answer is: ${widget.quiz.questions[widget.currentQuestionIndex].correctOptionIndex}',
                style: TextStyle(fontSize: 18),
              ),
              if (topPlayers != null) TopNWinners(quiz: widget.quiz),
              if (histogram != null) ChartScreen(chartData: histogram),
              // MyRectangleRow(
              //     histogramData:
              //         histogram2), //ChartScreen(chartData: histogram),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
