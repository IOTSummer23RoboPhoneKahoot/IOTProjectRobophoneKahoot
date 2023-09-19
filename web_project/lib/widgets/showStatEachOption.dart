import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Multiple MyRectangleWidgets'),
        ),
        body: Center(
          child: MyRectangleRow(),
        ),
      ),
    );
  }
}

class MyRectangleRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MyRectangleWidget(
          getColor: Colors.blue,
          getShape: BoxShape.rectangle,
        ),
        MyRectangleWidget(
          getColor: Colors.red,
          getShape: BoxShape.rectangle,
        ),
        MyRectangleWidget(
          getColor: Colors.green,
          getShape: BoxShape.rectangle,
        ),
        MyRectangleWidget(
          getColor: Colors.orange,
          getShape: BoxShape.rectangle,
        ),
      ],
    );
  }
}

class MyRectangleWidget extends StatefulWidget {
  final Color getColor;
  final BoxShape getShape;

  MyRectangleWidget({required this.getColor, required this.getShape});

  @override
  _MyRectangleWidgetState createState() => _MyRectangleWidgetState();
}

class _MyRectangleWidgetState extends State<MyRectangleWidget> {
  late Color setColor;
  late BoxShape setShape;

  @override
  void initState() {
    super.initState();
    setColor = widget.getColor;
    setShape = widget.getShape;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: setColor,
        shape: setShape,
      ),
    );
  }
}
