import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async'; // Import needed for StreamSubscription
import 'dart:math';

class FastestPlayerWidget extends StatefulWidget {
  final Quiz quiz;

  FastestPlayerWidget({required this.quiz});
  @override
  _FastestPlayerWidgetState createState() => _FastestPlayerWidgetState();
}

class _FastestPlayerWidgetState extends State<FastestPlayerWidget> {
  List<Player> players = [];
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

  Player fastestPlayer = Player(
    username: '',
    answers: [],
    learn: 0,
    rate: 0,
    score: 0,
  );

  String username = '';
  double totalDiffTime = 0.0;

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  // Fetch quiz data by ID
  void fetchQuizData() {
    fetchQuizByID(widget.quiz.quizID.toString()).then((fetchedQuiz) {
      if (fetchedQuiz != null) {
        setState(() {
          quiz1 = fetchedQuiz;
          players = fetchedQuiz.players;
        });
        totalDiffTime = double.parse(quiz1.quizDetails.numOfQuestions) *
            double.parse(quiz1.quizDetails.timeToAnswerPerQuestion);

        if (players.isNotEmpty) {
          for (final player in players) {
            double PlayerDiffTime = 0.0;
            for (final answer in player.answers) {
              PlayerDiffTime += answer.diffTime.toDouble();
            }
            if (totalDiffTime > PlayerDiffTime) {
              username = player.username;
              totalDiffTime = PlayerDiffTime;
            }
          }
        }
      } else {
        // Handle the case where there was an error or no data was found
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: Size(250, 200),
                  painter: StarIconPainter(
                    username: username,
                    totalDiffTime: totalDiffTime,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StarIconPainter extends CustomPainter {
  final String username;
  final double totalDiffTime;

  StarIconPainter({required this.username, required this.totalDiffTime});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue // Color of the star
      ..style = PaintingStyle.fill; // Fill the star

    final Path path = Path();
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double outerRadius = size.width / 3; // Increase the outer radius
    final double innerRadius = outerRadius / 2; // Increase the inner radius

    // Calculate points for the star shape
    for (int i = 0; i < 10; i++) {
      double radius = i.isEven ? outerRadius : innerRadius;
      double angle = (i * 36 - 90) * (pi / 180);
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint); // Draw the slightly larger star

    // Draw text inside the star
    final TextSpan span = TextSpan(
      text: 'TheFastest \n $username \n diffTime \n $totalDiffTime',
      style: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
    final TextPainter tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    tp.layout();
    final double textX = centerX - (tp.width / 2);
    final double textY = centerY - (tp.height / 2);

    tp.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Column(
  //       children: [
  //         Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Card(
  //                 elevation: 2.0,
  //                 margin: EdgeInsets.all(8.0),
  //                 child: Padding(
  //                   padding: EdgeInsets.all(8.0),
  //                   child: Column(
  //                     children: [
  //                       Text(
  //                         'Fastest Player:  ' + username,
  //                         style: TextStyle(
  //                             fontSize: 14, fontWeight: FontWeight.bold),
  //                       ),
  //                       SizedBox(height: 8.0),
  //                       Text(
  //                         'diffTime:  ' + totalDiffTime.toString(),
  //                         style: TextStyle(
  //                             fontSize: 18, fontWeight: FontWeight.bold),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
