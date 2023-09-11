import 'package:flutter/material.dart';

class PlayerListScreen extends StatefulWidget {
  @override
  _PlayerListScreenState createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  final List<Player> players = [
    Player('Player 1'),
    Player('Player 2'),
    Player('Player 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player List'),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(players[index].name),
          );
        },
      ),
    );
  }
}

class Player {
  final String name;

  Player(this.name);
}
