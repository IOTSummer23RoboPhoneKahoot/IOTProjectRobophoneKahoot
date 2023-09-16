import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/charts_stats.dart';

class QuestionStats extends StatelessWidget {
  final Quiz quiz;
  final int currentQuestionIndex;
  final List<Player>? chartData;
  final Map<String, int>? chartData2;
  String? correctAnswer = '';
  QuestionStats(
      {required this.quiz,
      required this.currentQuestionIndex,
      required this.chartData,
      required this.chartData2,
      required this.correctAnswer});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Question ${currentQuestionIndex + 1} finished!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Text(
          'Quiz ID: ${quiz.quizID}',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'correct answer is: ${correctAnswer}',
          style: TextStyle(fontSize: 18),
        ),
        // chart for players
        ChartScreen(chartData: chartData),
        // chart for questions
        ChartScreen(chartData: chartData2),
      ],
    );
  }
}
