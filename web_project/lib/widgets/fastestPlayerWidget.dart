import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

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
      score: 0); // Declare the fastestPlayer here
  String username = '';
  double totalDiffTime = 0.0;

  @override
  void initState() {
    super.initState();

    listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
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
              // fastestPlayer.username = player.username;
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

  Widget temp(BuildContext context) {
    return build(context);
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
                Card(
                  elevation: 4.0,
                  margin: EdgeInsets.all(16.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Fastest Player:' + username,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'diffTime: ' + totalDiffTime.toString(),
                          style: TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
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
// import 'package:flutter/material.dart';
// import 'package:web_project/models/quiz.dart';
// import 'package:web_project/services/firebase_service.dart';

// class FastestPlayerWidget extends StatefulWidget {
//   final Quiz quiz;

//   FastestPlayerWidget({required this.quiz});
//   @override
//   _FastestPlayerWidgetState createState() => _FastestPlayerWidgetState();
// }

// class _FastestPlayerWidgetState extends State<FastestPlayerWidget> {
//   List<Player> players = [];
//   Quiz quiz1 = Quiz(
//     quizID: '',
//     questions: [],
//     quizDetails: QuizDetails(
//       nameOfQuiz: '',
//       numOfQuestions: '',
//       timeToAnswerPerQuestion: '',
//     ),
//     players: [],
//   );
//   Player fastestPlayer = Player(
//       username: '',
//       answers: [],
//       learn: 0,
//       rate: 0,
//       score: 0); // Declare the fastestPlayer here
//   String username = '';
//   double totalDiffTime = 0.0;
//   @override
//   void initState() {
//     super.initState();

//     listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
//       if (fetchedQuiz != null) {
//         setState(() {
//           quiz1 = fetchedQuiz;
//           players = fetchedQuiz.players;
//         });
//         totalDiffTime = double.parse(quiz1.quizDetails.numOfQuestions) *
//             double.parse(quiz1.quizDetails.timeToAnswerPerQuestion);
//         if (players.isNotEmpty) {
//           for (final player in players) {
//             double PlayerDiffTime = totalDiffTime;
//             for (final answer in player.answers) {
//               PlayerDiffTime += answer.diffTime.toDouble();
//             }
//             if (totalDiffTime > PlayerDiffTime) {
//               // fastestPlayer.username = player.username;
//               username = player.username;
//               totalDiffTime = PlayerDiffTime;
//             }
//           }
//           print(
//               '****************************************************************');
//           print(username);
//         }
//       } else {
//         // Handle the case where there was an error or no data was found
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fastest Player'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Card(
//               elevation: 4.0,
//               margin: EdgeInsets.all(16.0),
//               child: Padding(
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Fastest Player: ' + fastestPlayer.username,
//                       // (fastestPlayer != null
//                       //     ? fastestPlayer.username
//                       //     : 'N/A'),
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 8.0),
//                     Text(
//                       'diffTime: ' + totalDiffTime.toString(),
//                       // (fastestPlayer != null
//                       //     ? totalDiffTime.toString()
//                       //     : 'N/A'),
//                       style: TextStyle(fontSize: 24),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
