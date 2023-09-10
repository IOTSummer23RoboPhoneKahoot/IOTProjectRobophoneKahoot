import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/GamePage.dart';

class QuizDetailsPage extends StatelessWidget {
  final Quiz quiz;

  QuizDetailsPage({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(quiz.quizDetails.nameOfQuiz),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(quiz.quizDetails.nameOfQuiz,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('Number of Questions: ${quiz.quizDetails.numOfQuestions}'),
            Text(
                'Time per Question: ${quiz.quizDetails.timeToAnswerPerQuestion} seconds'),
            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) =>
            //             GamePage(quiz: quiz), // Passing the quiz to GamePage
            //       ),
            //     );
            //   },
            //   child: Text('Start Game'),
            // ),
          ],
        ),
      ),
    );
  }
}
