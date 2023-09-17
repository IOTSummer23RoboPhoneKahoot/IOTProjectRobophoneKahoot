import 'dart:async';
import 'package:flutter/material.dart';

class CircularCountdownTimer extends StatefulWidget {
  final int duration;
  final Function onDone;

  CircularCountdownTimer({required this.duration, required this.onDone});

  @override
  _CircularCountdownTimerState createState() => _CircularCountdownTimerState();
}

class _CircularCountdownTimerState extends State<CircularCountdownTimer>
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
              width: 400, // Increased size
              height: 400, // Increased size
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
