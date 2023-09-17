import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'IntroPage.dart';
import 'SummaryQuizPage.dart';
import 'dart:math';
import 'package:routemaster/routemaster.dart';

String generatedPin = '0000';
String generateRandomPin() {
  // Generate a random 4-digit PIN
  final Random random = Random();
  final int min = 1000;
  final int max = 9999;
  final int randomNumber = min + random.nextInt(max - min);
  return randomNumber.toString().padLeft(4, '0');
}

class CreateQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NumOfQuestionPage(),
    );
  }
}

class NumOfQuestionPage extends StatefulWidget {
  @override
  _NumOfQuestionPageState createState() => _NumOfQuestionPageState();
}

class _NumOfQuestionPageState extends State<NumOfQuestionPage> {
  // final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  static TextEditingController numOfQuestionsController =
      TextEditingController();
  static TextEditingController timeToAnswerPerQuestionController =
      TextEditingController();
  static TextEditingController nameOfQuizController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Creator'),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Routemaster.of(context).push('/');
          },
          tooltip: 'Go to Home',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: nameOfQuizController,
              decoration: InputDecoration(labelText: 'Name of the quiz:'),
            ),
            TextField(
              controller: numOfQuestionsController,
              decoration: InputDecoration(labelText: 'Number of questions:'),
            ),
            TextField(
              controller: timeToAnswerPerQuestionController,
              decoration: InputDecoration(labelText: 'Time to answer:'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                generatedPin = generateRandomPin();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizCreatorPage()),
                );
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
    // numOfQuestionsController.clear();
    // timeToAnswerPerQuestionController.clear();
    // nameOfQuizController.clear();
  }
}

class QuizCreatorPage extends StatefulWidget {
  @override
  _QuizCreatorPageState createState() => _QuizCreatorPageState();
}

class _QuizCreatorPageState extends State<QuizCreatorPage> {
  int numOfQuestionsAdded = 0;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  TextEditingController correctOptionIndexController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController answer3Controller = TextEditingController();
  TextEditingController answer4Controller = TextEditingController();

  List<Map<String, dynamic>> quizDataList = [];
  void addQuizData() {
    // TODO: add the name of the quiz
    String timeToAnswerPerQuestion =
        _NumOfQuestionPageState.timeToAnswerPerQuestionController.text;
    String nameOfQuiz = _NumOfQuestionPageState.nameOfQuizController.text;
    String numOfQuestions =
        _NumOfQuestionPageState.numOfQuestionsController.text;
    String correctOptionIndex = correctOptionIndexController.text;
    String question = questionController.text;
    String answer1 = answer1Controller.text;
    String answer2 = answer2Controller.text;
    String answer3 = answer3Controller.text;
    String answer4 = answer4Controller.text;

    // Add the question and answer to the list
    numOfQuestionsAdded += 1;
    _databaseRef.child('Robophone/quizzes/' + generatedPin + '/quizID').update({
      'quizID': generatedPin,
    });
    _databaseRef
        .child('Robophone/quizzes/' +
            generatedPin +
            '/questions/' +
            numOfQuestionsAdded.toString())
        .update({
      'question': question,
      'correctOptionIndex': correctOptionIndex,
      'options': [answer1, answer2, answer3, answer4],
    });
    _databaseRef
        .child('Robophone/quizzes/' + generatedPin + '/quizDetails')
        .update({
      'nameOfQuiz': nameOfQuiz,
      'timeToAnswerPerQuestion': timeToAnswerPerQuestion,
      'numOfQuestions': numOfQuestions,
    });
    Map<String, dynamic> updateData = {
      "nextHourTime": 0,
      "nextMinuteTime": 0,
      "nextSecondTime": 0,
      "nextQuestionTime": "",
      "currentQuestion": 0
    };
// Mahmoud and Ruqyad : added this to intialize the properties above so we could
// start the game(robophone assumes that before we start the game we already have
// these values in the DB)
    _databaseRef.child('Robophone/quizzes/${generatedPin}').update(updateData);

    // Clear the text fields

    correctOptionIndexController.clear();
    questionController.clear();
    answer1Controller.clear();
    answer2Controller.clear();
    answer3Controller.clear();
    answer4Controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Creator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answer1Controller,
              decoration: InputDecoration(labelText: 'Answer 1'),
            ),
            TextField(
              controller: answer2Controller,
              decoration: InputDecoration(labelText: 'Answer 2'),
            ),
            TextField(
              controller: answer3Controller,
              decoration: InputDecoration(labelText: 'Answer 3'),
            ),
            TextField(
              controller: answer4Controller,
              decoration: InputDecoration(labelText: 'Answer 4'),
            ),
            TextField(
              controller: correctOptionIndexController,
              decoration: InputDecoration(
                  labelText: 'please write the correct answer number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addQuizData();
                if (numOfQuestionsAdded >=
                    int.parse(_NumOfQuestionPageState
                        .numOfQuestionsController.text)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => summaryPage()),
                  );
                }
              },
              child: Text('add Question'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (numOfQuestionsAdded >=
                    int.parse(_NumOfQuestionPageState
                        .numOfQuestionsController.text)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => introPage()),
                  );
                }
              },
              child: Text('back to intro page'),
            )
          ],
        ),
      ),
    );
  }
}
