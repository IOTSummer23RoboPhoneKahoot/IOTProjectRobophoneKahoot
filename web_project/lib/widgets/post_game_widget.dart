// // in widgets/post_game_widget.dart

// import 'package:flutter/material.dart';
// import 'package:web_project/models/quiz.dart';
// import 'path_to_your_other_custom_widgets.dart';  // Import necessary widgets

// class PostGameWidget extends StatelessWidget {
//   final Quiz quiz;
//   final int currentQuestionIndex;
//   final Map chartData;
//   final Map chartData2;
//   final String correctAnswer;
//   final bool isGameFinished;
//   final Function endGameCallback;

//   PostGameWidget({
//     required this.quiz,
//     required this.currentQuestionIndex,
//     required this.chartData,
//     required this.chartData2,
//     required this.correctAnswer,
//     required this.isGameFinished,
//     required this.endGameCallback,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         QuestionStats(
//           quiz: quiz,
//           currentQuestionIndex: currentQuestionIndex,
//           chartData: chartData,
//           chartData2: chartData2,
//           correctAnswer: correctAnswer,
//         ),
//         if (isGameFinished)
//           ElevatedButton(
//             onPressed: endGameCallback as void Function()?,
//             child: Text("Show Game Summary"),
//           ),
//       ],
//     );
//   }
// }
