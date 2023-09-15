// import 'package:flutter/material.dart';
// import 'package:web_project/models/quiz.dart';
// import 'package:web_project/services/firebase_service.dart';

// class PlayerListScreen extends StatefulWidget {
//   final Quiz quiz;

//   PlayerListScreen({required this.quiz});

//   @override
//   _PlayerListScreenState createState() => _PlayerListScreenState();
// }

// class _PlayerListScreenState extends State<PlayerListScreen> {
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
//   @override
//   void initState() {
//     super.initState();

//     listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
//       if (fetchedQuiz != null) {
//         setState(() {
//           quiz1 = fetchedQuiz;
//           players = fetchedQuiz.players;
//         });
//       } else {
//         // Handle the case where there was an error or no data was found
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Players List'),
//       ),
//       body: ListView.builder(
//         itemCount: players.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(players[index].username),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

class PlayerListScreen extends StatefulWidget {
  final Quiz quiz;
  PlayerListScreen({required this.quiz});
  @override
  _PlayerListScreenState createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  int playersNum = 0;
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
  @override
  void initState() {
    super.initState();
    listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null) {
        setState(() {
          quiz1 = fetchedQuiz;
          players = fetchedQuiz.players;
          playersNum = players.length;
        });
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Number of Players: $playersNum'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(players[index].username),
              );
            },
          ),
        ),
      ],
    );
  }
}
