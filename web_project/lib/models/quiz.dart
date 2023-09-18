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

  int getNumOfPlayersAnswered(int questionID, List<Player> players) {
    int count = 0;

    // Iterate over all players
    for (Player player in players) {
      // Check if the player has an answer for the given question
      bool answered = player.answers[questionID].answer > 0;
      //print(answer.questionID);
      if (answered) {
        count++;
      }
    }
    return count;
  }

  List<int> getNumAnsweredOptions(int questionID, List<Player> players) {
    List<int> optionsList = [0, 0, 0, 0];
    // Iterate over all players
    for (Player player in players) {
      // Check if the player has an answer for the given question
      int answered = player.answers[questionID].answer;
      if (answered > 0) optionsList[answered - 1]++;
    }
    return optionsList;
  }

  double getPlayerAverageResponseTime(String username) {
    Player? player = players.firstWhere(
      (p) => p.username == username,
      orElse: () => Player(
        username: '',
        answers: [],
        learn: 0,
        rate: 0,
        score: 0,
      ),
    );
    if (player.answers.isEmpty) {
      return 0.0; // Return 0 if the player has no answers
    }
    int totalResponseTime =
        player.answers.fold(0, (sum, answer) => sum + answer.diffTime);
    return totalResponseTime / player.answers.length;
  }

  List<Player> getTopPlayersByResponseTime(int x) {
    List<Player> sortedPlayers = List.from(players);

    // Sort players by total response time sum (ascending order)
    sortedPlayers.sort((a, b) {
      int totalResponseTimeSumA = a.getTotalResponseTimeSum();
      int totalResponseTimeSumB = b.getTotalResponseTimeSum();
      return totalResponseTimeSumA.compareTo(totalResponseTimeSumB);
    });

    // Return the top X players based on total response time sum
    return sortedPlayers.take(x).toList();
  }

  Map<String, int> getQuestionCorrectAnswerCountMap() {
    Map<String, int> correctAnswerCountMap = {};
    for (Question question in questions) {
      int correctAnswer = getCorrectAnswerIndex(question.questionID);
      int count = 0;
      for (Player player in players) {
        Answer? answerForQuestion = player.answers.firstWhere(
          (a) => a.questionID == question.questionID,
          orElse: () => Answer(answer: -1, diffTime: -1, questionID: -1),
        );
        if (answerForQuestion.answer != -1 &&
            answerForQuestion.answer == correctAnswer) {
          count++;
        }
      }
      correctAnswerCountMap[question.questionText] = count;
    }
    return correctAnswerCountMap;
  }

  List<Player> getTopPlayers(int x) {
    List<Player> sortedPlayers = players.toList();
    sortedPlayers.sort((a, b) => b.getScore().compareTo(a.getScore()));
    return sortedPlayers.take(x).toList();
  }

  String getCorrectAnswer(int questionID) {
    String correctAnswer;
    Question? targetQuestion = questions.firstWhere(
        (q) => q.questionID == questionID,
        orElse: () => Question(
            correctOptionIndex: '-1',
            options: [],
            questionID: -1,
            questionText: "dummey"));
    correctAnswer = targetQuestion
        .options[int.parse(targetQuestion.correctOptionIndex) - 1];

    return correctAnswer;
  }

  List<Question> questionsList() {
    return questions;
  }

  int getCorrectAnswerIndex(int questionID) {
    int correctAnswerIndex;
    Question? targetQuestion = questions.firstWhere(
        (q) => q.questionID == questionID,
        orElse: () => Question(
            correctOptionIndex: '-1',
            options: [],
            questionID: -1,
            questionText: "dummey"));
    correctAnswerIndex = int.parse(targetQuestion.correctOptionIndex) - 1;
    return correctAnswerIndex;
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
    // print('in quiz.dart file the targe quistion is:' + questionID.toString());
    // print(
    // "in quiz.dart file the targe quistion is:" + targetQuestion.toString());

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
      // print('the current player answer is;' + answerForQuestion.toString());
      if (answerForQuestion.answer != -1) {
        // Check against the dummy answer's value
        String answeredOption =
            targetQuestion.options[answerForQuestion.answer];
        histogram[answeredOption] = (histogram[answeredOption] ?? 0) + 1;
      }
    }

    return histogram;
  }

  Map<int, int> getHistogramForQuestion2(int questionID) {
    Map<int, int> histogram = {};

    // Get the target question
    Question? targetQuestion = questions.firstWhere(
        (q) => q.questionID == questionID,
        orElse: () => Question(
            correctOptionIndex: '-1',
            options: [],
            questionID: -1,
            questionText: "dummy")); // This is a dummy question

    // Initialize histogram with 0 for each option index
    for (int i = 0; i < targetQuestion.options.length; i++) {
      histogram[i] = 0;
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
        histogram[answerForQuestion.answer] =
            (histogram[answerForQuestion.answer] ?? 0) + 1;
      }
    }

    return histogram;
  }

  // Map<int, int> getHistogramForQuestion2(int questionID) {
  //   Map<int, int> histogram = {};

  //   // Get the target question
  //   Question? targetQuestion = questions.firstWhere(
  //       (q) => q.questionID == questionID,
  //       orElse: () => Question(
  //           correctOptionIndex: '-1',
  //           options: [],
  //           questionID: -1,
  //           questionText: "dummey")); // This is a dummy question
  //   // print('in quiz.dart file the targe quistion is:' + questionID.toString());
  //   // print(
  //   // "in quiz.dart file the targe quistion is:" + targetQuestion.toString());

  //   // Initialize histogram with 0 for each option
  //   for (String option in targetQuestion.options[option]) {
  //     histogram[option] = 0;
  //   }

  //   // Iterate over players' answers and update histogram
  //   for (Player player in players) {
  //     Answer? answerForQuestion = player.answers.firstWhere(
  //         (a) => a.questionID == questionID,
  //         orElse: () => Answer(
  //             answer: -1,
  //             diffTime: -1,
  //             questionID: -1)); // This is a dummy answer
  //     // print('the current player answer is;' + answerForQuestion.toString());
  //     if (answerForQuestion.answer != -1) {
  //       // Check against the dummy answer's value
  //       int optionNum = answerForQuestion.answer;
  //       String answeredOption =
  //           targetQuestion.options[answerForQuestion.answer];
  //       histogram[answeredOption] = (histogram[answeredOption] ?? 0) + 1;
  //       //histogram[optionNum] = (histogram[optionNum] ?? 0) + 1;
  //     }
  //   }

  //   return histogram;
  // }

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
  final double score;

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

  double getScore() {
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
  int getTotalResponseTimeSum() {
    if (answers.isEmpty) {
      return 0; // Return 0 if the player has no answers
    }

    int totalResponseTime =
        answers.fold(0, (sum, answer) => sum + answer.diffTime);

    return totalResponseTime;
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
