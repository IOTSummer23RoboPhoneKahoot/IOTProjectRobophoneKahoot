import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_project/models/quiz.dart';

class ChartScreen<T> extends StatefulWidget {
  final dynamic chartData;

  ChartScreen({required this.chartData});

  @override
  _ChartScreenState createState() => _ChartScreenState<T>();
}

class _ChartScreenState<T> extends State<ChartScreen<T>> {
  List<Data> list = [];

  void initState() {
    super.initState();
    if (widget.chartData is Map<String, int>) {
      setState(() {
        widget.chartData.forEach((k, v) => list.add(Data(k, v, Colors.red)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 200,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: <ChartSeries>[
            if (widget.chartData is List<Player>)
              StackedColumnSeries<Player, String>(
                dataSource: (widget.chartData as List<Player>?) ?? [],
                xValueMapper: (Player ch, _) => ch.username,
                yValueMapper: (Player ch, _) => ch.score,
                pointColorMapper: (Player ch, _) => Colors.black,
              )
            else if (widget.chartData is Map<String, int>)
              StackedColumnSeries<Data, String>(
                dataSource: (list as List<Data>?) ?? [],
                xValueMapper: (Data Question, _) =>
                    Question.x.toString(), // Replace with appropriate field
                yValueMapper: (Data Question, _) =>
                    Question.y1, // Replace with appropriate field
                pointColorMapper: (Data Question, _) =>
                    Colors.red, // Replace with color logic
              ),
          ],
        ),
      ),
    );
  }
}

class Data {
  final String x;
  final int y1;
  final Color color;

  Data(this.x, this.y1, this.color);
}


// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class ChartScreen<T> extends StatefulWidget {
//   final dynamic chartData;
//   int correctAnswerIndex;

//   ChartScreen({required this.chartData, required this.correctAnswerIndex});

//   @override
//   _ChartScreenState createState() => _ChartScreenState<T>();
// }

// class Data {
//   final String x;
//   final int y1;
//   final Color color;

//   Data(this.x, this.y1, this.color);
// }

// class _ChartScreenState<T> extends State<ChartScreen<T>> {
//   List<Data> list = [];

//   void initState() {
//     super.initState();
//     if (widget.chartData is Map<String, int>) {
//       setState(() {
//         widget.chartData.forEach((k, v) => list.add(Data(k, v, Colors.red)));
//       });
//     }
//   }

//   @override
//   // Widget build(BuildContext context) {
//   //   final List<Data> dataPoints = (widget.chartData as List<Data>?) ?? [];

//   //   return SingleChildScrollView(
//   //     child: Container(
//   //       width: MediaQuery.of(context).size.width * 0.5,
//   //       height: 200,
//   //       child: Stack(
//   //         children: [
//   //           SfCartesianChart(
//   //             primaryXAxis: CategoryAxis(),
//   //             primaryYAxis: NumericAxis(
//   //               interval: 1, // Set the interval to 2
//   //               majorGridLines:
//   //                   MajorGridLines(width: 1), // Customize grid lines
//   //             ),
//   //             series: <ChartSeries>[
//   //               StackedColumnSeries<Data, String>(
//   //                 dataSource: dataPoints,
//   //                 xValueMapper: (Data question, _) => question.x.toString(),
//   //                 yValueMapper: (Data question, _) => question.y1,
//   //                 pointColorMapper: (Data question, int index) {
//   //                   // Return different colors based on the index
//   //                   return index == widget.correctAnswerIndex
//   //                       ? Colors.green
//   //                       : Colors.blue;
//   //                 },
//   //                 dataLabelSettings:
//   //                     DataLabelSettings(isVisible: false), // Hide data labels
//   //               ),
//   //             ],
//   //           ),
//   //           // Add an icon above the correct answer
//   //           if (widget.correctAnswerIndex >= 0 &&
//   //               widget.correctAnswerIndex < dataPoints.length)
//   //             Positioned(
//   //               top: 0, // Adjust the position as needed
//   //               left: 0, // Adjust the position as needed
//   //               child: Icon(
//   //                 Icons.check_circle,
//   //                 color: Colors.green,
//   //                 size: 20.0,
//   //               ),
//   //             ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget build(BuildContext context) {
//   //   int flag = 0;
//   //   return SingleChildScrollView(
//   //     child: Container(
//   //       width: MediaQuery.of(context).size.width * 0.5,
//   //       height: 200,
//   //       child: SfCartesianChart(
//   //         primaryXAxis: CategoryAxis(),
//   //         primaryYAxis: NumericAxis(
//   //           interval: 1, // Set the interval to 2
//   //           majorGridLines: MajorGridLines(width: 1), // Customize grid lines
//   //         ),
//   //         series: <ChartSeries>[
//   //           if (widget.chartData is Map<String, int>)
//   //             StackedColumnSeries<Data, String>(
//   //               dataSource: (list as List<Data>?) ?? [],
//   //               xValueMapper: (Data question, _) => question.x.toString(),
//   //               yValueMapper: (Data question, _) => question.y1,
//   //               pointColorMapper: (Data question, int index) {
//   //                 // Return different colors based on the index
//   //                 if (index == widget.correctAnswerIndex) {
//   //                   flag = 1;
//   //                   return Colors.green; // Color for the correct answer
//   //                 } //else {
//   //                 //   return Colors.white; // Default color for other answers
//   //                 //}
//   //               },
//   //               markerSettings: MarkerSettings(
//   //                 isVisible: flag == 1 ? true : false,
//   //                 shape: DataMarkerType.triangle, // Symbol shape
//   //                 width: 10.0,
//   //                 height: 10.0,
//   //               ),
//   //             ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   // Widget build(BuildContext context) {
//   //   return SingleChildScrollView(
//   //     child: Container(
//   //       width: MediaQuery.of(context).size.width * 0.5,
//   //       height: 200,
//   //       child: SfCartesianChart(
//   //         primaryXAxis: CategoryAxis(),
//   //         primaryYAxis: NumericAxis(
//   //           interval: 1, // Set the interval to 2
//   //           majorGridLines: MajorGridLines(width: 1), // Customize grid lines
//   //         ),
//   //         series: <ChartSeries>[
//   //           if (widget.chartData is Map<String, int>)
//   //             StackedColumnSeries<Data, String>(
//   //               dataSource: (list as List<Data>?) ?? [],
//   //               xValueMapper: (Data question, _) => question.x.toString(),
//   //               yValueMapper: (Data question, _) => question.y1,
//   //               pointColorMapper: (Data question, int index) {
//   //                 // Return different colors based on the index
//   //                 if (index == 0) {
//   //                   return Colors.red;
//   //                 } else if (index == 1) {
//   //                   return Colors.yellow;
//   //                 } else if (index == 2) {
//   //                   return Colors.green;
//   //                 } else if (index == 3) {
//   //                   return Colors.blue;
//   //                 } else {
//   //                   return Colors.black; // Default color
//   //                 }
//   //               },
//   //             ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.5,
//         height: 200,
//         child: SfCartesianChart(
//           primaryXAxis: CategoryAxis(),
//           series: <ChartSeries>[
//             if (widget.chartData is Map<String, int>)
//               StackedColumnSeries<Data, String>(
//                 dataSource: (list as List<Data>?) ?? [],
//                 xValueMapper: (Data Question, _) =>
//                     Question.x.toString(), // Replace with appropriate field
//                 yValueMapper: (Data Question, _) =>
//                     Question.y1, // Replace with appropriate field
//                 pointColorMapper: (Data Question, _) =>
//                     Colors.red, // Replace with color logic
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
