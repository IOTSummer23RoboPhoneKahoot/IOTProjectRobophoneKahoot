import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:web_project/widgets/endGameScreen.dart';
import 'package:web_project/widgets/pre_game_widget.dart';
import 'package:web_project/widgets/in_game_widget.dart';

class GamePage extends StatefulWidget {
  final Quiz quiz;

  GamePage({required this.quiz});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentQuestionIndex = -1;
  Quiz? quiz = quiz_temp;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Robophone Kahoot Game                                                                       $Quiz ID: ${widget.quiz.quizID}'),
      ),
      body: Center(
        child: _currentQuestionIndex == -1
            ? PreGameWidget(
                quiz: widget.quiz,
                onStartGame: _onGameStart,
              )
            : InGameWidget(
                quiz: widget.quiz,
                endGameCallback: _endGame,
              ),
      ),
    );
  }

  void showCustomAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onGameStart() {
    setState(() {
      _currentQuestionIndex = 0; // Initialize to start game.
    });
  }

  void _endGame() {
    // Navigate to the HighestScorePage with the quiz object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EndGameScreen(quiz: widget.quiz),
      ),
    );
  }
}
