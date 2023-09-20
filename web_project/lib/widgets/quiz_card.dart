import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/widgets/quiz_detials.dart';
import 'package:routemaster/routemaster.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;

  QuizCard({required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0, // Remove the shadow from the card
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Add rounded corners
      ),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          // builder: (context) => QuizDetailsPage(quiz: quiz),
          //   ),
          // );
          Routemaster.of(context).push('/gameSummary/${quiz.quizID}');
        },
        borderRadius: BorderRadius.circular(
            15.0), // Match the InkWell's border radius with the card's
        child: Padding(
          padding:
              EdgeInsets.all(16.0), // Increased padding for more space inside
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quiz.quizDetails.nameOfQuiz,
                style: TextStyle(
                  fontSize: 24, // Increased font size for the title
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple, // Change color for emphasis
                ),
              ),
              SizedBox(height: 12.0), // Increased spacing for better separation
              Text(
                'Number of Questions: ${quiz.quizDetails.numOfQuestions}',
                style:
                    TextStyle(fontSize: 16), // Consistent font size for details
              ),
              SizedBox(height: 6.0), // Moderate spacing
              Text(
                'Time per Question: ${quiz.quizDetails.timeToAnswerPerQuestion} seconds',
                style:
                    TextStyle(fontSize: 16), // Consistent font size for details
              ),
            ],
          ),
        ),
      ),
    );
  }
}
