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
