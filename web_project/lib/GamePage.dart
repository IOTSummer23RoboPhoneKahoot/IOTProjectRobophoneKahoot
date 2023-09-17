import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:web_project/widgets/endGameScreen.dart';
import 'package:web_project/widgets/pre_game_widget.dart';
import 'package:web_project/widgets/in_game_widget.dart';

class GamePage extends StatefulWidget {
  final String quizId;

  GamePage({required this.quizId});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentQuestionIndex = -1;
  bool _postGame = false;
  Quiz? quiz = quiz_temp;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Robophone Kahoot Game                                                                       $Quiz ID: ${widget.quizId}'),
        automaticallyImplyLeading: false, // This will remove the back arrow
      ),
      body: Center(
        child: FutureBuilder<Quiz?>(
          future: fetchQuizByID(widget.quizId),
          builder: (BuildContext context, AsyncSnapshot<Quiz?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                Quiz fetchedQuiz = snapshot.data!;
                return _currentQuestionIndex == -1
                    ? PreGameWidget(
                        quiz: fetchedQuiz,
                        onStartGame: _onGameStart,
                      )
                    : !_postGame
                        ? InGameWidget(
                            quiz: fetchedQuiz,
                            endGameCallback: _endGame,
                          )
                        : EndGameScreen(quizID: fetchedQuiz.quizID);
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Quiz not found.');
              }
            }
            return CircularProgressIndicator(); // show loader while waiting for data
          },
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
    setState(() {
      _postGame = true; // Initialize to start game.
    });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EndGameScreen(quiz: widget.quiz),
    //   ),
    // );
  }
}
