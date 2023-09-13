import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/models/quiz.dart';
import 'dart:async';

Future<List<Quiz>> fetchQuizzes() async {
  final _databaseRef = FirebaseDatabase.instance.ref();

  try {
    DatabaseEvent event = await _databaseRef.child('Robophone/quizzes').once();
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
      List<Quiz> quizzes = [];
      Map<String, dynamic> quizzesMap =
          dataSnapshot.value as Map<String, dynamic>;
      print(quizzesMap);

      quizzesMap.forEach((key, value) {
        print(key);
        if (value != null && value is Map) {
          try {
            quizzes.add(Quiz.fromMap(value as Map<String, dynamic>));
          } catch (e) {
            print('Error parsing quiz: $e');
          }
        }
      });

      return quizzes;
    }

    return [];
  } catch (e) {
    print('Error fetching quizzes: $e');
    return Future.error('Failed to load quizzes');
  }
}

Future<Quiz?> fetchQuizByID(String quizID) async {
  final _databaseRef = FirebaseDatabase.instance.ref();

  try {
    DatabaseEvent event =
        await _databaseRef.child('Robophone/quizzes/$quizID').once();
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
      try {
        return Quiz.fromMap(dataSnapshot.value as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing quiz: $e');
        return null;
      }
    }
    return null;
  } catch (e) {
    print('Error fetching quiz: $e');
    return Future.error('Failed to load the quiz');
  }
}

// Future<Quiz?> listenOnQuizByID(String quizID) async {
//   final _databaseRef = FirebaseDatabase.instance.ref();

//   try {
//     DatabaseEvent event = await _databaseRef
//         .child('Robophone/quizzes/$quizID')
//         .onChildAdded
//         .listen((event) {
//           final  dataSnapshot = event.snapshot.value;

//     if (dataSnapshot.value != null && dataSnapshot.value is Map) {
//       try {
//         return Quiz.fromMap(dataSnapshot.value as Map<String, dynamic>);
//       } catch (e) {
//         print('Error parsing quiz: $e');
//         return null;
//       }
//     }
//     return null;
//   } catch (e) {
//     print('Error fetching quiz: $e');
//     return Future.error('Failed to load the quiz');
//   }});

// }

Stream<Quiz?> listenOnQuizByID(String quizID) {
  final _databaseRef = FirebaseDatabase.instance.ref();

  return _databaseRef.child('Robophone/quizzes/$quizID').onValue.map((event) {
    final dataSnapshot = event.snapshot.value;
    // print('***************************');
    //print(dataSnapshot);
    if (dataSnapshot != null && dataSnapshot is Map) {
      try {
        return Quiz.fromMap(dataSnapshot as Map<String, dynamic>);
      } catch (e) {
        print('Error parsing quiz: $e');
        return null;
      }
    }
    return null;
  }).handleError((error) {
    print('Error listening to quiz: $error');
  });
}

//listonOnQuizByID
Future<List<Player>?> _startListeningForPlayers(String quizID) async {
  final playersRef = FirebaseDatabase.instance
      .ref()
      .child('Robophone/quizzes/$quizID/players');

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
      // players.add(player);
    } catch (e) {
      print('Error parsing player: $e');
    }
  }, onError: (error) {
    print('Error listening for players: $error');
  });
}















// // Function to fetch player details from Firebase Realtime Database
// Future<List<Player>> fetchPlayerDetailsFromDatabase(String quizID) async {
//   final playersRef = FirebaseDatabase.instance
//       .ref()
//       .child('Robophone/quizzes/$quizID/players');
//   try {
//     DatabaseEvent event = await playersRef.once();
//     DataSnapshot snapshot = event.snapshot;
//     if (snapshot.value != null && snapshot.value is Map) {
//       List<Player> players = [];
//       Map<String, dynamic> playerData = snapshot.value as Map<String, dynamic>;
//       print(playerData);

//       playerData.forEach((key, value) {
//         print(key);
//         if (value != null && value is Map) {
//           try {
//             players.add(Player(
//               //.fromMap(value as Map<String, dynamic>));
//               username: value['username'],
//               answers: [], //value['answers'],
//               learn: 0, //value['learn'],
//               rate: 0, //value['rate'],
//               score: 0, // value['score'],
//             ));
//           } catch (e) {
//             print('Error parsing player: $e');
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

// Stream<List<Player>> listenForPlayerDetailsFromDatabase(String quizID) {
//   final playersRef = FirebaseDatabase.instance
//       .ref()
//       .child('Robophone/quizzes/$quizID/players');

//   StreamController<List<Player>> controller = StreamController();

//   playersRef.onChildAdded.listen((event) {
//     DataSnapshot snapshot = event.snapshot;

//     if (snapshot.value != null && snapshot.value is Map) {
//       List<Player> players = [];
//       Map<String, dynamic> playerData = snapshot.value as Map<String, dynamic>;

//       try {
//         players.add(Player(
//           username: playerData['username'],
//           answers: [], // Add your logic for answers.
//           learn: 0, // Add your logic for learn.
//           rate: 0, // Add your logic for rate.
//           score: 0, // Add your logic for score.
//         ));
//       } catch (e) {
//         print('Error parsing player: $e');
//       }
//     }
//   });

//   playersRef.onChildRemoved.listen((event) {
//     // Handle removal of players if needed.
//     // You can notify the UI to remove the player from the list.
//   });

//   return controller.stream;
// }
