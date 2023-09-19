import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:web_project/widgets/EditQuiz.dart';
import '../IntroPage.dart';
import 'package:web_project/models/quiz.dart';

class EditQuizDetails extends StatefulWidget {
  Quiz quiz;

  EditQuizDetails({required this.quiz});

  @override
  _EditQuizDetailsState createState() => _EditQuizDetailsState();
}

class _EditQuizDetailsState extends State<EditQuizDetails> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  String nameOfQuiz = 'Quiz Name';
  String quiz_id = '1';
  String numOfQuestions = '0';
  int selectedOptionIndex = 0;
  final List<String> options = ['20', '25', '30', '60'];
  Quiz? new_quiz = quiz_temp;

  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.quiz != null) {
        nameOfQuiz = widget.quiz!.quizDetails.nameOfQuiz;
        numOfQuestions = widget.quiz!.quizDetails.numOfQuestions;
        quiz_id = widget.quiz.quizID;
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz Details'),
      ),
      body: Center(
        child: Container(
          width: 400, // Adjust the width as needed
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quiz Name',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: nameOfQuiz),
                onChanged: (text) {
                  setState(() {
                    nameOfQuiz = text;
                  });
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Number of Questions',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: numOfQuestions),
                onChanged: (text) {
                  setState(() {
                    numOfQuestions = text;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Time to Answer Per Question:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              DropdownButton<int>(
                value: selectedOptionIndex,
                onChanged: (int? value) {
                  setState(() {
                    selectedOptionIndex = value!;
                  });
                },
                items: options.asMap().entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value + ' seconds'),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.0),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      submitQuizData();
                    },
                    child: Text('Save Changes'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditQuiz(
                            quiz: widget.quiz,
                            numberOfQuestionsToEdit: int.parse(numOfQuestions),
                          ),
                        ),
                      );
                    },
                    child: Text('Edit Questions'),
                  ),
                  SizedBox(height: 16.0),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void submitQuizData() {
    Map<String, dynamic> quizDetailsData = {
      'nameOfQuiz': nameOfQuiz,
      'timeToAnswerPerQuestion': options[selectedOptionIndex],
      'numOfQuestions': numOfQuestions,
    };

    _databaseRef
        .child('sabaaTest/quizzes/${widget.quiz.quizID}/quizDetails')
        .update(quizDetailsData)
        .then((_) {
      if (numOfQuestions != widget.quiz.quizDetails.numOfQuestions) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditQuiz(
              quiz: widget.quiz,
              numberOfQuestionsToEdit: int.parse(numOfQuestions),
            ),
          ),
        );
      }
    });
  }
}
