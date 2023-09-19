import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/charts_stats.dart';
import 'package:web_project/widgets/topNWinners.dart';

class QuestionStats extends StatefulWidget {
  final Quiz quiz;
  final int currentQuestionIndex;
  String? correctAnswer = '';
  QuestionStats(
      {required this.quiz,
      required this.currentQuestionIndex,
      required this.correctAnswer});

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
    print(' the current quiz id is:' + widget.quiz.quizID.toString());
    Quiz? updatedQuiz = await fetchQuizByID(widget.quiz.quizID.toString());
    List<Player>? chart1;
    Map<String, int>? chart2;

    if (updatedQuiz != null) {
      chart1 = updatedQuiz.getTopPlayers(3);
      print('we are shwoing the quiz number: [in stats]' +
          (widget.currentQuestionIndex + 1).toString());
      chart2 =
          updatedQuiz.getHistogramForQuestion(widget.currentQuestionIndex + 1);
      print('Chart 1 is [ in stats] : ' + chart1.toString());
      print('Chart 2 is [ in stats]: ' + chart2.toString());
      print(' the fetched quiz is [in stats] : ' + updatedQuiz.toString());
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

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Question ${widget.currentQuestionIndex + 1} finished!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Correct answer is: ${widget.correctAnswer}',
                style: TextStyle(fontSize: 18),
              ),
              if (topPlayers != null) TopNWinners(quiz: widget.quiz),
              if (histogram != null) ChartScreen(chartData: histogram),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
