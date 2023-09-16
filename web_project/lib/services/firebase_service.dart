import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/models/quiz.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

Future<List<Quiz>> fetchQuizzes() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final _databaseRef = FirebaseDatabase.instance.ref();
  try {
    DatabaseEvent event = await _databaseRef.child('Robophone/quizzes').once();
    DataSnapshot dataSnapshot = event.snapshot;
    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
      List<Quiz> quizzes = [];
      Map<String, dynamic> quizzesMap =
          dataSnapshot.value as Map<String, dynamic>;
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

Future<String?> fetchPin() async {
  final _databaseRef = FirebaseDatabase.instance.ref();

  try {
    DatabaseEvent event =
        await _databaseRef.child('sabaaTest/bigPinNum').once();
    DataSnapshot dataSnapshot = event.snapshot;

    if (dataSnapshot.value != null) {
      try {
        print('pinnnnnnnnnnnnn');
        print(dataSnapshot.value);
        return dataSnapshot.value as String?;
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

Future<void> updatePin(String? newPin) async {
  final _databaseRef = FirebaseDatabase.instance.ref();

  try {
    // Update the value at the specified path
    if (newPin != null) {
      int pin = int.parse(newPin) + 1;
      await _databaseRef.child('sabaaTest/bigPinNum').set(pin.toString());
    }
  } catch (e) {
    print('Error updating pin: $e');
    throw Exception('Failed to update the pin');
  }
}

Stream<Quiz?> listenOnQuizByID(String quizID) {
  final _databaseRef = FirebaseDatabase.instance.ref();

  return _databaseRef.child('Robophone/quizzes/$quizID').onValue.map((event) {
    final dataSnapshot = event.snapshot.value;
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
