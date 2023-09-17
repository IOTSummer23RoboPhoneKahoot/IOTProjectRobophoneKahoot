import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
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
    return Flex(
      direction: Axis.vertical,
      children: [
        AppBar(
          title: Text('Robophone Kahoot Game'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Routemaster.of(context).push('/createQuiz');
              },
              child: Text('Create Quiz'),
            ),
          ],
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        QuizCard(quiz: quizzes[index]),
                        ElevatedButton(
                          onPressed: () {
                            Routemaster.of(context)
                                .push('/game/${quizzes[index].quizID}');
                          },
                          child: Text('Start Game'),
                        ),
                        SizedBox(height: 10.0), // Add some space between cards
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
