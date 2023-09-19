import 'package:flutter/material.dart';
import 'CreateQuiz.dart';
import 'IntroPage.dart';

class summaryPage extends StatefulWidget {
  bool editPage;
  summaryPage({required this.editPage});
  @override
  _summaryPageState createState() => _summaryPageState();
}

class _summaryPageState extends State<summaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Robophone Kahoot Game'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateQuizApp()),
              );
            },
            child: const Text('Create Quiz'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle, // Use a success icon (you can customize it)
              color: Colors.green, // Use a success color
              size: 100.0, // Adjust the size as needed
            ),
            const SizedBox(
                height: 20.0), // Add some space between the icon and text
            if (widget.editPage)
              const Text(
                'Congratulations, you have successfully edited your quiz!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'Congratulations, you have successfully created your quiz!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => introPage()),
                );
              },
              child: Text('Finish'),
            ),
            SizedBox(
                height:
                    10.0), // Add some space between the button and other elements
          ],
        ),
      ),
    );
  }
}
