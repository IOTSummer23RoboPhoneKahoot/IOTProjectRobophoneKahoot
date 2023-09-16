// in widgets/pre_game_widget.dart

import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/widgets/playersjoinWidget.dart';

class PreGameWidget extends StatefulWidget {
  final Quiz quiz;
  final Function onStartGame;

  PreGameWidget({required this.quiz, required this.onStartGame});

  @override
  _PreGameWidgetState createState() => _PreGameWidgetState();
}

class _PreGameWidgetState extends State<PreGameWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.quiz.quizDetails.nameOfQuiz,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                      'Number of Questions: ${widget.quiz.quizDetails.numOfQuestions}'),
                  Text(
                      'Time per Question: ${widget.quiz.quizDetails.timeToAnswerPerQuestion} seconds'),
                  Text('QuizPIN: ${widget.quiz.quizID}'),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () => widget.onStartGame(),
                    child: Text('Start Game'),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: BoxConstraints(maxHeight: 300.0),
              child: PlayerListScreen(quiz: widget.quiz),
            ),
          ),
        ),
      ],
    );
  }
}
