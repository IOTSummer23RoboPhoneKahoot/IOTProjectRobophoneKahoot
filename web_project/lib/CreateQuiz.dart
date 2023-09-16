import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'IntroPage.dart';
import 'SummaryQuizPage.dart';
import 'dart:math';

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
  static TextEditingController numOfQuestionsController =
      TextEditingController();
  static TextEditingController nameOfQuizController = TextEditingController();

  // Store the selected time option
  static int selectedTimeOptionIndex = 0, selectedTimeOption = 10;
  final List<int> timeOptions = [
    10,
    20,
    30,
    60
  ]; // Define time options in seconds

  void _handleTimeOptionChanged(int? value) {
    setState(() {
      selectedTimeOptionIndex = value ?? 0;
      selectedTimeOption = timeOptions[selectedTimeOptionIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Creator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: nameOfQuizController,
              decoration: const InputDecoration(labelText: 'Name of the quiz:'),
            ),
            TextField(
              controller: numOfQuestionsController,
              decoration:
                  const InputDecoration(labelText: 'Number of questions:'),
            ),
            const Text('Time to answer:'),
            for (int i = 0; i < timeOptions.length; i++)
              ListTile(
                title: Text('${timeOptions[i]} seconds'),
                leading: Radio<int>(
                  value: i,
                  groupValue: selectedTimeOptionIndex,
                  onChanged: _handleTimeOptionChanged,
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                generatedPin = generateRandomPin();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizCreatorPage()),
                );
              },
              child: const Text('Continue'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => introPage()),
                );
              },
              child: const Text('Cancel'),
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
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  TextEditingController correctOptionIndexController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController answer3Controller = TextEditingController();
  TextEditingController answer4Controller = TextEditingController();
  int numOfQuestions = 0;
  List<Map<String, dynamic>> quizQuestions = [];
  List<Map<String, dynamic>> quizData = [];

  void submitQuizData() {
    _databaseRef.child('sabaaTest/quizzes/$generatedPin/quizID').update({
      'quizID': generatedPin,
    });
    for (int i = 0; i < quizQuestions.length; i++) {
      final questionData = quizQuestions[i];
      _databaseRef
          .child('sabaaTest/quizzes/$generatedPin/questions/$i')
          .update(questionData);
    }

    // Update quiz details in the database
    _databaseRef
        .child('sabaaTest/quizzes/$generatedPin/quizDetails')
        .update(quizData[0]); // Assuming there's only one set of quiz details
    setState(() {
      numOfQuestions = quizQuestions.length;
    });
    quizQuestions.clear();
  }

  void addQuizData() {
    String timeToAnswerPerQuestion =
        _NumOfQuestionPageState.selectedTimeOption.toString();
    String nameOfQuiz = _NumOfQuestionPageState.nameOfQuizController.text;
    String numOfQuestions =
        _NumOfQuestionPageState.numOfQuestionsController.text;
    String correctOptionIndex = correctOptionIndexController.text;
    String question = questionController.text;
    String answer1 = answer1Controller.text;
    String answer2 = answer2Controller.text;
    String answer3 = answer3Controller.text;
    String answer4 = answer4Controller.text;
    Map<String, dynamic> questionData = {
      'question': question,
      'correctOptionIndex': correctOptionIndex,
      'options': [answer1, answer2, answer3, answer4],
    };
    Map<String, dynamic> quizDetailsData = {
      'nameOfQuiz': nameOfQuiz,
      'timeToAnswerPerQuestion': timeToAnswerPerQuestion,
      'numOfQuestions': numOfQuestions,
    };
    // Add the question to the list
    quizQuestions.add(questionData);
    quizData.add(quizDetailsData);
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
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answer1Controller,
              decoration: const InputDecoration(labelText: 'Answer 1'),
            ),
            TextField(
              controller: answer2Controller,
              decoration: InputDecoration(labelText: 'Answer 2'),
            ),
            TextField(
              controller: answer3Controller,
              decoration: const InputDecoration(labelText: 'Answer 3'),
            ),
            TextField(
              controller: answer4Controller,
              decoration: const InputDecoration(labelText: 'Answer 4'),
            ),
            TextField(
              controller: correctOptionIndexController,
              decoration: const InputDecoration(
                  labelText: 'please write the correct answer number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addQuizData();
              },
              child: Text('add Question'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => introPage()),
                );
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                submitQuizData(); // Call the submitQuizData function when the button is pressed
                if (numOfQuestions >=
                    int.parse(_NumOfQuestionPageState
                        .numOfQuestionsController.text)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => summaryPage()),
                  );
                }
              },
              child: const Text('Submit'),
            )
          ],
        ),
      ),
    );
  }
}
