import 'package:flutter/material.dart';
import 'CreateQuiz.dart';
import 'GamePage.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:web_project/widgets/quiz_card.dart';

class introPage extends StatefulWidget {
  @override
  _introPageState createState() => _introPageState();
}

class _introPageState extends State<introPage> {
  List<Quiz> quizzes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchQuizzes().then((fetchedQuizzes) {
      setState(() {
        quizzes = fetchedQuizzes;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robophone Kahoot Game'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateQuizApp()),
              );
            },
            child: Text('Create Quiz'),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    QuizCard(quiz: quizzes[index]),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GamePage(quiz: quizzes[index]),
                          ),
                        );
                      },
                      child: Text('Start Game'),
                    ),
                    SizedBox(height: 10.0), // Add some space between cards
                  ],
                );
              },
            ),
    );
  }
}
