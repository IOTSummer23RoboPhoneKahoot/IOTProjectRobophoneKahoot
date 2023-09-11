import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Question {
  final String questionText;
  final String correctAnswer;

  Question(this.questionText, this.correctAnswer);
}

class Player {
  final String name;
  final List<String> answers;

  Player(this.name, this.answers);
}

class CorrectAnswersWidget extends StatelessWidget {
  final List<Question> questions = [
    Question('Question 1', 'Answer 1'),
    Question('Question 2', 'Answer 3'),
    Question('Question 3', 'Answer 1'),
  ];

  final List<Player> players = [
    Player('Player 1', ['Answer 1', 'Answer 2', 'Answer 1']),
    Player('Player 2', ['Answer 1', 'Answer 3', 'Answer 2']),
    Player('Player 3', ['Answer 1', 'Answer 3', 'Answer 3']),
    Player('Player 4', ['Answer 2', 'Answer 3', 'Answer 1']),
  ];

  List<ChartData> computeCorrectAnswers() {
    final List<ChartData> correctAnswersCount = List.generate(
      questions.length,
      (index) {
        final correctAnswer = questions[index].correctAnswer;
        int count = 0;

        for (final player in players) {
          final playerAnswer = player.answers[index];

          if (playerAnswer == correctAnswer) {
            count++;
          }
        }

        return ChartData('Question ${index + 1}', count, Colors.blue);
      },
    );

    return correctAnswersCount;
  }

  @override
  Widget build(BuildContext context) {
    final correctAnswersCount = computeCorrectAnswers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Correct Answers Count'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Correct Answers Count for Each Question:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries>[
                  ColumnSeries<ChartData, String>(
                    dataSource: correctAnswersCount,
                    xValueMapper: (ChartData ch, _) => ch.x,
                    yValueMapper: (ChartData ch, _) => ch.y1,
                    pointColorMapper: (ChartData ch, _) => ch.color,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final int y1;
  final Color color;

  ChartData(this.x, this.y1, this.color);
}


// import 'package:flutter/material.dart';

// class Question {
//   final String questionText;
//   final String correctAnswer;

//   Question(this.questionText, this.correctAnswer);
// }

// class Player {
//   final String name;
//   final List<String> answers;

//   Player(this.name, this.answers);
// }

// class CorrectAnswersWidget extends StatelessWidget {
//   final List<Question> questions = [
//     Question('Question 1', 'Answer 1'),
//     Question('Question 2', 'Answer 3'),
//     Question('Question 3', 'Answer 1'),
//   ];

//   final List<Player> players = [
//     Player('Player 1', ['Answer 1', 'Answer 2', 'Answer 1']),
//     Player('Player 2', ['Answer 1', 'Answer 3', 'Answer 2']),
//     Player('Player 3', ['Answer 1', 'Answer 3', 'Answer 3']),
//     Player('Player 4', ['Answer 2', 'Answer 3', 'Answer 1']),
//   ];

//   List<int> computeCorrectAnswers() {
//     final List<int> correctAnswersCount = List.filled(questions.length, 0);

//     for (int i = 0; i < questions.length; i++) {
//       final correctAnswer = questions[i].correctAnswer;

//       for (final player in players) {
//         final playerAnswers = player.answers;

//         if (playerAnswers[i] == correctAnswer) {
//           correctAnswersCount[i]++;
//         }
//       }
//     }

//     return correctAnswersCount;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final correctAnswersCount = computeCorrectAnswers();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Correct Answers Count'),
//       ),
//       body: ListView.builder(
//         itemCount: questions.length,
//         itemBuilder: (context, index) {
//           final question = questions[index];
//           final count = correctAnswersCount[index];

//           return Card(
//             elevation: 4.0,
//             margin: EdgeInsets.all(16.0),
//             child: Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   Text(
//                     'Question ${index + 1}',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8.0),
//                   Text(
//                     'Correct Answers: $count',
//                     style: TextStyle(fontSize: 24),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
