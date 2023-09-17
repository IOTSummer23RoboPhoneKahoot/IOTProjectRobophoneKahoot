import 'package:web_project/widgets/fastestPlayerWidget.dart';
import 'package:web_project/widgets/correctEachQuestionWidget.dart';
import 'package:web_project/widgets/topNWinners.dart';
import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/widgets/feedbackWidget.dart';
import 'package:web_project/services/firebase_service.dart';

class EndGameScreen extends StatelessWidget {
  final String quizID;

  EndGameScreen({required this.quizID});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quiz?>(
      future: fetchQuizByID(quizID),
      builder: (BuildContext context, AsyncSnapshot<Quiz?> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data != null) {
            Quiz fetchedQuiz = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: fetchedQuiz.players.isEmpty
                  ? [Center(child: Text("There is no data to show"))]
                  : [
                      TopNWinners(quiz: fetchedQuiz),
                      SizedBox(height: 5),
                      CorrectAnswersWidget(quiz: fetchedQuiz),
                      SizedBox(height: 5), // Add some space
                    ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: Text('Quiz not found.'));
          }
        }
        return Center(
            child:
                CircularProgressIndicator()); // Show loader while waiting for data.
      },
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
