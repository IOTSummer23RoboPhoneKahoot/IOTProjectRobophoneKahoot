import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:web_project/widgets/quiz_card.dart';
import 'package:web_project/widgets/EditQuizDetails.dart';

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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0), // Spacing between cards vertically
                      child: Center(
                        // Center the card horizontally
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.4, // 40% width of the screen
                          child: Card(
                            elevation: 5.0, // Add shadow with elevation
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: QuizCard(quiz: quizzes[index]),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Routemaster.of(context).push(
                                              '/game/${quizzes[index].quizID}');
                                        },
                                        child: Text('Show Quiz'),
                                      ),
                                      SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditQuizDetails(
                                                      quiz: quizzes[index]),
                                            ),
                                          );
                                        },
                                        child: Text('Edit Quiz'),
                                      ),
                                      SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Delete the quiz from the database
                                          await deleteQuiz(
                                              quizzes[index].quizID);

                                          // Remove the deleted quiz from the list
                                          setState(() {
                                            quizzes.removeAt(index);
                                          });
                                        },
                                        child: Text('Delete Quiz'),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
