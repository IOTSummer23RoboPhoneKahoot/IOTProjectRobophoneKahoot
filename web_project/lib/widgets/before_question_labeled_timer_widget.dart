import 'package:flutter/material.dart';
import 'package:web_project/widgets/countDownTimer_widget.dart';

class LabelledCountdownTimer extends StatelessWidget {
  final int duration;
  final Function onDone;

  LabelledCountdownTimer({required this.duration, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30.0, bottom: 50.0),
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 137, 106, 106),
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 137, 106, 106),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Text(
            "Get Ready",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: Container(
            // color: const Color.fromARGB(255, 102, 81, 106),
            child: SizedBox(
              width: 500, // Adjust these dimensions for the desired size
              height: 500,
              child: CircularCountdownTimer(
                duration: duration,
                onDone: onDone,
              ),
            ),
          ),
        )
      ],
    );
  }
}
