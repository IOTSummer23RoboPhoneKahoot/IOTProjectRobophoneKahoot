import 'dart:async';
import 'package:flutter/material.dart';

class CircularCountdownQuestionDurtationTimer extends StatefulWidget {
  final int duration;
  final Function onDone;

  CircularCountdownQuestionDurtationTimer(
      {required this.duration, required this.onDone});

  @override
  _CircularCountdownQuestionDurtationTimerState createState() =>
      _CircularCountdownQuestionDurtationTimerState();
}

class _CircularCountdownQuestionDurtationTimerState
    extends State<CircularCountdownQuestionDurtationTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _timer;
  int _remainingDuration = 0;

  @override
  void initState() {
    super.initState();

    _remainingDuration = widget.duration;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onDone();
      }
    });

    _controller.reverse(from: widget.duration.toDouble());

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingDuration > 0) {
        setState(() {
          print('qustion duration [in The duration Timer]' +
              _remainingDuration.toString() +
              '\n');
          _remainingDuration--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Container(
              width: 100, // Increased size
              height: 100, // Increased size
              child: CircularProgressIndicator(
                value: _controller.value,
                strokeWidth: 10.0, // Increased strokeWidth
              ),
            );
          },
        ),
        Text(
          '$_remainingDuration',
          style: TextStyle(
            fontSize: 40, // Increased fontSize
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
