import 'package:routemaster/routemaster.dart';
import 'IntroPage.dart';
import 'package:flutter/material.dart';
import 'CreateQuiz.dart';
import 'GamePage.dart';
import 'GameSummaryPage.dart';

final routes = RouteMap(
  routes: {
    '/': (route) => MaterialPage(child: introPage()),
    '/createQuiz': (route) => MaterialPage(child: CreateQuizApp()),
    '/game/:quizId': (route) => MaterialPage(
        child: GamePage(
            quizId: route.pathParameters['quizId']!)), // Using pathParameters
    '/gameSummary/:quizId': (route) => MaterialPage(
        child: GameSummaryPage(quizID: route.pathParameters['quizId']!))
  },
);
