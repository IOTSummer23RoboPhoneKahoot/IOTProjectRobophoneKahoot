import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'main.dart';

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
     final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  static TextEditingController numOfQuestionsController = TextEditingController();

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
              controller: numOfQuestionsController,
              decoration: InputDecoration(labelText: 'number of questions:'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
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

     List<Map<String, dynamic>> quizDataList = [];
        void addQuizData() {
        String numOfQuestions=_NumOfQuestionPageState.numOfQuestionsController.text;
        String correctOptionIndex=correctOptionIndexController.text;
        String question = questionController.text;
        String answer1 = answer1Controller.text;
        String answer2 = answer2Controller.text;
        String answer3 = answer3Controller.text;
        String answer4 = answer4Controller.text;

        // Add the question and answer to the list
        quizDataList.add({
        'question': question,
         'numOfQuestions': numOfQuestions,
        'correctOptionIndex':correctOptionIndex,
        'options': [answer1, answer2, answer3, answer4],
        });

        // Clear the text fields
          
        correctOptionIndexController.clear();
        questionController.clear();
        answer1Controller.clear();
        answer2Controller.clear();
        answer3Controller.clear();
        answer4Controller.clear();
  }
  void saveQuizData() {
   
    _databaseRef.child('Robophone/questions/test').push().set(quizDataList);

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
              decoration: InputDecoration(labelText: 'please write the correct answer number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addQuizData();
              },
              child: Text('add Question'),
            ),
            SizedBox(height: 20),
             ElevatedButton(
              onPressed: () {
                saveQuizData();
              },
              child: Text('save Questions'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => introPage()),
                );
              },
              child: Text('back to intro page'),
            )
          ],
        ),
      ),
    );
  }
}
