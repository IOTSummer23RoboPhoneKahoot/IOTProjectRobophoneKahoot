import 'package:flutter/material.dart';

class QuestionAndAnswers extends StatelessWidget {
  final String questionText;
  final List<String> answers;
  final int questionDuration;
  //final int answersNum;
  QuestionAndAnswers(
      {required this.questionText,
      required this.answers,
      required this.questionDuration});
  // required this.answersNum});
  @override
  Widget build(BuildContext context) {
    if (questionText.isEmpty) {
      return Text('Waiting for question...');
    }

    final containerWidth = MediaQuery.of(context).size.width / 2 -
        20.0; // Width for each container

    return Column(
      children: <Widget>[
        Text(
          questionText,
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.0), // Increased space below the question text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0), // Add left margin
              child: Container(
                width: 50.0, // Set a fixed width for the circle
                height: 50.0, // Set a fixed height for the circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // Set the circle color
                ),
                child: Center(
                  child: Text(
                    '$questionDuration',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(right: 20.0), // Add right margin
            //   child: Column(
            //     children: <Widget>[
            //       Text(
            //         '$answersNum',
            //         style: TextStyle(fontSize: 20),
            //       ),
            //       Text(
            //         'Answers',
            //         style: TextStyle(fontSize: 20),
            //       ),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(right: 20.0), // Add right margin
            //   child:
            //       AnswersEachQuestion(), // Use the AnswersEachQuestion widget here
            // ),
          ],
        ),
        SizedBox(
            height:
                160.0), // Increased space below the number of players and 'Answers' // Increased space below the question text
        Column(
          children: List<Widget>.generate(
            (answers.length / 2).ceil(),
            (rowIndex) {
              final startIndex = rowIndex * 2;
              final endIndex = startIndex + 2 > answers.length
                  ? answers.length
                  : startIndex + 2;

              return Row(
                children: List<Widget>.generate(
                  endIndex - startIndex,
                  (index) {
                    final answerIndex = startIndex + index;
                    IconData symbol;
                    Color color;

                    // Assign symbols and colors based on answerIndex
                    if (answerIndex % 4 == 0) {
                      symbol = Icons.play_arrow; // Triangle
                      color = Colors.red;
                    } else if (answerIndex % 4 == 1) {
                      symbol = Icons.star; // Rhombus
                      color = Colors.yellow;
                    } else if (answerIndex % 4 == 2) {
                      symbol = Icons.brightness_1; // Circle
                      color = Colors.green;
                    } else {
                      symbol = Icons.crop_square; // Square
                      color = Colors.blue;
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 16.0), // Increased vertical margin
                      padding: EdgeInsets.all(20.0),
                      width: containerWidth, // Set the width for each container
                      decoration: BoxDecoration(
                        color: color, // Set the background color
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            symbol,
                            color: Colors.white, // Set the symbol color
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          Flexible(
                            child: Text(
                              answers[answerIndex],
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow
                                  .ellipsis, // Add ellipsis if the text overflows
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
//   Widget build(BuildContext context) {
//     if (questionText.isEmpty) {
//       return Text('Waiting for question...');
//     }

//     final containerWidth = MediaQuery.of(context).size.width / 2 - 20.0;

//     return Align(
//       alignment: Alignment.topCenter,
//       child: Column(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.topCenter,
//             child: Text(
//               questionText,
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 20.0),
//           Align(
//             alignment: Alignment.topCenter,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 20.0),
//                     child: Container(
//                       width: 50.0,
//                       height: 50.0,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.blue,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '$questionDuration',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Padding(
//                     padding: EdgeInsets.only(right: 20.0),
//                     child: Column(
//                       children: <Widget>[
//                         Text(
//                           '$answersNum',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                         Text(
//                           'Answers',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 20.0),
//           Align(
//             alignment: Alignment.topCenter,
//             child: Column(
//               children: List<Widget>.generate(
//                 (answers.length / 2).ceil(),
//                 (rowIndex) {
//                   final startIndex = rowIndex * 2;
//                   final endIndex = startIndex + 2 > answers.length
//                       ? answers.length
//                       : startIndex + 2;

//                   return Align(
//                     alignment: Alignment.topCenter,
//                     child: Row(
//                       children: List<Widget>.generate(
//                         endIndex - startIndex,
//                         (index) {
//                           final answerIndex = startIndex + index;
//                           IconData symbol;
//                           Color color;

//                           if (answerIndex % 4 == 0) {
//                             symbol = Icons.play_arrow;
//                             color = Colors.red;
//                           } else if (answerIndex % 4 == 1) {
//                             symbol = Icons.star;
//                             color = Colors.yellow;
//                           } else if (answerIndex % 4 == 2) {
//                             symbol = Icons.brightness_1;
//                             color = Colors.green;
//                           } else {
//                             symbol = Icons.crop_square;
//                             color = Colors.blue;
//                           }

//                           return Container(
//                             margin: EdgeInsets.symmetric(vertical: 16.0),
//                             padding: EdgeInsets.all(20.0),
//                             width: containerWidth,
//                             decoration: BoxDecoration(
//                               color: color,
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             child: Row(
//                               children: <Widget>[
//                                 Icon(
//                                   symbol,
//                                   color: Colors.white,
//                                   size: 20.0,
//                                 ),
//                                 SizedBox(width: 8.0),
//                                 Flexible(
//                                   child: Text(
//                                     answers[answerIndex],
//                                     style: TextStyle(color: Colors.white),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
