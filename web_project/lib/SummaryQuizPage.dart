import 'package:flutter/material.dart';
import 'CreateQuiz.dart';
import 'IntroPage.dart';

class summaryPage extends StatefulWidget {
  @override
  _summaryPageState createState() => _summaryPageState();
}

class _summaryPageState extends State<summaryPage> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Admin,you created your Quiz succesfully!'),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => introPage()),
                );
              },
              child: Text('finish'),
            ),
            SizedBox(height: 10.0), // Add some space between cards
          ],
        ),
      ),
    );
  }
}
