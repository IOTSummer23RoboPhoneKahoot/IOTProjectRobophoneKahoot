import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/widgets/numAnswersEachQ.dart';
import 'package:web_project/widgets/QestionAndAsnwers.dart';
import 'package:web_project/widgets/QuestionDurationTimerWidget.dart';

class QuizGameWidget extends StatefulWidget {
  final Quiz quiz;
  final int currentQuestionIndex;
  final int duration;

  QuizGameWidget(
      {required this.quiz,
      required this.currentQuestionIndex,
      required this.duration});

  @override
  _QuizGameWidgetState createState() => _QuizGameWidgetState();
}

class _QuizGameWidgetState extends State<QuizGameWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Timer on the Left (20% of screen width)
        Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            widthFactor: 0.2,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10.0),
              child: CircularCountdownQuestionDurtationTimer(
                duration: widget.duration,
                // int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion),
                onDone: () {
                  print(
                      "Timer done!"); // Placeholder, you can update this later.
                },
              ),
            ),
          ),
        ),

        // Question and Answers in the Center (55% of screen width)
        Align(
          alignment: Alignment.topCenter,
          child: FractionallySizedBox(
            widthFactor: 0.55,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
              child: QuestionAndAnswers(
                questionText: widget
                    .quiz.questions[widget.currentQuestionIndex].questionText,
                answers:
                    widget.quiz.questions[widget.currentQuestionIndex].options,
              ),
            ),
          ),
        ),

        // Placeholder for Third Widget on the Right (20% of screen width)
        Align(
          alignment: Alignment.topRight,
          child: FractionallySizedBox(
            widthFactor: 0.2,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 30.0),
              child: AnswersEachQuestion(
                  quizID: widget.quiz.quizID,
                  questionNum: widget.currentQuestionIndex),
            ),
          ),
        ),
      ],
    );
  }
}
