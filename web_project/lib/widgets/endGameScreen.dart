// import 'package:web_project/widgets/fastestPlayerWidget.dart';
// import 'package:web_project/widgets/correctEachQuestionWidget.dart';
// import 'package:web_project/widgets/topNWinners.dart';
// import 'package:flutter/material.dart';
// import 'package:web_project/models/quiz.dart';

// class EndGameScreen extends StatefulWidget {
//   final Quiz quiz;

//   EndGameScreen({required this.quiz});

//   @override
//   _EndGameScreen createState() => _EndGameScreen();
// }

// class _EndGameScreen extends State<EndGameScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('End Game Screen'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: widget.quiz.players.isEmpty
//               ? [Center(child: Text("There is no data to show"))]
//               : [
//                   FastestPlayerWidget(quiz: widget.quiz),
//                   TopNWinners(quiz: widget.quiz),
//                   SizedBox(height: 5),
//                   CorrectAnswersWidget(quiz: widget.quiz),
//                 ],
//         ),
//       ),
//     );
//   }
// }

import 'package:web_project/widgets/fastestPlayerWidget.dart';
import 'package:web_project/widgets/correctEachQuestionWidget.dart';
import 'package:web_project/widgets/topNWinners.dart';
import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/widgets/feedbackWidget.dart';

class EndGameScreen extends StatefulWidget {
  final Quiz quiz;

  EndGameScreen({required this.quiz});

  @override
  _EndGameScreen createState() => _EndGameScreen();
}

class _EndGameScreen extends State<EndGameScreen> {
  // Function to navigate to the feedback screen
  void _navigateToFeedbackScreen() {
    // Use Navigator to push a new page onto the stack
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FeedbackPage(quiz: widget.quiz), // Use FeedbackScreen widget
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('End Game Screen'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.quiz.players.isEmpty
              ? [Center(child: Text("There is no data to show"))]
              : [
                  // HighestScoreWidget(quiz: widget.quiz),
                  //  SizedBox(height: 10),
                  FastestPlayerWidget(quiz: widget.quiz),
                  TopNWinners(quiz: widget.quiz),
                  SizedBox(height: 5),
                  CorrectAnswersWidget(quiz: widget.quiz),
                  // FastestPlayerWidget(quiz: widget.quiz),
                  // SizedBox(height: 10),
                  // TopNWinners(quiz: widget.quiz),
                  // SizedBox(height: 10),
                  // CorrectAnswersWidget(quiz: widget.quiz),
                  SizedBox(height: 5), // Add some space
                  Center(
                    // Add the "Show Feedback" button here
                    child: ElevatedButton(
                      onPressed: _navigateToFeedbackScreen,
                      child: Text('Show Feedback'),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback Screen'),
      ),
      // Add your feedback content here
      body: Center(
        child: Text('Feedback content goes here'),
      ),
    );
  }
}
