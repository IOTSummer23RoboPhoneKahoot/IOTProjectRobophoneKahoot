class Quiz {
  final String quizID;
  final List<Question> questions;
  final QuizDetails quizDetails;

  Quiz({
    required this.quizID,
    required this.questions,
    required this.quizDetails,
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
