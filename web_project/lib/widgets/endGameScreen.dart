import 'package:web_project/widgets/TopScoreWidget.dart';
import 'package:web_project/widgets/fastestPlayerWidget.dart';
import 'package:web_project/widgets/correctEachQuestionWidget.dart';
import 'package:web_project/widgets/topNWinners.dart';
import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';

class EndGameScreen extends StatefulWidget {
  final Quiz quiz;

  EndGameScreen({required this.quiz});

  @override
  _EndGameScreen createState() => _EndGameScreen();
}

class _EndGameScreen extends State<EndGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('End Game Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.quiz.players.isEmpty
              ? [Center(child: Text("There is no data to show"))]
              : [
                  HighestScoreWidget(quiz: widget.quiz),
                  SizedBox(height: 10),
                  FastestPlayerWidget(quiz: widget.quiz),
                  SizedBox(height: 10),
                  TopNWinners(quiz: widget.quiz),
                  SizedBox(height: 10),
                  CorrectAnswersWidget(quiz: widget.quiz),
                ],
        ),
      ),
    );
  }
}
