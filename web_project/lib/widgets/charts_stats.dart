import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_project/GamePage.dart';
import 'package:web_project/models/quiz.dart';

class ChartScreen<T> extends StatefulWidget {
  final List<T>? chartData;

  ChartScreen({required this.chartData});

  @override
  _ChartScreenState createState() => _ChartScreenState<T>();
}

class _ChartScreenState<T> extends State<ChartScreen<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 200,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          if (T == Player && widget.chartData is List<Player>)
            StackedColumnSeries<Player, String>(
              dataSource: (widget.chartData as List<Player>?) ?? [],
              xValueMapper: (Player ch, _) => ch.username,
              yValueMapper: (Player ch, _) => ch.score,
              pointColorMapper: (Player ch, _) => Colors.black,
            )
          else if (T == Question && widget.chartData is List<Question>)
            StackedColumnSeries<Question, String>(
              dataSource: (widget.chartData as List<Question>?) ?? [],
              xValueMapper: (Question Question, _) => Question.questionID
                  .toString(), // Replace with appropriate field
              yValueMapper: (Question Question, _) => int.parse(Question
                  .correctOptionIndex), // Replace with appropriate field
              pointColorMapper: (Question Question, _) =>
                  Colors.black, // Replace with color logic
            ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:web_project/GamePage.dart';
// // import '../GamePage.dart';
// import 'package:web_project/models/quiz.dart';
// // import 'package:web_project/services/firebase_service.dart';

// class ChartScreen extends StatefulWidget {
//   final List<Player>? chartData;

//   ChartScreen({required this.chartData});

//   @override
//   _ChartScreenState createState() => _ChartScreenState();
// }

// class _ChartScreenState extends State<ChartScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // print('before histo 1');
//     // print(widget.chartData);
//     // final List<ChartData> dataPoints = widget.chartData.entries
//     //     .map((entry) => ChartData(entry.key, entry.value, Colors.blueGrey))
//     //     .toList();
//     // print('before histo');
//     // print(dataPoints);
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.5, // Set a fixed width
//       height: 200, // Set a fixed height or use an appropriate value
//       child: SfCartesianChart(
//         primaryXAxis: CategoryAxis(),
//         series: <ChartSeries>[
//           StackedColumnSeries<Player, String>(
//             dataSource: widget.chartData ?? [],
//             xValueMapper: (Player ch, _) => ch.username,
//             yValueMapper: (Player ch, _) => ch.score,
//             pointColorMapper: (Player ch, _) => Colors.black,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class _ChartScreenState extends State<ChartScreen> {
// //   //  final Quiz quiz;
// //   // final Map<String, int> histogram =quiz.getHistogramForQuestion()
// //   final List<ChartData> chartData = [
// //     ChartData('India', 20, 30, 40, 50, Colors.red),
// //     ChartData('UK', 40, 20, 10, 16, Colors.green),
// //     ChartData('China', 40, 20, 10, 22, Colors.blue),
// //     // ChartData('USA', 10, 14, 22, 44, Colors.orange),
// //   ];
// //   List<Quiz> quizzes = [];
// //   bool isLoading = true;

// //   @override
// //   Widget build(BuildContext context) {
// //     // Future<List<Quiz>> quiz = fetchQuizzes();
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Bar Chart'),
// //       ),
// //       body: Center(
// //         child: Container(
// //           width: 100,
// //           height: 100,
// //           child: SfCartesianChart(
// //             primaryXAxis: CategoryAxis(),
// //             series: <ChartSeries>[
// //               StackedColumnSeries<ChartData, String>(
// //                 dataSource: chartData,
// //                 xValueMapper: (ChartData ch, _) => ch.x,
// //                 yValueMapper: (ChartData ch, _) => ch.y1,
// //                 pointColorMapper: (ChartData ch, _) => ch.color,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// class ChartData {
//   final String x;
//   final int y1;
//   final Color color;

//   ChartData(this.x, this.y1, this.color);
// }
// // class Chart {
// //   final String x;
// //   final int y1;
// //   final int y2;
// //   final int y3;
// //   final int y4;
// //   final Color color;

// //   ChartData(this.x, this.y1, this.y2, this.y3, this.y4, this.color);
// // }

// // final List<ChartData> chartData = [
// //   ChartData('India', 20, 30, 40, 50, Colors.red),
// //   ChartData('UK', 40, 20, 10, 16, Colors.green),
// //   ChartData('China', 40, 20, 10, 22, Colors.blue),
// //   // ChartData('USA', 10, 14, 22, 44, Colors.orange),
// // ];
