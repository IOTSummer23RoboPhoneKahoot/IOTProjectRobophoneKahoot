
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'CreateQuiz.dart';
import 'GamePage.dart';

class introPage extends StatefulWidget {
  @override
  _introPageState createState() => _introPageState();
}
class _introPageState extends State<introPage> {
  final _databaseRef = FirebaseDatabase.instance.ref();
  String dataFromFirebase = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Robophone Kahoot Game'),
        actions: [
         ElevatedButton( // Change RaisedButton to ElevatedButton
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
    child: KahootWidget(),
    
    ),
    );
  }
  
}
class KahootWidget extends StatefulWidget {
  @override
  _KahootWidgetState createState() => _KahootWidgetState();
}

class _KahootWidgetState extends State<KahootWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Kahoot',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 40), // Add some spacing below the text
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage()),
                    );
              },
              child: Text('Start Game'),
            ),
            SizedBox(width: 20), // Add spacing between buttons
          ],
        ),
      ],
    );
  }
}