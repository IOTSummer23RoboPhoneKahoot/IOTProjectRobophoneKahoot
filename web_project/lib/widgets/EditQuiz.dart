import 'package:flutter/material.dart';
import 'package:web_project/SummaryQuizPage.dart';
import 'package:web_project/models/quiz.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/widgets/EditQuizDetails.dart';
import '../SummaryQuizPage.dart';
import '../IntroPage.dart';

class EditQuiz extends StatefulWidget {
  Quiz quiz; // Pass the original quiz
  int numberOfQuestionsToEdit; // Number of questions to edit (including extra questions)

  EditQuiz({required this.quiz, required this.numberOfQuestionsToEdit});

  @override
  _EditQuizState createState() => _EditQuizState();
}

class _EditQuizState extends State<EditQuiz> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  List<Question> quizQuestions = [];
  int currentQuestionIndex = 0; // Index of the currently displayed question
  List<String> options = [];
  bool allQuestionsFilled = true;

  String questionText = ''; // Initialize with an empty string
  String correctOptionIndex = '0'; // Initialize with '0'

  @override
  void initState() {
    super.initState();

    // Initialize quiz questions based on the original quiz
    quizQuestions = List.from(widget.quiz.questions ?? []);
    int i = quizQuestions.length;
    // Ensure we have at least the required number of questions to edit
    while (i < widget.numberOfQuestionsToEdit) {
      quizQuestions.add(Question(
          questionText: 'New Question',
          options: ['Option A', 'Option B', 'Option C', 'Option D'],
          correctOptionIndex: '0',
          questionID: quizQuestions.length + 1));
      i++;
    }

    // Load the first question
    loadQuestionData(currentQuestionIndex);
  }

  // Function to load question data based on the current index
  void loadQuestionData(int questionIndex) {
    if (questionIndex >= 0 && questionIndex < quizQuestions.length) {
      final questionData = quizQuestions[questionIndex];
      setState(() {
        options = questionData.options;
        questionText = questionData.questionText; // Update question text
        correctOptionIndex =
            questionData.correctOptionIndex; // Update correct option index
      });
    }
  }

  // Function to update the current question with edited data
  void updateCurrentQuestion() {
    final questionData = quizQuestions[currentQuestionIndex];
    questionData.questionText = questionText;
    questionData.correctOptionIndex = correctOptionIndex;
    questionData.options = List.from(options);
    // setState(() {
    //   allQuestionsFilled = isAllQuestionsFilled();
    // });
  }

  // Function to check if all questions are filled
  // bool isAllQuestionsFilled() {
  //   for (int i = 0; i < quizQuestions.length; i++) {
  //     final questionData = quizQuestions[i];
  //     if (questionData.questionText.isEmpty ||
  //         questionData.options.any((option) => option.isEmpty)) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }

  // Function to go to the next question
  void goToNextQuestion() {
    if (currentQuestionIndex < widget.numberOfQuestionsToEdit - 1) {
      updateCurrentQuestion();
      setState(() {
        currentQuestionIndex++;
        loadQuestionData(currentQuestionIndex);
      });
    }
  }

  // Function to go to the previous question
  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      updateCurrentQuestion();
      setState(() {
        currentQuestionIndex--;
        loadQuestionData(currentQuestionIndex);
      });
    }
  }

  Widget buildQuestionEditor(int questionIndex) {
    if (questionIndex >= quizQuestions.length) {
      return Text('No questions available at this index');
    }

    final questionData = quizQuestions[questionIndex];
    final int questionNum = questionIndex + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question $questionNum:',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            labelText: 'Question Text',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: questionText),
          textDirection: TextDirection.ltr, // Ensure left-to-right input
          onChanged: (text) {
            // Update the question text in the data
            setState(() {
              questionText = text; // Update question text
            });
          },
        ),
        SizedBox(height: 16.0),
        Text(
          'Correct Option Index:',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            labelText: 'Correct Option Index',
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: correctOptionIndex),
          textDirection: TextDirection.ltr, // Ensure left-to-right input
          onChanged: (text) {
            // Update the correct option index in the data
            setState(() {
              correctOptionIndex = text; // Update correct option index
            });
          },
        ),
        SizedBox(height: 16.0),
        Text(
          'Answer Options:',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        for (int i = 0; i < questionData.options.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Option ${String.fromCharCode(65 + i)}',
                  border: OutlineInputBorder(),
                ),
                controller:
                    TextEditingController(text: questionData.options[i]),
                textDirection: TextDirection.ltr, // Ensure left-to-right input
                onChanged: (text) {
                  setState(() {
                    options[i] = text; // Update the options list
                  });
                },
              ),
              SizedBox(height: 8.0),
            ],
          ),
      ],
    );
  }

  // Function to save all edited questions to the database
  void saveAllQuestions() {
    updateCurrentQuestion();
    if (allQuestionsFilled) {
      for (int i = 0; i < quizQuestions.length; i++) {
        final questionData = quizQuestions[i];
        int questionID = i + 1;
        _databaseRef
            .child(
                'sabaaTest/quizzes/${widget.quiz.quizID}/questions/$questionID')
            .update(questionData.toMap());
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => summaryPage(
            editPage: true,
          ),
        ),
      ); // Assuming toMap() method is defined in Question class
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill all required questions before saving.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Quiz'),
      ),
      body: Center(
        child: Container(
          width: 400, // Adjust the width as needed
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Display the currently selected question for editing
              buildQuestionEditor(currentQuestionIndex),

              // Add spacing between buttons
              SizedBox(height: 16.0),

              // Add navigation buttons with spacing
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

              // Add spacing
              SizedBox(height: 16.0),

              // Add a button to save the edited quiz data
              ElevatedButton(
                onPressed: saveAllQuestions,
                child: Text('Save Questions'),
                // Disable the button if not all required questions are filled
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) {
                      return allQuestionsFilled ? Colors.blue : Colors.grey;
                    },
                  ),
                ),
              ),

              // Add spacing
              SizedBox(height: 8.0),

              // Add a button to cancel and navigate back
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
      ),
    );
  }
}
