import 'package:flutter/material.dart';

class Player {
  final String name;
  final int score;

  Player(this.name, this.score);
}

class HighestScoreWidget extends StatelessWidget {
  final List<Player> players = [
    Player('Player 1', 10),
    Player('Player 2', 20),
    Player('Player 3', 80),
    Player('Player 4', 100),
  ];

  int findHighestScore() {
    int highestScore = 0;

    for (final player in players) {
      if (player.score > highestScore) {
        highestScore = player.score;
      }
    }

    return highestScore;
  }

  @override
  Widget build(BuildContext context) {
    final highestScore = findHighestScore();

    return Scaffold(
      appBar: AppBar(
        title: Text('Highest Score'),
      ),
      body: Center(
        child: Card(
          elevation: 4.0,
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Highest Score',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  highestScore.toString(),
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
