import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

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
    fetchQuizByID(widget.quiz.quizID).then((fetchedQuiz) {
      setState(() {
        quiz1 = fetchedQuiz ?? quiz1;
        topPlayers = quiz1.getTopPlayers(3);
      });
    });
  }

  Widget buildWinnerPentagon(Player player, int place) {
    // Calculate the size based on the player's score
    double size =
        5.0 + (player.score * 2.5); // You can adjust the factor (5.0) as needed

    return Column(
      children: [
        Container(
          width: size, // Adjust the size based on the player's score
          height: size, // Adjust the size based on the player's score
          child: ClipPath(
            clipper: MyPentagonClipper(), // Custom clip path for pentagon shape
            child: Container(
              color: Colors.blue, // Change the color as needed
              child: Center(
                child: Text(
                  player.score.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                  'TOP 3 WINNERS:',
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
