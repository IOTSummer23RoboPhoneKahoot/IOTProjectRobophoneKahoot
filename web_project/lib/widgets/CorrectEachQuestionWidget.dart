// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:web_project/models/quiz.dart';
// import 'dart:math';

// class CorrectAnswersWidget extends StatefulWidget {
//   final Quiz quiz;
//   CorrectAnswersWidget({required this.quiz});

//   @override
//   _CorrectAnswersWidgetState createState() => _CorrectAnswersWidgetState();
// }

// class ChartData {
//   final String x;
//   final int y1;
//   final Color color;

//   ChartData(this.x, this.y1, this.color);
// }

// class _CorrectAnswersWidgetState extends State<CorrectAnswersWidget> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   List<ChartData> computeAnswers() {
//     final Map<String, int> AnswerCounts =
//         widget.quiz.getQuestionCorrectAnswerCountMap();
//     final List<ChartData> chartData = [];

//     int index = 1;
//     final random = Random(); // Create a random number generator

//     for (var entry in AnswerCounts.entries) {
//       final Color randomColor = Color.fromRGBO(
//         random.nextInt(256), // Red
//         random.nextInt(256), // Green
//         random.nextInt(256), // Blue
//         1.0, // Alpha (opacity)
//       );

//       chartData.add(ChartData('Answer $index', entry.value, randomColor));
//       index++;
//     }

//     return chartData;
//   }

//   List<ChartData> computeCorrectAnswers() {
//     final Map<String, int> correctAnswerCounts =
//         widget.quiz.getQuestionCorrectAnswerCountMap();
//     final List<ChartData> chartData = [];

//     int index = 1;
//     final random = Random(); // Create a random number generator

//     for (var entry in correctAnswerCounts.entries) {
//       final Color randomColor = Color.fromRGBO(
//         random.nextInt(256), // Red
//         random.nextInt(256), // Green
//         random.nextInt(256), // Blue
//         1.0, // Alpha (opacity)
//       );

//       chartData.add(ChartData('Question $index', entry.value, randomColor));
//       index++;
//     }

//     return chartData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final correctAnswersCount = computeCorrectAnswers();

//     return Padding(
//       padding: EdgeInsets.all(8.0), // Add smaller margins to your widget
//       child: FractionallySizedBox(
//         widthFactor: 0.3, // Reduce the width factor to make it smaller
//         child: Card(
//           elevation: 2.0,
//           child: Container(
//             height: 80,
//             constraints:
//                 BoxConstraints(maxWidth: 100), // Reduce the maximum width
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:
//                       EdgeInsets.all(8.0), // Add smaller padding to the text
//                   child: Text(
//                     'Number of Correct Answers Each Question:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   child: SfCartesianChart(
//                     primaryXAxis: CategoryAxis(),
//                     primaryYAxis: NumericAxis(
//                       interval: 1, // Set the interval to 2
//                       majorGridLines:
//                           MajorGridLines(width: 1), // Customize grid lines
//                     ),
//                     series: <ChartSeries>[
//                       ColumnSeries<ChartData, String>(
//                         dataSource: correctAnswersCount,
//                         xValueMapper: (ChartData ch, _) => ch.x,
//                         yValueMapper: (ChartData ch, _) => ch.y1,
//                         pointColorMapper: (ChartData ch, _) => ch.color,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:web_project/models/quiz.dart';
// import 'dart:math';

// class CorrectAnswersWidget extends StatefulWidget {
//   final Quiz quiz;
//   CorrectAnswersWidget({required this.quiz});

//   @override
//   _CorrectAnswersWidgetState createState() => _CorrectAnswersWidgetState();
// }

// class ChartData {
//   final int x; // Change from String to int
//   final int y1;
//   final Color color;

//   ChartData(this.x, this.y1, this.color);
// }

// class _CorrectAnswersWidgetState extends State<CorrectAnswersWidget> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   List<ChartData> computeCorrectAnswers() {
//     final Map<String, int> correctAnswerCounts =
//         widget.quiz.getQuestionCorrectAnswerCountMap();
//     final List<ChartData> chartData = [];

//     int index = 1;
//     final random = Random();

//     for (var entry in correctAnswerCounts.entries) {
//       final Color randomColor = Color.fromRGBO(
//         random.nextInt(256),
//         random.nextInt(256),
//         random.nextInt(256),
//         1.0,
//       );

//       chartData.add(
//           ChartData(index, entry.value, randomColor)); // Use numeric X-value
//       index++;
//     }

//     return chartData;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final correctAnswersCount = computeCorrectAnswers();

//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: FractionallySizedBox(
//         widthFactor: 0.3,
//         child: Card(
//           elevation: 2.0,
//           child: Container(
//             height: 80,
//             constraints: BoxConstraints(maxWidth: 100),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Text(
//                     'Number of Correct Answers Each Question:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   child: SfCartesianChart(
//                     primaryXAxis: NumericAxis(
//                       interval: 1, // Set the interval to 1
//                       majorGridLines:
//                           MajorGridLines(width: 1), // Customize grid lines
//                     ),
//                     primaryYAxis: CategoryAxis(),
//                     series: <ChartSeries>[
//                       BarSeries<ChartData, int>(
//                         dataSource: correctAnswersCount,
//                         xValueMapper: (ChartData ch, _) => ch.x,
//                         yValueMapper: (ChartData ch, _) => ch.y1,
//                         pointColorMapper: (ChartData ch, _) => ch.color,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_project/models/quiz.dart';
import 'dart:math';

class CorrectAnswersWidget extends StatefulWidget {
  final Quiz quiz;
  CorrectAnswersWidget({required this.quiz});

  @override
  _CorrectAnswersWidgetState createState() => _CorrectAnswersWidgetState();
}

class ChartData {
  final int x; // Change from String to int
  final int y1;
  final Color color;

  ChartData(this.x, this.y1, this.color);
}

class _CorrectAnswersWidgetState extends State<CorrectAnswersWidget> {
  @override
  void initState() {
    super.initState();
  }

  List<ChartData> computeCorrectAnswers() {
    final Map<String, int> correctAnswerCounts =
        widget.quiz.getQuestionCorrectAnswerCountMap();
    final List<ChartData> chartData = [];

    int index = 1;
    final random = Random();

    for (var entry in correctAnswerCounts.entries) {
      final Color randomColor = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
      );

      chartData.add(
          ChartData(index, entry.value, randomColor)); // Use numeric X-value
      index++;
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    final correctAnswersCount = computeCorrectAnswers();

    return Container(
      // Set a fixed height for the container
      height: 400, // Adjust the height as needed
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: FractionallySizedBox(
          widthFactor: 0.3,
          child: Card(
            elevation: 2.0,
            child: Container(
              height: 80,
              constraints: BoxConstraints(maxWidth: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Number of Correct Answers Each Question:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: SfCartesianChart(
                      primaryXAxis: NumericAxis(
                        interval: 1, // Set the interval to 1
                        majorGridLines:
                            MajorGridLines(width: 1), // Customize grid lines
                      ),
                      primaryYAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        BarSeries<ChartData, int>(
                          dataSource: correctAnswersCount,
                          xValueMapper: (ChartData ch, _) => ch.x,
                          yValueMapper: (ChartData ch, _) => ch.y1,
                          pointColorMapper: (ChartData ch, _) => ch.color,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
