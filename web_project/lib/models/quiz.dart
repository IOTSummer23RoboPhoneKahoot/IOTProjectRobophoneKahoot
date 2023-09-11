class Quiz {
  final String quizID;
  final List<Question> questions;
  final QuizDetails quizDetails;
  //final List<Player> players;

  Quiz({
    required this.quizID,
    required this.questions,
    required this.quizDetails,
    //   required this.players,
  });

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizID: map['quizID']['quizID'] ?? '',
      questions: (map['questions'] as List)
          .where((q) =>
              q != null &&
              q is Map<String, dynamic>) // Filtering out null or non-map values
          .map((q) => Question.fromMap(q as Map<String, dynamic>))
          .toList(),
      quizDetails: QuizDetails.fromMap(map['quizDetails']),
      //players: [],
    );
  }
}

class Question {
  final String correctOptionIndex;
  final List<String> options;
  final String questionID;

  Question({
    required this.correctOptionIndex,
    required this.options,
    required this.questionID,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      correctOptionIndex: map['correctOptionIndex'].toString(),
      options: List<String>.from(map['options'] ?? []),
      questionID: map['question'] ?? '',
    );
  }
}

// class eachQuestionAnswer {
//   final String answerTime;
//   final int diffTime;
//   final int answer;
// }

// class playerQuestions {
//   List<eachQuestionAnswer> QuestionNumber;
//   playerQuestions({
//     required this.QuestionNumber,
//   });
// }

// class Player {
//   final String username;
//   final int score;
//   final List<playerQuestions> questions;

//   factory Player.fromMap(Map<String, dynamic> map) {
//     return Player(
//       username: map['username'] ?? '',
//       score: map['score'],
//       questions: List<playerQuestions>.from(map['questions'] ?? []),
//     );
//   }
//   Player({
//     required this.username,
//     required this.score,
//     required this.questions,
//   });
// }

class QuizDetails {
  final String nameOfQuiz;
  final String numOfQuestions;
  final String timeToAnswerPerQuestion;

  QuizDetails({
    required this.nameOfQuiz,
    required this.numOfQuestions,
    required this.timeToAnswerPerQuestion,
  });

  factory QuizDetails.fromMap(Map<String, dynamic> map) {
    return QuizDetails(
      nameOfQuiz: map['nameOfQuiz'] ?? '',
      numOfQuestions: map['numOfQuestions'] ?? '',
      timeToAnswerPerQuestion: map['timeToAnswerPerQuestion'] ?? '',
    );
  }
}
