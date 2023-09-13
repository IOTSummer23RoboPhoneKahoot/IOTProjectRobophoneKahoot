var absent = Question(
    correctOptionIndex: '-1',
    options: [],
    questionID: -1,
    questionText: 'absent');

class Quiz {
  final String quizID;
  final List<Question> questions;
  final QuizDetails quizDetails;
  final List<Player> players; // Added players list

  Quiz({
    required this.quizID,
    required this.questions,
    required this.quizDetails,
    required this.players,
  });

  @override
  String toString() {
    return 'Quiz(quizID: $quizID, questions: $questions, quizDetails: $quizDetails, players: $players)';
  }

  List<Player> getTopPlayers(int x) {
    List<Player> sortedPlayers = List.from(players);
    sortedPlayers.sort((a, b) => b.getScore().compareTo(a.getScore()));
    return sortedPlayers.take(x).toList();
  }

  double getAverageScore() {
    int total = players.fold(0, (sum, player) => sum + player.getScore());
    return players.isEmpty ? 0.0 : total / players.length;
  }

  Map<String, int> getHistogramForQuestion(int questionID) {
    Map<String, int> histogram = {};

    // Get the target question
    Question? targetQuestion = questions.firstWhere(
        (q) => q.questionID == questionID,
        orElse: () => Question(
            correctOptionIndex: '-1',
            options: [],
            questionID: -1,
            questionText: "dummey")); // This is a dummy question

    // Initialize histogram with 0 for each option
    for (String option in targetQuestion.options) {
      histogram[option] = 0;
    }

    // Iterate over players' answers and update histogram
    for (Player player in players) {
      Answer? answerForQuestion = player.answers.firstWhere(
          (a) => a.questionID == questionID,
          orElse: () => Answer(
              answer: -1,
              diffTime: -1,
              questionID: -1)); // This is a dummy answer

      if (answerForQuestion.answer != -1) {
        // Check against the dummy answer's value
        String answeredOption =
            targetQuestion.options[answerForQuestion.answer - 1];
        histogram[answeredOption] = (histogram[answeredOption] ?? 0) + 1;
      }
    }

    return histogram;
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizID: map['quizID']['quizID'] ?? '',
      questions: (map['questions'] as List)
          .asMap() // Convert list to a map with index
          .entries
          .where((entry) =>
              entry.value != null &&
              entry.value is Map<String,
                  dynamic>) // Filtering out null or non-map values
          .map((entry) =>
              Question.fromMap(entry.value as Map<String, dynamic>, entry.key))
          .toList(),
      quizDetails: QuizDetails.fromMap(map['quizDetails']),
      players: (map['players'] as Map<String, dynamic>?)
              ?.entries
              .where((entry) =>
                  entry.value != null && entry.value is Map<String, dynamic>)
              .map((entry) =>
                  Player.fromMap(entry.value as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Question {
  final String correctOptionIndex;
  final List<String> options;
  final int questionID;
  final String questionText;

  Question({
    required this.correctOptionIndex,
    required this.options,
    required this.questionID,
    required this.questionText,
  });

  @override
  String toString() {
    return 'Question(questionID: $questionID, questionText: $questionText, correctOptionIndex: $correctOptionIndex, options: $options)';
  }

  factory Question.fromMap(Map<String, dynamic> map, int index) {
    return Question(
      correctOptionIndex: map['correctOptionIndex'].toString(),
      options: List<String>.from(map['options'] ?? []),
      questionID: index,
      questionText: map['question'] ??
          '', // Getting the question text from 'question' property
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
  @override
  String toString() {
    return 'QuizDetails(nameOfQuiz: $nameOfQuiz, numOfQuestions: $numOfQuestions, timeToAnswerPerQuestion: $timeToAnswerPerQuestion)';
  }

  factory QuizDetails.fromMap(Map<String, dynamic> map) {
    return QuizDetails(
      nameOfQuiz: map['nameOfQuiz'] ?? '',
      numOfQuestions: map['numOfQuestions'] ?? '',
      timeToAnswerPerQuestion: map['timeToAnswerPerQuestion'] ?? '',
    );
  }
}

class Player {
  final String username;
  final List<Answer> answers;
  final int learn;
  final int rate;
  final int score;

  Player({
    required this.username,
    required this.answers,
    required this.learn,
    required this.rate,
    required this.score,
  });
  @override
  String toString() {
    return 'Player(username: $username, answers: $answers, learn: $learn, rate: $rate, score: $score)';
  }

  int getScore() {
    return score;
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      username: map['username'] ?? '',
      answers: (map['answers'] as List?)
              ?.asMap()
              .entries
              .where((entry) =>
                  entry.value != null && entry.value is Map<String, dynamic>)
              .map((entry) => Answer.fromMap(
                  entry.key, entry.value as Map<String, dynamic>))
              .toList() ??
          [],
      learn: map['learn'] ?? 0,
      rate: map['rate'] ?? 0,
      score: map['score'] ?? 0,
    );
  }
}

class Answer {
  final int answer;
  final int diffTime;
  final int questionID;

  Answer({
    required this.answer,
    required this.diffTime,
    required this.questionID,
  });

  @override
  String toString() {
    return 'Answer(answer: $answer, diffTime: $diffTime, questionID: $questionID)';
  }

  factory Answer.fromMap(int questionID, Map<String, dynamic> map) {
    // Note the additional parameter here
    return Answer(
      answer: map['answer'] ?? 0,
      diffTime: map['diffTime'] ?? 0,
      questionID: questionID,
    );
  }
}

final Quiz quiz_temp = Quiz(
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
