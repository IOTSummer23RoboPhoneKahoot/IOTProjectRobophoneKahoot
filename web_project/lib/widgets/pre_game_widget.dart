import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/widgets/quiz_details_widget.dart';
import 'package:web_project/widgets/players_count_widget.dart';
import 'package:web_project/widgets/players_list_widget.dart';

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
    return Stack(
      children: [
        // Players List on the Left (20% of screen width)
        Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: 0.2,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 30.0),
              child: PlayersListWidget(quizID: widget.quiz.quizID),
            ),
          ),
        ),

        // Quiz Details in the Center (55% of screen width to account for spacing)
        Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor: 0.55,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
              child: QuizDetailsWidget(
                quiz: widget.quiz,
                onStartGame: widget.onStartGame,
              ),
            ),
          ),
        ),

        // Player Count on the Top Right (20% of screen width)
        Align(
          alignment: Alignment.topRight,
          child: FractionallySizedBox(
            widthFactor: 0.2,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 30.0),
              child: PlayerCountWidget(quizID: widget.quiz.quizID),
            ),
          ),
        ),
      ],
    );
  }
}
