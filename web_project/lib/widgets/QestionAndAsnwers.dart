import 'package:flutter/material.dart';

class QuestionAndAnswers extends StatelessWidget {
  final String questionText;
  final List<String> answers;

  QuestionAndAnswers({
    required this.questionText,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final containerWidth = MediaQuery.of(context).size.width * 0.55 -
        20.0; // Adjusting to 55% of the screen width

    return Container(
      width: containerWidth,
      child: Column(
        children: <Widget>[
          Text(
            questionText,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 130.0),
          Column(
            children: List<Widget>.generate(
              (answers.length / 2).ceil(),
              (rowIndex) {
                final startIndex = rowIndex * 2;
                final endIndex = startIndex + 2 > answers.length
                    ? answers.length
                    : startIndex + 2;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List<Widget>.generate(
                    endIndex - startIndex,
                    (index) {
                      final answerIndex = startIndex + index;
                      IconData symbol;
                      Color color;

                      if (answerIndex % 4 == 0) {
                        symbol = Icons.play_arrow;
                        color = Colors.red;
                      } else if (answerIndex % 4 == 1) {
                        symbol = Icons.star;
                        color = Colors.yellow;
                      } else if (answerIndex % 4 == 2) {
                        symbol = Icons.brightness_1;
                        color = Colors.green;
                      } else {
                        symbol = Icons.crop_square;
                        color = Colors.blue;
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        padding: EdgeInsets.all(20.0),
                        width: (containerWidth / 2) -
                            30.0, // Adjusted width for answers
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              symbol,
                              color: Colors.white,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Flexible(
                              child: Text(
                                answers[answerIndex],
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
