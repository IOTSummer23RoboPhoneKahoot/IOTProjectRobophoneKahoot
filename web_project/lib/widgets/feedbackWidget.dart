import 'package:flutter/material.dart';
import 'package:web_project/models/quiz.dart';
import 'package:web_project/services/firebase_service.dart';
import 'package:fl_chart/fl_chart.dart';

class FeedbackPage extends StatefulWidget {
  final Quiz quiz;

  FeedbackPage({required this.quiz});

  @override
  _FeedbackPage createState() => _FeedbackPage();
}

class _FeedbackPage extends State<FeedbackPage> {
  List<Player> players = [];
  Quiz quiz1 = Quiz(
    quizID: '',
    questions: [],
    quizDetails: QuizDetails(
      nameOfQuiz: '',
      numOfQuestions: '',
      timeToAnswerPerQuestion: '',
    ),
    players: [],
  );

  @override
  void initState() {
    super.initState();
    fetchQuizData();
  }

  // Fetch quiz data by ID
  void fetchQuizData() {
    fetchQuizByID(widget.quiz.quizID.toString()).then((fetchedQuiz) {
      if (fetchedQuiz != null) {
        setState(() {
          quiz1 = fetchedQuiz;
          players = fetchedQuiz.players;
        });
        if (players.isNotEmpty) {
          // Update the charts based on player data
          setState(() {});
        }
      } else {
        // Handle the case where there was an error or no data was found
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Page"),
      ),
      body: Center(
        child: Column(
          children: [
            // Chart for "rate"
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: CustomPieChart(
                  sections: _buildRateChartData(),
                  label: 'Rate Percent',
                ),
              ),
            ),
            // Chart for "learn"
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: CustomPieChart(
                  sections: _buildLearnChartData(),
                  label: 'Learn Percent',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to calculate the total "rate" values from players
  double _calculateTotalRate() {
    double totalRate = 0;
    for (final player in players) {
      totalRate += player.rate; // Assuming "rate" is a double field in Player
    }
    return totalRate;
  }

  // Helper function to build data for the "rate" chart
  List<PieChartSectionData> _buildRateChartData() {
    // Calculate the total "rate" values
    double totalRate = _calculateTotalRate();

    // Calculate the percentages for each "rate" value
    List<PieChartSectionData> sections = [];
    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      double percentage = player.rate / totalRate * 100;

      // Define a list of colors to use for each "rate" value
      final List<Color> rateColors = [
        Colors.blue,
        Colors.purple,
        Colors.orange,
        Colors.pink,
        // Add more colors as needed
      ];

      sections.add(
        PieChartSectionData(
          value: percentage,
          title: '${percentage.toStringAsFixed(2)}%', // Percentage as a label
          color: rateColors[
              i % rateColors.length], // Assign colors based on the index
        ),
      );
    }

    return sections;
  }

  // Helper function to calculate the total "learn" values from players
  double _calculateTotalLearn() {
    double totalLearn = 0;
    for (final player in players) {
      totalLearn +=
          player.learn == 1 ? 1 : 0; // Assuming "learn" is 0 or 1 in Player
    }
    return totalLearn;
  }

  // Helper function to build data for the "learn" chart
  List<PieChartSectionData> _buildLearnChartData() {
    // Calculate the total "learn" values
    double totalLearn = _calculateTotalLearn();

    // Calculate the percentages for "Learn 0" and "Learn 1"
    double percentageLearn0 =
        (totalLearn - _calculateTotalLearn()) / totalLearn * 100;
    double percentageLearn1 = (_calculateTotalLearn()) / totalLearn * 100;

    // Define a list of colors to use for "Learn 0" and "Learn 1"
    final List<Color> learnColors = [
      Colors.red,
      Colors.green,
      // Add more colors as needed
    ];

    return [
      PieChartSectionData(
        value: percentageLearn0,
        title:
            '${percentageLearn0.toStringAsFixed(2)}%', // Percentage as a label
        color: learnColors[0 % learnColors.length], // Assign colors
      ),
      PieChartSectionData(
        value: percentageLearn1,
        title:
            '${percentageLearn1.toStringAsFixed(2)}%', // Percentage as a label
        color: learnColors[1 % learnColors.length], // Assign colors
      ),
    ];
  }
}

class CustomPieChart extends StatelessWidget {
  final List<PieChartSectionData> sections;
  final String label;

  CustomPieChart({required this.sections, required this.label});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PieChart(
          PieChartData(
            sections: sections,
            centerSpaceRadius: 50,
            sectionsSpace: 0, // Reduce the space between sections
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.black, // Customize the text color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
