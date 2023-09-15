import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';

class CorrectAnswersWidget extends StatefulWidget {
  final Quiz quiz;
  CorrectAnswersWidget({required this.quiz});

  @override
  _CorrectAnswersWidgetState createState() => _CorrectAnswersWidgetState();
}

class ChartData {
  final String x;
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
    for (var entry in correctAnswerCounts.entries) {
      chartData.add(ChartData('Question $index', entry.value, Colors.blue));
      index++;
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    final correctAnswersCount = computeCorrectAnswers();

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(8.0),
      child: Container(
        constraints: BoxConstraints(maxWidth: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Correct Answers Count for Each Question:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }
}
