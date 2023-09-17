// in widgets/player_count_widget.dart

import 'package:flutter/material.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';

class PlayerCountWidget extends StatefulWidget {
  final String quizID;

  PlayerCountWidget({required this.quizID});

  @override
  _PlayerCountWidgetState createState() => _PlayerCountWidgetState();
}

class _PlayerCountWidgetState extends State<PlayerCountWidget> {
  int playersNum = 0;
  StreamSubscription? _quizSubscription;

  @override
  void initState() {
    super.initState();
    _quizSubscription = listenOnQuizByID(widget.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null && mounted) {
        setState(() {
          playersNum = fetchedQuiz.players.length;
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                playersNum.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold, // Making the number appear bold
                ),
              ),
              SizedBox(
                  height: 10), // A little space between number and "Players"
              Text(
                "Players",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
