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
