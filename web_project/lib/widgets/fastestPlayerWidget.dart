import 'package:flutter/material.dart';

class Player {
  final String name;
  final int diffTime;

  Player(this.name, this.diffTime);
}

class FastestPlayerWidget extends StatefulWidget {
  @override
  _FastestPlayerWidgetState createState() => _FastestPlayerWidgetState();
}

class _FastestPlayerWidgetState extends State<FastestPlayerWidget> {
  List<Player> players = [
    Player('Player 1', 5),
    Player('Player 2', 8),
    Player('Player 3', 7),
    Player('Player 4', 9),
  ];

  Player fastestPlayer = Player('None', 0);

  void findFastestPlayer() {
    for (final player in players) {
      if (player.diffTime > fastestPlayer.diffTime) {
        fastestPlayer = player;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    findFastestPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fastest Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4.0,
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Fastest Player: ' + fastestPlayer.name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Score: ' + fastestPlayer.diffTime.toString(),
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
