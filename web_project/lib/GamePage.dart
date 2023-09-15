import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/services/firebase_service.dart';
import 'dart:async';
import 'package:web_project/widgets/charts_stats.dart';
import 'package:web_project/widgets/playersjoinWidget.dart';
import 'package:web_project/widgets/endGameScreen.dart';
import 'package:web_project/widgets/numAnswersEachQ.dart';

class GamePage extends StatefulWidget {
  final Quiz quiz;

  GamePage({required this.quiz});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _databaseRef = FirebaseDatabase.instance.ref();
  String _questionText = '';
  List<String> _answers = [];
  int _currentQuestionIndex = -1;
  int _countdownTime = 15;
  Timer? _countdownTimer;
  int _questionDuration = 10;
  Timer? _questionTimer;
  Quiz? quiz = quiz_temp;
  List<Player>? chart1 = [];
  Map<String, int>? chart2 = {};
  String? correctAnswer = '';
  bool is_game_finished = false;
  @override
  void initState() {
    super.initState();

    fetchQuizByID(widget.quiz.quizID.toString()).then((fetchedQuiz) {
      setState(() {
        quiz = fetchedQuiz;
        chart1 = quiz?.getTopPlayers(3);
        _questionDuration =
            int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion) - 1;
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _questionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robophone Kahoot Game'),
      ),
      body: Center(
        child: _currentQuestionIndex == -1
            ? _buildQuizDetails()
            : _buildQuestionView(),
      ),
    );
  }

  ///updated by ruqaya
  Widget _buildQuizDetails() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Align(
            alignment:
                Alignment.topCenter, // Align the Column to the top-middle
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0), // Adjust the left padding as needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.quiz.quizDetails.nameOfQuiz,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                      'Number of Questions: ${widget.quiz.quizDetails.numOfQuestions}'),
                  Text(
                    'Time per Question: ${widget.quiz.quizDetails.timeToAnswerPerQuestion} seconds',
                  ),
                  Text(
                    'QuizPIN: ${widget.quiz.quizID}',
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      // if (quiz?.players?.isNotEmpty == true) {
                      if (true) {
                        // Replace 'yourConditionHere' with the actual condition you want to check
                        _startCountdown();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Alert'),
                              content: Text(
                                  'There are no player'), // Replace with your message
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('Start Game'),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment
                .topCenter, // Align the PlayerListScreen to the top-middle
            child: Container(
              constraints: BoxConstraints(
                  maxHeight: 300.0), // Adjust the maxHeight as needed
              child: PlayerListScreen(quiz: widget.quiz),
            ),
          ),
        ),
      ],
    );
  }

  void showCustomAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _countdownTime > 0
            ? Text('Starting in: $_countdownTime seconds')
            : Column(
                children: [
                  _questionDuration > 0
                      ? Column(
                          children: <Widget>[
                            Text('Time left: $_questionDuration seconds'),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: QuestionAndAnswers(
                                    questionText: _questionText,
                                    answers: _answers,
                                  ),
                                ),
                                Expanded(
                                  child: AnswersEachQuestion(
                                    quiz: widget.quiz,
                                    questionNum: _currentQuestionIndex,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : QuestionStats(
                          quiz: widget.quiz,
                          currentQuestionIndex: _currentQuestionIndex,
                          chartData: chart1,
                          chartData2: chart2,
                          correctAnswer: correctAnswer,
                        )
                ],
              ),
        SizedBox(height: 20.0),
        _questionDuration == 0
            ? ElevatedButton(
                onPressed:
                    is_game_finished == false ? _startCountdown : _endGame,
                child: is_game_finished == false
                    ? Text("Show Next Question")
                    : Text("Show Game Summary"),
              )
            : Container(),
      ],
    );
  }

  void _startCountdown() async {
    setState(() {
      _questionDuration =
          int.parse(widget.quiz.quizDetails.timeToAnswerPerQuestion);
      _currentQuestionIndex += 1;
      _countdownTime = 15;
    });

    await _showNextQuestion();
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownTime > 0) {
          _countdownTime--;
        } else {
          _startQuestionTimer();
          timer.cancel();
        }
      });
      // Update the UI.
    });
  }

  // Future _loadPlayersResults() async {
  //   fetchQuizByID(widget.quiz.quizID.toString()).then((fetchedQuiz) {
  //     setState(() {
  //       chart1 = fetchedQuiz?.getTopPlayers(3);
  //       correctAnswer =
  //           fetchedQuiz?.getCorrectAnswer(_currentQuestionIndex + 1);
  //       // update the questions chart
  //       print('fetched quiz');
  //       print(fetchedQuiz?.getHistogramForQuestion(_currentQuestionIndex + 1));
  //       chart2 =
  //           fetchedQuiz?.getHistogramForQuestion(_currentQuestionIndex + 1);
  //     });
  //   });
  //   // updtae correct answer
  // }

  void _startQuestionTimer() {
    _questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_questionDuration > 0) {
          _questionDuration--;
        } else {
          timer.cancel();
          // fetchQuizByID(widget.quiz.quizID.toString()).then((fetchedQuiz) {
          //   setState(() {
          //     quiz = fetchedQuiz;
          //     chart1 = quiz?.getTopPlayers(3);
          //     print('fetched quiz after teh qutions finishes');
          //     print(fetchedQuiz);
          //     chart2 = quiz?.getHistogramForQuestion(_currentQuestionIndex + 1);
          //   });
          // });
        }
      });
    });
  }

  Future _showNextQuestion() async {
    print('THE CURRENT QUESTION IS' + _currentQuestionIndex.toString());
    print('THE NUMBER OF  QUESTION IS' +
        widget.quiz.quizDetails.numOfQuestions.toString());
    // print(quiz?.getHistogramForQuestion(_currentQuestionIndex));
    if (_currentQuestionIndex <
        int.parse(widget.quiz.quizDetails.numOfQuestions)) {
      _questionText = widget.quiz.questions[_currentQuestionIndex].questionText;
      _answers = widget.quiz.questions[_currentQuestionIndex].options;
    }
    if (_currentQuestionIndex + 1 ==
        int.parse(widget.quiz.quizDetails.numOfQuestions)) {
      // this is the last question so we need to update the flag to go to game summary
      setState(() {
        is_game_finished = true;
      });
    }
    // } else {
    //   print('GOT THE ELSE');
    //   _questionText = "Quiz completed!";
    //   _answers = [];
    //   //TODO: here we got to the end of the quiz so we want to update the state
    //   //to be end of the game and will show the summary widget,
    //   // we could add a flag that give us indication for that.
    // }

    DateTime questionTime = DateTime.now().add(Duration(seconds: 15));
    String nextQuestionTime =
        "${questionTime.hour}:${questionTime.minute}:${questionTime.second}";

    Map<String, dynamic> updateData = {
      "nextHourTime": questionTime.hour,
      "nextMinuteTime": questionTime.minute,
      "nextSecondTime": questionTime.second,
      "nextQuestionTime": nextQuestionTime,
      "currentQuestion": _currentQuestionIndex
    };

    await _databaseRef
        .child('Robophone/quizzes/${widget.quiz.quizID}')
        .update(updateData);
  }

  void _endGame() {
    // Navigate to the HighestScorePage with the quiz object
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EndGameScreen(quiz: widget.quiz),
      ),
    );
  }
}

class QuestionAndAnswers extends StatelessWidget {
  final String questionText;
  final List<String> answers;

  QuestionAndAnswers({required this.questionText, required this.answers});

  @override
  Widget build(BuildContext context) {
    if (questionText.isEmpty) {
      return Text('Waiting for question...');
    }

    return Column(
      children: <Widget>[
        Text(questionText,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.0),
        ...answers
            .map((answer) => Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(answer),
                ))
            .toList(),
      ],
    );
  }
}

class QuestionStats extends StatelessWidget {
  final Quiz quiz;
  final int currentQuestionIndex;
  final List<Player>? chartData;
  final Map<String, int>? chartData2;
  String? correctAnswer = '';
  QuestionStats(
      {required this.quiz,
      required this.currentQuestionIndex,
      required this.chartData,
      required this.chartData2,
      required this.correctAnswer});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Question ${currentQuestionIndex + 1} finished!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.0),
        Text(
          'Quiz ID: ${quiz.quizID}',
          style: TextStyle(fontSize: 18),
        ),
        Text(
          'correct answer is: ${correctAnswer}',
          style: TextStyle(fontSize: 18),
        ),
        // chart for players
        ChartScreen(chartData: chartData),
        // chart for questions
        ChartScreen(chartData: chartData2),
      ],
    );
  }
}
