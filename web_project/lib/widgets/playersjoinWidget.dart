import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/services/firebase_service.dart';

class PlayerListScreen extends StatefulWidget {
  final Quiz quiz;

  PlayerListScreen({required this.quiz});

  @override
  _PlayerListScreenState createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  List<Player> players = [];
  Quiz quiz1 = Quiz(
    quizID: 'your_quiz_id',
    questions: [
      Question(
        correctOptionIndex: '2',
        options: ['1', '2', '3', '4'],
        questionID: 1,
        questionText: 'How are you?',
      ),
      // Add more Question objects as needed
    ],
    quizDetails: QuizDetails(
      nameOfQuiz: 'Your Quiz Name',
      numOfQuestions: '3',
      timeToAnswerPerQuestion: '20',
    ),
    players: [
      Player(
        username: 'player1',
        answers: [
          Answer(answer: 2, diffTime: 10, questionID: 1),
          // Add more Answer objects as needed
        ],
        learn: 0,
        rate: 0,
        score: 25,
      ),
      // Add more Player objects as needed
    ],
  );
  // @override
  // void initState() {
  //   super.initState();
  //   // _startListeningForPlayers();
  //   listenOnQuizByID(widget.quiz.quizID).then((fetchedQuiz) {
  //     setState(() {
  //       quiz1 = fetchedQuiz ?? quiz1;
  //       players = quiz1.players;
  //     });
  //   });
  // }
  @override
  void initState() {
    super.initState();

    listenOnQuizByID(widget.quiz.quizID).listen((fetchedQuiz) {
      if (fetchedQuiz != null) {
        setState(() {
          quiz1 = fetchedQuiz;
          players = fetchedQuiz.players;
        });
      } else {
        // Handle the case where there was an error or no data was found
      }
    });
  }

  void _startListeningForPlayers() {
    final playersRef = FirebaseDatabase.instance
        .ref()
        .child('Robophone/quizzes/${widget.quiz.quizID}/players');

    playersRef.onChildAdded.listen((event) {
      final playerData = event.snapshot.value as Map<String, dynamic>;
      try {
        final player = Player(
          username: playerData['username'],
          answers: [],
          learn: 0,
          score: 0,
          rate: 0,
        );

        setState(() {
          players.add(player);
        });
      } catch (e) {
        print('Error parsing player: $e');
      }
    }, onError: (error) {
      print('Error listening for players: $error');
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Players List'),
//       ),
//       body: Container(
//         height: 100, // Set a fixed height for the container
//         child: ListView.builder(
//           itemCount: players.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(
//                 players[index].username,
//                 style: TextStyle(fontSize: 10), // Adjust font size
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players List'),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(players[index].username),
          );
        },
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:web_project/models/quiz.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:web_project/GamePage.dart';
// import 'package:web_project/services/firebase_service.dart';

// class PlayerListScreen extends StatefulWidget {
//   final Quiz quiz;

//   PlayerListScreen({required this.quiz});

//   @override
//   _PlayerListScreenState createState() => _PlayerListScreenState();
// }

// class _PlayerListScreenState extends State<PlayerListScreen> {
//   List<Player> players = [];

//   @override
//   void initState() {
//     super.initState();
//     // Fetch player details from the database and populate the players list.

//     fetchPlayerDetailsFromDatabase(widget.quiz.quizID).then((fetchedPlayers) {
//       //listenForPlayerDetailsFromDatabase(widget.quiz.quizID).listen((fetchedPlayers) {
//       setState(() {
//         players = fetchedPlayers;
//       });
//     });
//   }







  // @override
  // void initState() {
  //   super.initState();
  //   _startListeningForPlayers();
  // }

  // void _startListeningForPlayers() {
  //   listenForPlayerDetailsFromDatabase(widget.quiz.quizID).listen(
  //       (fetchedPlayers) {
  //     setState(() {
  //       players = fetchedPlayers;
  //     });
  //   }, onError: (error) {
  //     print('Error fetching players: $error');
  //     // Handle error here, e.g., show an error message to the user.
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseDatabase.instance
  //       .ref()
  //       .child('Robophone/quizzes/${widget.quiz.quizID}/players')
  //       .onChildAdded
  //       .listen((event) {
  //     setState(() {
  //       players.add(Player(
  //         //.fromMap(value as Map<String, dynamic>));
  //         username: event.snapshot.child('username').value.toString(),
  //         answers: [], //value['answers'],
  //         learn: 0, //value['learn'],
  //         rate: 0, //value['rate'],
  //         score: 0, // value['score'],
  //       ));
  //     });
  //   });
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Player List'),
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














//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Player List'),
//       ),
//       body: ListView.builder(
//         itemCount: players.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(players[index].username),
//             onTap: () {
//               // Navigate to the GamePage when a player is tapped
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => GamePage(quiz: players[index].quiz),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


