import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

class HighestScoreWidget extends StatefulWidget {
  final Quiz quiz;

  HighestScoreWidget({required this.quiz});

  @override
  _HighestScoreWidgetState createState() => _HighestScoreWidgetState();
}

class _HighestScoreWidgetState extends State<HighestScoreWidget> {
  List<Player> players = [];
  //final Quiz quiz1 = Quiz(0, [], [], []);
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

  double findHighestScore() {
    double highestScore = -1 *
        (double.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion)) *
        (double.parse(widget.quiz.quizDetails.numOfQuestions));

    for (final player in players) {
      if (player.score > highestScore) {
        highestScore = player.score;
      }
    }

    return highestScore;
  }

  // double findFastestPlayer() {
  //   double diffTime = 0;

  //   for (final player in players) {
  //     diffTime
  //     if (player.score > highestScore) {
  //       highestScore = player.score;
  //     }
  //   }

  //   return highestScore;
  // }

  // Future<List<Player>> fetchPlayers() async {
  //   final _databaseRef = FirebaseDatabase.instance.ref();

  //   try {
  //     DatabaseEvent event = await _databaseRef
  //         .child('Robophone/quizzes/${widget.quiz.quizID}/players')
  //         .once();
  //     DataSnapshot dataSnapshot = event.snapshot;

  //     if (dataSnapshot.value != null && dataSnapshot.value is Map) {
  //       List<Player> players = [];
  //       Map<String, dynamic> playersMap =
  //           dataSnapshot.value as Map<String, dynamic>;
  //       print(playersMap);

  //       playersMap.forEach((key, value) {
  //         print(key);
  //         if (value != null && value is Map) {
  //           try {
  //             players.add(Player.fromMap(value as Map<String, dynamic>));
  //           } catch (e) {
  //             print('Error parsing quiz: $e');
  //           }
  //         }
  //       });

  //       return players;
  //     }

  //     return [];
  //   } catch (e) {
  //     print('Error fetching players: $e');
  //     return Future.error('Failed to load players');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    //fetchPlayers().then((retrievedPlayers) {
    //  setState(() {
    //listonOnQuizByID
    fetchQuizByID(widget.quiz.quizID).then((fetchedQuiz) {
      setState(() {
        quiz1 = fetchedQuiz ?? quiz1;
        players = quiz1.players;
      });
    });
    //players.addAll(retrievedPlayers);
    //  });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final highestScore = findHighestScore();

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Highest Score'),
      // ),
      body: Center(
        child: Card(
          elevation: 2.0,
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(
              children: [
                Text(
                  'Highest Score',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1.0),
                Text(
                  highestScore.toString(),
                  style: TextStyle(fontSize: 5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:web_project/models/quiz.dart';
// import 'package:web_project/services/firebase_service.dart';

// class HighestScoreWidget extends StatefulWidget {
//   final Quiz quiz;

//   HighestScoreWidget({required this.quiz});

//   @override
//   _PlayerListScreenState createState() => _PlayerListScreenState(); 
//   final List<Player> players = [];

//   double findHighestScore() {
//     double highestScore = -1 *
//         (double.parse(quiz.quizDetails.timeToAnswerPerQuestion)) *
//         (double.parse(quiz.quizDetails.numOfQuestions));

//     for (final player in players) {
//       if (player.score > highestScore) {
//         highestScore = player.score;
//       }
//     }

//     return highestScore;
//   }

//   Future<List<Player>> fetchQuizzes() async {
//     final _databaseRef = FirebaseDatabase.instance.ref();

//     try {
//       DatabaseEvent event = await _databaseRef
//           .child('Robophone/quizzes/${widget.quiz.quizID}/players')
//           .once();
//       DataSnapshot dataSnapshot = event.snapshot;

//       if (dataSnapshot.value != null && dataSnapshot.value is Map) {
//         List<Player> players = [];
//         Map<String, dynamic> playersMap =
//             dataSnapshot.value as Map<String, dynamic>;
//         print(playersMap);

//         playersMap.forEach((key, value) {
//           print(key);
//           if (value != null && value is Map) {
//             try {
//               players.add(Player.fromMap(value as Map<String, dynamic>));
//             } catch (e) {
//               print('Error parsing quiz: $e');
//             }
//           }
//         });

//         return players;
//       }

//       return [];
//     } catch (e) {
//       print('Error fetching quizzes: $e');
//       return Future.error('Failed to load quizzes');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final highestScore = findHighestScore();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Highest Score'),
//       ),
//       body: Center(
//         child: Card(
//           elevation: 4.0,
//           margin: EdgeInsets.all(16.0),
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Text(
//                   'Highest Score',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   highestScore.toString(),
//                   style: TextStyle(fontSize: 24),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


 // void fetchPlayersFromDatabase() {
  //   final databaseReference = FirebaseDatabase.instance.ref();

  //   // Replace 'players' with the actual path to your player data in the database
  //   final playersRef = databaseReference
  //       .child('Robophone/quizzes/${widget.quiz.quizID}/players');

  //   playersRef.once().then((DataSnapshot snapshot) {
  //     final Map<dynamic, dynamic> playersData = snapshot.value;

  //     if (playersData != null) {
  //       // Clear the existing players list
  //       players.clear();

  //       // Iterate through player data and add them to the players list
  //       playersData.forEach((key, value) {
  //         final Map<String, dynamic> playerData = value;
  //         final String name = playerData['name'];
  //         final int score = playerData['score'];

  //         final player = Player(
  //           name: name,
  //           score: score,
  //         );

  //         players.add(player);
  //       });

  //       // Now, players list is populated with data from the database
  //       // You can update the UI or perform other operations with the data
  //     } else {
  //       // Handle the case where no player data is found in the database
  //     }
  //   }).catchError((error) {
  //     // Handle errors if any occur during database fetch
  //     print('Error fetching players: $error');
  //   });
  // }