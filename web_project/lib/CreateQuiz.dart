import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/services/firebase_service.dart';
import 'IntroPage.dart';
import 'SummaryQuizPage.dart';
import 'dart:math';

Future<String?> generatePin() async {
  String? pin;

  // Generate a random 4-digit PIN
  await fetchPin().then((fetchedPin) {
    print('Pin fetched: $fetchedPin');
    pin = fetchedPin;
  });

  return pin;
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
  String? pin;
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
                generatePin().then((generatedPin) {
                  setState(() {
                    pin = generatedPin;
                    print('pin: $pin');
                    if (pin != null) {
                      pin = (int.parse(pin!) + 1).toString();
                      print('pin: $pin');
                    }
                  });
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuizCreatorPage(pin: pin)),
                );
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizCreatorPage extends StatefulWidget {
  String? pin;
  QuizCreatorPage({this.pin});
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
  String? pin;
  void initState() {
    super.initState();

    setState(() {
      pin = widget.pin;
    });
  }

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
    _databaseRef
        .child('sabaaTest/quizzes/' + pin.toString() + '/quizID')
        .update({
      'quizID': pin.toString(),
    });
    _databaseRef
        .child('sabaaTest/quizzes/' +
            pin.toString() +
            '/questions/' +
            numOfQuestionsAdded.toString())
        .update({
      'question': question,
      'correctOptionIndex': correctOptionIndex,
      'options': [answer1, answer2, answer3, answer4],
    });
    _databaseRef
        .child('sabaaTest/quizzes/' + pin.toString() + '/quizDetails')
        .update({
      'nameOfQuiz': nameOfQuiz,
      'timeToAnswerPerQuestion': timeToAnswerPerQuestion,
      'numOfQuestions': numOfQuestions,
    });
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
