import 'package:flutter/material.dart';
import 'firebaseCreds/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'routes.dart';
import 'dart:async'; // <-- Required for Timer
import 'package:web_project/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    startUpdatingLocalTime();
  }

  @override
  void dispose() {
    stopUpdatingLocalTime();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startUpdatingLocalTime();
    } else if (state == AppLifecycleState.paused) {
      stopUpdatingLocalTime();
    }
  }

  void startUpdatingLocalTime() {
    const timeInterval = Duration(seconds: 1);
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(timeInterval, (timer) {
      updateFlutterLocalTime();
    });
  }

  void stopUpdatingLocalTime() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Robophone Kahoot Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) => routes),
      routeInformationParser: RoutemasterParser(),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Simple Chart'),
//         ),
//         body: ChartPage(),
//       ),
//     );
//   }
// }

// class ChartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ChartWidget(),
//     );
//   }
// }

// class ChartWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(300, 150), // Adjust the size as needed
//       painter: ChartPainter(),
//     );
//   }
// }

// class ChartPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     // Define different colors for each option
//     final Color colorOption1 = Colors.blue;
//     final Color colorOption2 = Colors.red;

//     // Calculate the width of each option rectangle with a slight reduction
//     final double optionWidth =
//         ((size.width - 20) / 2); // Adjust the gap as needed

//     // Create Paint objects for each option color
//     final Paint paintOption1 = Paint()
//       ..color = colorOption1
//       ..strokeWidth = 2.0;

//     final Paint paintOption2 = Paint()
//       ..color = colorOption2
//       ..strokeWidth = 2.0;

//     // Set a minimum height for the base rectangle
//     final double baseRectangleMinHeight = 5;

//     // Draw the first option
//     final double option1Height = 0; // Adjust the height as needed
//     canvas.drawRect(
//       Rect.fromPoints(
//         Offset(10, size.height - option1Height),
//         Offset(10 + optionWidth, size.height),
//       ),
//       paintOption1,
//     );

//     // Calculate the height of the base rectangle
//     final double baseRectangleHeight = size.height - baseRectangleMinHeight;

//     // Draw the base rectangle with a minimum height
//     canvas.drawRect(
//       Rect.fromPoints(
//         Offset(10, size.height - baseRectangleHeight),
//         Offset(10 + optionWidth, size.height - option1Height),
//       ),
//       paintOption1,
//     );

//     // Draw the gap space
//     final double gapSpace = 10; // Adjust the gap space as needed
//     canvas.drawRect(
//       Rect.fromPoints(
//         Offset(10 + optionWidth, size.height),
//         Offset(10 + optionWidth + gapSpace, size.height - baseRectangleHeight),
//       ),
//       paintOption1
//         ..color = Colors.transparent, // Make the gap space transparent
//     );

//     // Draw the second option
//     final double option2Height = 100; // Adjust the height as needed
//     canvas.drawRect(
//       Rect.fromPoints(
//         Offset(10 + optionWidth + gapSpace, size.height - option2Height),
//         Offset(10 + (2 * optionWidth) + gapSpace, size.height),
//       ),
//       paintOption2,
//     );
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
