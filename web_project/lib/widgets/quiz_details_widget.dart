import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';

class QuizDetailsWidget extends StatelessWidget {
  final Quiz quiz;
  final Function onStartGame;

  QuizDetailsWidget({required this.quiz, required this.onStartGame});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 100.0), // Create more space from the top
        // Sharper and bigger QuizPIN at the top
        Container(
          padding: EdgeInsets.all(40.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(4.0), // Reduced for sharpness
            boxShadow: [
              BoxShadow(
                color: Colors.black45, // Darker shadow for sharpness
                blurRadius: 8.0,
              ),
            ],
          ),
          child: Text(
            'QuizPIN: ${quiz.quizID}',
            style: TextStyle(
              fontSize: 50, // Increased font size for prominence
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quiz.quizDetails.nameOfQuiz,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              SizedBox(height: 12.0),
              Text(
                'Number of Questions: ${quiz.quizDetails.numOfQuestions}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8.0),
              Text(
                'Time per Question: ${quiz.quizDetails.timeToAnswerPerQuestion} seconds',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Sharper Play Quiz button with adjusted position
        Padding(
          padding: const EdgeInsets.only(
            bottom: 80.0,
          ), // More padding at the bottom to lift it higher
          child: ElevatedButton.icon(
            onPressed: () => onStartGame(),
            icon: Icon(Icons.play_arrow, size: 40),
            label: Text('Play Quiz'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding: EdgeInsets.symmetric(
                  horizontal: 60.0,
                  vertical: 30.0), // Increase padding to make the button larger
              textStyle: TextStyle(fontSize: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // Reduced for sharpness
              ),
            ),
          ),
        ),
      ],
    );
  }
}
