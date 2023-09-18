import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/widgets/EditQuizDetails.dart';
import '../IntroPage.dart';

class EditQuiz extends StatefulWidget {
  Quiz? quiz;
  EditQuiz({required this.quiz});
  @override
  _EditQuizState createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  Quiz? quiz = quiz_temp;
  List<Question>? quizQuestions = [];
  QuizDetails? quizData;
  int currentQuestionIndex = 0; // Index of the currently displayed question
  String questionText = 'question';
  String correctOptionIndex = '0';
  List<String> options = [];
  String numOfQuestions = '0';
  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.quiz != null) {
        quiz = widget.quiz;
        quizQuestions = widget.quiz!.questions;
        quizData = widget.quiz!.quizDetails;
      }
    });
  }

  // Function to build a widget for editing a single question
  Widget buildQuestionEditor(int questionIndex) {
    final questionData = quizQuestions![questionIndex];
    final int questionNum = questionIndex + 1;
    setState(() {
      options = questionData.options;
      correctOptionIndex = questionData.correctOptionIndex;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Question $questionNum:'),
        TextField(
          controller: TextEditingController(text: questionData.questionText),
          onChanged: (text) {
            // Update the question text in the data
            setState(() {
              questionText = text;
            });
          },
        ),
        Text('correct option index:'),
        TextField(
          controller: TextEditingController(text: correctOptionIndex),
          onChanged: (text) {
            // Update the question text in the data
            setState(() {
              correctOptionIndex = text;
            });
          },
        ),
        for (int i = 0; i < questionData.options.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Answer option ${i + 1}:'),
              TextField(
                controller:
                    TextEditingController(text: questionData.options[i]),
                onChanged: (text) {
                  setState(() {
                    options[i] = text; // Update the options list
                  });
                },
              ),
            ],
          ),
      ],
    );
  }

  void submitQuestionData() {
    Map<String, dynamic> questionData = {
      'question': questionText,
      'correctOptionIndex': correctOptionIndex,
      'options': options,
    };

    _databaseRef
        .child(
            'sabaaTest/quizzes/${quiz!.quizID}/questions/$currentQuestionIndex')
        .update(questionData);
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < quizQuestions!.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Implement the UI for editing quiz data here
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the currently selected question for editing
            buildQuestionEditor(currentQuestionIndex),

            // Add navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: goToPreviousQuestion,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: goToNextQuestion,
                  child: Text('Next'),
                ),
              ],
            ),

            // Add a button to save the edited quiz data
            ElevatedButton(
              onPressed: () {
                submitQuestionData();
                // Implement the logic to save edited data to Firebase
              },
              child: Text('Save Changes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => introPage(),
                  ),
                );
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
