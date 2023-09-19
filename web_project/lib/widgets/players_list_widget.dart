import 'dart:math'; // Import the math library for min function
import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';

class PlayersListWidget extends StatefulWidget {
  final String quizID;

  PlayersListWidget({required this.quizID});

  @override
  _PlayersListWidgetState createState() => _PlayersListWidgetState();
}

class _PlayersListWidgetState extends State<PlayersListWidget> {
  List<Player> players = [];
  StreamSubscription? _quizSubscription;

  @override
  void initState() {
    super.initState();
    _quizSubscription = listenOnQuizByID(widget.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null && mounted) {
        setState(() {
          players = fetchedQuiz.players;
        });
      }
    });
  }

  @override
  void dispose() {
    _quizSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The height per item, you can adjust as needed
    final double itemHeight = 60.0;
    final double titleHeight = 40.0; // Adjust based on your styling
    final double maxListHeight =
        400.0; // Define a maximum height as you see fit

    double calculatedHeight = (players.length * itemHeight) + titleHeight;

    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Players Joined",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...players
                  .map((player) => Card(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        color: Color.fromARGB(255, 241, 227, 227),
                        child: ListTile(
                          title: Text(player.username),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
