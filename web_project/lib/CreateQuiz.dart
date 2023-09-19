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
        fontFamily: 'Roboto', // Set the default font
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

  // Store the selected option
  static int selectedOptionIndex = 0;
  static final List<String> options = ['20', '25', '30', '60'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz Creator',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Routemaster.of(context).push('/');
          },
          tooltip: 'Go to Home',
        ),
      ),
      body: Center(
        child: Container(
          width: 400, // Adjust the width as needed
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              TextField(
                controller: nameOfQuizController,
                decoration: InputDecoration(
                  labelText: 'Name of the quiz:',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: numOfQuestionsController,
                decoration: InputDecoration(
                  labelText: 'Number of questions:',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select an option:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Row(
                children: [
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
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  generatedPin = generateRandomPin();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizCreatorPage()),
                  );
                },
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => introPage()),
                  );
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
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
  //TextEditingController correctOptionIndexController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController answer1Controller = TextEditingController();
  TextEditingController answer2Controller = TextEditingController();
  TextEditingController answer3Controller = TextEditingController();
  TextEditingController answer4Controller = TextEditingController();
  int numOfQuestions = 0;
  List<Map<String, dynamic>> quizQuestions = [];
  List<Map<String, dynamic>> quizData = [];
  final List<int> correctAnswerOptions = [1, 2, 3, 4];

  // Variable to store the selected correct answer number
  int selectedCorrectAnswer = 1;
  void submitQuizData() {
    _databaseRef
        .child('Robophone/5669122872442880/quizzes/$generatedPin/quizID')
        .update({
      'quizID': generatedPin,
    });
    for (int i = 0; i < quizQuestions.length; i++) {
      final questionData = quizQuestions[i];
      int questionNum = i + 1;
      _databaseRef
          .child(
              'Robophone/5669122872442880/quizzes/$generatedPin/questions/$questionNum')
          .update(questionData);
    }

    // Update quiz details in the database
    _databaseRef
        .child('Robophone/5669122872442880/quizzes/$generatedPin/quizDetails')
        .update(quizData[0]); // Assuming there's only one set of quiz details
    setState(() {
      numOfQuestions = quizQuestions.length;
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
    _databaseRef
        .child('Robophone/5669122872442880/quizzes/${generatedPin}')
        .update(updateData);
    quizQuestions.clear();
  }

  void addQuizData() {
    String timeToAnswerPerQuestion = _NumOfQuestionPageState
        .options[_NumOfQuestionPageState.selectedOptionIndex]
        .toString();
    String nameOfQuiz = _NumOfQuestionPageState.nameOfQuizController.text;
    String numOfQuestions =
        _NumOfQuestionPageState.numOfQuestionsController.text;
    // String correctOptionIndex =
    // correctAnswerOptions[selectedCorrectAnswer].toString();
    String correctOptionIndex = selectedCorrectAnswer.toString();
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
      body: Center(
        child: Container(
          width: 400, // Adjust the width as needed
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              TextField(
                controller: questionController,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: answer1Controller,
                decoration: const InputDecoration(
                  labelText: 'Answer 1',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: answer2Controller,
                decoration: const InputDecoration(
                  labelText: 'Answer 2',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: answer3Controller,
                decoration: const InputDecoration(
                  labelText: 'Answer 3',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: answer4Controller,
                decoration: const InputDecoration(
                  labelText: 'Answer 4',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select the correct answer option:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              DropdownButton<int>(
                value: selectedCorrectAnswer,
                onChanged: (int? value) {
                  setState(() {
                    selectedCorrectAnswer = value!;
                  });
                },
                items: correctAnswerOptions.map((int option) {
                  return DropdownMenuItem<int>(
                    value: option,
                    child: Text('Answer $option'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (numOfQuestions + 1 <
                  int.parse(
                      _NumOfQuestionPageState.numOfQuestionsController.text))
                ElevatedButton(
                  onPressed: () {
                    print(
                        "number of Questions is :" + numOfQuestions.toString());
                    print("number of question to add " +
                        _NumOfQuestionPageState.numOfQuestionsController.text);
                    if (numOfQuestions <
                        int.parse(_NumOfQuestionPageState
                            .numOfQuestionsController.text)) {
                      setState(() {
                        numOfQuestions++;
                      });
                      addQuizData();
                    } else {
                      showCustomAlert(context, "YOU Cannot ADD more Qeustons");
                    }
                  },
                  child: const Text('Add Question'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    if (numOfQuestions + 1 >=
                        int.parse(_NumOfQuestionPageState
                            .numOfQuestionsController.text)) {
                      setState(() {
                        numOfQuestions++;
                      });
                      addQuizData();
                      submitQuizData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => summaryPage()),
                      );
                    }
                  },
                  child: const Text('Submit'),
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
            ],
          ),
        ),
      ),
    );
  }
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
