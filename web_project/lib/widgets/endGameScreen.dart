import 'package:web_project/widgets/TopScoreWidget.dart';
import 'package:web_project/widgets/fastestPlayerWidget.dart';
import 'package:web_project/widgets/correctEachQuestionWidget.dart';
import 'package:web_project/widgets/topNWinners.dart';
import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

class EndGameScreen extends StatefulWidget {
  final Quiz quiz;

  EndGameScreen({required this.quiz});

  @override
  _EndGameScreenState createState() => _EndGameScreenState();
}

class _EndGameScreenState extends State<EndGameScreen> {
  Quiz? quiz; // Declare a nullable quiz variable here

  @override
  void initState() {
    super.initState();
    fetchQuizByID(widget.quiz.quizID.toString()).then((fetchedQuiz) {
      setState(() {
        quiz = fetchedQuiz;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the quiz data is fetched before rendering the widgets
    if (quiz == null) {
      return Scaffold(body: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('End Game Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: quiz!.players.isEmpty
              ? [Center(child: Text("There is no data to show"))]
              : [
                  HighestScoreWidget(quiz: quiz!),
                  SizedBox(height: 10),
                  FastestPlayerWidget(quiz: quiz!),
                  SizedBox(height: 10),
                  TopNWinners(quiz: quiz!),
                  SizedBox(height: 10),
                  CorrectAnswersWidget(quiz: quiz!),
                ],
        ),
      ),
    );
  }
}
