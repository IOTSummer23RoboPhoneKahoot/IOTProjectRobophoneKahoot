// import 'package:flutter/material.dart';

// class MyRectangleWidget extends StatefulWidget {
//   final Color getColor;
//   final IconData getShape;
//   final int height; // Add a height property
//   MyRectangleWidget({
//     required this.getColor,
//     required this.getShape,
//     required this.height,
//   });

//   @override
//   _MyRectangleWidgetState createState() => _MyRectangleWidgetState();
// }

// class _MyRectangleWidgetState extends State<MyRectangleWidget> {
//   late Color setColor;
//   late IconData setShape;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize setColor and setShape with widget properties in initState
//     setColor = widget.getColor;
//     setShape = widget.getShape;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 100.0,
//             height: calculateHeight(widget.height),
//             color: widget.getColor,
//             margin: EdgeInsets.all(3.0),
//             child: Center(
//               child: Text(
//                 widget.height
//                     .toString(), // Show the number of answers above the rectangle
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           Container(
//             width: 100.0,
//             height: 20.0,
//             color: widget.getColor,
//             margin: EdgeInsets.all(3.0),
//             child: Center(
//               child: Icon(
//                 widget.getShape,
//                 color: Colors.white,
//                 size: 15.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Function to calculate the height based on the number of answers
//   double calculateHeight(int numberOfAnswers) {
//     // You can customize the calculation as needed.
//     // For example, you can set a fixed height or calculate it based on some logic.
//     return numberOfAnswers * 20.0; // Example: 20.0 pixels per answer
//   }
// }

// class MyRectangleRow extends StatelessWidget {
//   final Map<String, int> histogramData;

//   MyRectangleRow({required this.histogramData});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: histogramData.keys.map((option) {
//         int height = histogramData[option] ?? 0;
//         return MyRectangleWidget(
//           getColor: Colors.blue, // You can set the color as needed
//           getShape: Icons.brightness_1, // You can set the icon as needed
//           height: height, // Pass the height as a property
//         );
//       }).toList(),
//     );
//   }
// }

import 'package:flutter/material.dart';

class MyRectangleWidget extends StatefulWidget {
  final Color getColor;
  final IconData getShape;
  final int height;
  MyRectangleWidget({
    required this.getColor,
    required this.getShape,
    required this.height,
  });

  @override
  _MyRectangleWidgetState createState() => _MyRectangleWidgetState();
}

class _MyRectangleWidgetState extends State<MyRectangleWidget> {
  late Color setColor;
  late IconData setShape;
  late int height;

  @override
  void initState() {
    super.initState();
    // Initialize setColor and setShape with widget properties in initState
    setColor = widget.getColor;
    setShape = widget.getShape;
    height = widget.height;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100.0,
            height: calculateHeight(widget.height),
            color: widget.getColor,
            margin: EdgeInsets.all(3.0),
            child: Center(
              child: Text(
                widget.height
                    .toString(), // Show the number of answers above the rectangle
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: 100.0,
            height: 20.0,
            color: widget.getColor,
            margin: EdgeInsets.all(3.0),
            child: Center(
              child: Icon(
                widget.getShape,
                color: Colors.white,
                size: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to calculate the height based on the number of answers
  double calculateHeight(int numberOfAnswers) {
    // You can customize the calculation as needed.
    // For example, you can set a fixed height or calculate it based on some logic.
    return numberOfAnswers > 0
        ? numberOfAnswers * 20.0
        : 20.0; // Example: 20.0 pixels per answer, with a minimum height of 20.0
  }
}

// class MyRectangleRow extends StatelessWidget {
//   final Map<String, int> histogramData;

//   MyRectangleRow({required this.histogramData});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: histogramData.keys.map((option) {
//         int height = histogramData[option] ?? 0;

//         return MyRectangleWidget(
//           getColor: Colors.blue, // You can set the color as needed
//           getShape: Icons.brightness_1, // You can set the icon as needed
//           height: height, // Pass the height as a property
//         );
//       }).toList(),
//     );
//   }
// }

class MyRectangleRow extends StatelessWidget {
  final Map<String, int> histogramData;

  MyRectangleRow({required this.histogramData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: histogramData.keys.map((option) {
        int height = histogramData[option] ?? 10;

        IconData shape = Icons.brightness_1;
        Color color = Colors.blue;
        if (option == '0') {
          color = Colors.red;
          shape = Icons.play_arrow;
        } else if (option == '1') {
          shape = Icons.star;
          color = Colors.yellow;
        } else if (option == '2') {
          shape = Icons.brightness_1;
          color = Colors.green;
        } else if (option == '3') {
          shape = Icons.crop_square;
          color = Colors.blue;
        }

        return Column(
          children: [
            MyRectangleWidget(
              getColor: color, // You can set the color as needed
              getShape: shape, // Set the icon based on the option index
              height: height, // Pass the height as a property
            ),
            SizedBox(height: 5), // Adjust the vertical spacing here
          ],
        );
      }).toList(),
    );
  }
}

// class MyRectangleRow extends StatelessWidget {
//   final Map<String, int> histogramData;

//   MyRectangleRow({required this.histogramData});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: histogramData.keys.map((option) {
//         int height = histogramData[option] ?? 0;

//         IconData shape = Icons.brightness_1; // Default icon
//         if (option == 'Option 1') {
//           shape = Icons.play_arrow;
//         } else if (option == 'Option 2') {
//           shape = Icons.star;
//         } else if (option == 'Option 3') {
//           shape = Icons.brightness_1;
//         } else if (option == 'Option 4') {
//           shape = Icons.crop_square;
//         }

//         return Column(
//           children: [
//             MyRectangleWidget(
//               getColor: Colors.blue, // You can set the color as needed
//               getShape: shape, // Set the icon based on the option
//               height: height, // Pass the height as a property
//             ),
//             SizedBox(height: 5), // Adjust the vertical spacing here
//           ],
//         );
//       }).toList(),
//     );
//   }
// }


// class MyRectangleWidget extends StatefulWidget {
//   final Color getColor;
//   final IconData getShape;
//   final int height; // Add a height property
//   MyRectangleWidget({
//     required this.getColor,
//     required this.getShape,
//     required this.height,
//   });

//   @override
//   _MyRectangleWidgetState createState() => _MyRectangleWidgetState();
// }

// class _MyRectangleWidgetState extends State<MyRectangleWidget> {
//   late Color setColor;
//   late IconData setShape;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize setColor and setShape with widget properties in initState
//     setColor = widget.getColor;
//     setShape = widget.getShape;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 100.0,
//             height: calculateHeight(widget.height),
//             color: widget.getColor,
//             margin: EdgeInsets.all(3.0),
//             child: Center(
//               child: Text(
//                 widget.height
//                     .toString(), // Show the number of answers above the rectangle
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           Container(
//             width: 100.0,
//             height: 20.0,
//             color: widget.getColor,
//             margin: EdgeInsets.all(3.0),
//             child: Center(
//               child: Icon(
//                 widget.getShape,
//                 color: Colors.white,
//                 size: 15.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Function to calculate the height based on the number of answers
//   double calculateHeight(int numberOfAnswers) {
//     // You can customize the calculation as needed.
//     // For example, you can set a fixed height or calculate it based on some logic.
//     return numberOfAnswers * 20.0; // Example: 20.0 pixels per answer
//   }
// }

// class MyRectangleRow extends StatelessWidget {
//   final Map<String, int> histogramData;

//   MyRectangleRow({required this.histogramData});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: histogramData.keys.map((option) {
//         int height = histogramData[option] ?? 0;
//         return MyRectangleWidget(
//           getColor: Colors.blue, // You can set the color as needed
//           getShape: Icons.brightness_1, // You can set the icon as needed
//           height: height, // Pass the height as a property
//         );
//       }).toList(),
//     );
//   }
// }

// class MyRectangleWidget extends StatefulWidget {
//   final Color getColor;
//   final IconData getShape;
//   final int height;
//   MyRectangleWidget({
//     required this.getColor,
//     required this.getShape,
//     required this.height,
//   });

//   @override
//   _MyRectangleWidgetState createState() => _MyRectangleWidgetState();
// }

// class _MyRectangleWidgetState extends State<MyRectangleWidget> {
//   late Color setColor;
//   late IconData setShape;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize setColor and setShape with widget properties in initState
//     setColor = widget.getColor;
//     setShape = widget.getShape;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 100.0,
//             height: calculateHeight(widget.height),
//             color: widget.getColor,
//             margin: EdgeInsets.all(3.0),
//           ),
//           Container(
//             width: 100.0,
//             height: 20.0,
//             color: widget.getColor,
//             margin: EdgeInsets.all(3.0),
//             child: Center(
//               child: Icon(
//                 widget.getShape,
//                 color: Colors.white,
//                 size: 15.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Function to calculate the height based on the number of answers
//   double calculateHeight(int numberOfAnswers) {
//     // You can customize the calculation as needed.
//     // For example, you can set a fixed height or calculate it based on some logic.
//     return numberOfAnswers * 20.0; // Example: 20.0 pixels per answer
//   }
// }

// class MyRectangleRow extends StatelessWidget {
//   final Map<String, int> histogramData;

//   MyRectangleRow({required this.histogramData});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: histogramData.keys.map((option) {
//         int height = histogramData[option] ?? 0;
//         return MyRectangleWidget(
//           getColor: Colors.blue, // You can set the color as needed
//           getShape: Icons.brightness_1, // You can set the icon as needed
//           height: height, // Pass the height as a property
//         );
//       }).toList(),
//     );
//   }
// }

// Widget build(BuildContext context) {
//   return Center(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Second Rectangle with dynamic height based on the number of answers
//         Container(
//           width: 100.0, // Same width as the first rectangle
//           height: calculateHeight(
//               5), // Example: calculating height based on 5 answers
//           color: setColor, // Same color as the first rectangle
//           margin: EdgeInsets.all(3.0), // Add spacing between the rectangles
//         ),
//         // First Rectangle with a constant height of 0.5 containing an icon
//         Container(
//           width: 100.0, // Change the width as needed
//           height: 20.0, // Constant height of 0.5 times 100
//           color: setColor, // Change the color as needed
//           margin: EdgeInsets.all(3.0), // Add spacing between the rectangles
//           child: Center(
//             child: Icon(
//               setShape, // Use the provided IconData as the icon
//               color: Colors.white, // Color of the icon
//               size: 15.0, // Size of the icon
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
// class MyRectangleRow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment:
//           MainAxisAlignment.center, // Use MainAxisAlignment.start
//       children: [
//         MyRectangleWidget(
//           getColor: Colors.red,
//           getShape: Icons.play_arrow,
//         ),
//         SizedBox(width: 5), // Adjust the spacing here
//         MyRectangleWidget(
//           getColor: Colors.yellow,
//           getShape: Icons.star,
//         ),
//         SizedBox(width: 5), // Adjust the spacing here
//         MyRectangleWidget(
//           getColor: Colors.green,
//           getShape: Icons.brightness_1,
//         ),
//         SizedBox(width: 5), // Adjust the spacing here
//         MyRectangleWidget(
//           getColor: Colors.blue,
//           getShape: Icons.crop_square,
//         ),
//       ],
//     );
//   }
// }
