import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:web_project/widgets/endGameScreen.dart';

class GameSummaryPage extends StatelessWidget {
  final String quizID;

  GameSummaryPage({required this.quizID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robophone Kahoot Game Summary'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Routemaster.of(context).push('/');
          },
          tooltip: 'Go to Home',
        ),
      ),
      body: EndGameScreen(quizID: quizID),
    );
  }
}
