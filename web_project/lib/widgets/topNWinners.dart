import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:math';

class TopNWinners extends StatefulWidget {
  final Quiz quiz;

  TopNWinners({required this.quiz});

  @override
  _TopNWinnersState createState() => _TopNWinnersState();
}

class _TopNWinnersState extends State<TopNWinners> {
  Quiz quiz1 = Quiz(
    quizID: '',
    questions: [],
    quizDetails: QuizDetails(
      nameOfQuiz: '',
      numOfQuestions: '',
      timeToAnswerPerQuestion: '',
    ),
    players: [],
  );
  List<Player> topPlayers = [];

  @override
  void initState() {
    super.initState();
    print('the quiz in top winnder is:' + widget.quiz.toString());
    fetchQuizByID(widget.quiz.quizID).then((fetchedQuiz) {
      setState(() {
        quiz1 = fetchedQuiz ?? quiz1;
        topPlayers = quiz1.getTopPlayers(3);
      });
    });
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  String doubleFormat(double number) {
    String formattedNumber = number.toStringAsFixed(2);
    if (formattedNumber.endsWith('.00')) {
      formattedNumber = formattedNumber.replaceAll('.00', '');
    }
    return formattedNumber;
  }

  Widget buildWinnerPentagon(Player player, int place) {
    final double largestSize =
        90.0; // Define a constant size for the largest player
    double size = largestSize -
        (place - 1) * 10.0; // Calculate the size based on the player's place
    final playerColor = getRandomColor();
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          child: ClipPath(
            clipper: MyPentagonClipper(),
            child: Container(
              color: playerColor,
              child: Center(
                child: Text(
                  doubleFormat(player.score),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Text(
          '${place == 1 ? '1st' : place == 2 ? '2nd' : '3rd'} Place',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          player.username,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: FractionallySizedBox(
        widthFactor: 0.3,
        child: Card(
          elevation: 2.0,
          child: Container(
            constraints: BoxConstraints(maxWidth: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOP 3',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: topPlayers.asMap().entries.map((entry) {
                    final player = entry.value;
                    final place = entry.key + 1;
                    return buildWinnerPentagon(player, place);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyPentagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.lineTo(0, size.height * 0.3);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
