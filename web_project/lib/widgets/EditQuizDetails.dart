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
  String numOfQuestions = '0';
  int selectedOptionIndex = 0;
  final List<String> options = ['20', '25', '30', '60'];
  Quiz? new_quiz = quiz_temp;
  @override
  void initState() {
    super.initState();

    setState(() {
      if (widget.quiz != null) {
        print("im hehehehehehe222");
        nameOfQuiz = widget.quiz!.quizDetails.nameOfQuiz;
        print(nameOfQuiz);
        numOfQuestions = widget.quiz!.quizDetails.numOfQuestions;
        print(numOfQuestions);
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Name:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: TextEditingController(text: nameOfQuiz),
              onChanged: (text) {
                setState(() {
                  nameOfQuiz = text;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Number of Questions:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: TextEditingController(text: numOfQuestions),
              onChanged: (text) {
                setState(() {
                  numOfQuestions = text;
                });
              },
            ),
            SizedBox(height: 20.0),
            Text(
              'Time to Answer Per Question:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            SizedBox(height: 40.0),
            Column(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      submitQuizData();
                    },
                    child: Text('Save Changes '),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditQuiz(quiz: widget.quiz),
                        ),
                      );
                    },
                    child: Text('Edit Questions'),
                  ),
                ),
                Center(
                  child: ElevatedButton(
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
                ),
              ],
            )
          ],
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
        .update(quizDetailsData);
    if (numOfQuestions != widget.quiz.quizDetails.numOfQuestions) {
      fetchQuizByID(widget.quiz.quizID).then((fetchedQuizzes) {
        setState(() {
          new_quiz = fetchedQuizzes;
        });
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditQuiz(
            quiz: new_quiz,
          ),
        ),
      );
    }
  }
}
