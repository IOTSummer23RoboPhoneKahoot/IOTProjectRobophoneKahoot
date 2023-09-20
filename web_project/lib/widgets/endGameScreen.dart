import 'package:web_project/widgets/fastestPlayerWidget.dart';
import 'package:web_project/widgets/correctEachQuestionWidget.dart';
import 'package:web_project/widgets/topNWinners.dart';
import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/widgets/feedbackWidget.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/quiz_detials.dart';
import 'package:routemaster/routemaster.dart';

class EndGameScreen extends StatelessWidget {
  final String quizID;

  EndGameScreen({required this.quizID});

  Future<Quiz?> fetchQuizWithDelay(String quizID) async {
    Quiz? quiz = await fetchQuizByID(quizID);
    await Future.delayed(
        const Duration(seconds: 2)); // Introducing a delay of 2 seconds
    return quiz;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quiz?>(
      future: fetchQuizWithDelay(quizID),
      builder: (BuildContext context, AsyncSnapshot<Quiz?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            Quiz fetchedQuiz = snapshot.data!;
            if (fetchedQuiz.players.isEmpty) {
              return QuizNotPlayedYet(quiz: fetchedQuiz);
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TopNWinners(quiz: fetchedQuiz),
                  SizedBox(height: 5),
                  CorrectAnswersWidget(quiz: fetchedQuiz),
                  SizedBox(height: 5),
                ],
              );
            }
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('Quiz not found.'));
          }
        }
        return Center(
            child: Transform.scale(
          scale: 3,
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}

class QuizNotPlayedYet extends StatelessWidget {
  final Quiz quiz;

  QuizNotPlayedYet({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(quiz.quizDetails.nameOfQuiz,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 12.0),
          Text('Number of Questions: ${quiz.quizDetails.numOfQuestions}',
              style: TextStyle(fontSize: 16)),
          Text(
              'Time per Question: ${quiz.quizDetails.timeToAnswerPerQuestion} seconds',
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 16.0),
          Text("This Quiz is not played yet.",
              style: TextStyle(fontSize: 18, color: Colors.redAccent)),
          SizedBox(height: 12.0),
          ElevatedButton(
            onPressed: () {
              Routemaster.of(context).push('/game/${quiz.quizID}');
            },
            child: Text('Let\'s Play!'),
          ),
        ],
      ),
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Screen'),
      ),
      // Add your feedback content here
      body: Center(
        child: Text('Feedback content goes here'),
      ),
    );
  }
}
