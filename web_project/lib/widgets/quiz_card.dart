import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/quiz_detials.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;

  QuizCard({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizDetailsPage(quiz: quiz),
          ),
        );
      },
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(quiz.quizDetails.nameOfQuiz,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.0),
              Text('Number of Questions: ${quiz.quizDetails.numOfQuestions}'),
              Text(
                  'Time per Question: ${quiz.quizDetails.timeToAnswerPerQuestion} seconds'),
            ],
          ),
        ),
      ),
    );
  }
}
