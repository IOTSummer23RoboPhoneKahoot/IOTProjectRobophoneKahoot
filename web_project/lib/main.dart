import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:web_project/CorrectEachQuestionWidget.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'IntroPage.dart';
import 'CorrectEachQuestionWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Robophone Kahoot Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: introPage(),
      home: CorrectAnswersWidget(),
    );
  }
}
