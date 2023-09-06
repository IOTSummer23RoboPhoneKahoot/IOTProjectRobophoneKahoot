import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/models/quiz.dart';

Future<List<Quiz>> fetchQuizzes() async {
  final _databaseRef = FirebaseDatabase.instance.ref();

  try {
    DatabaseEvent event =
        await _databaseRef.child('MahmoudTesting/quizzes').once();
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
