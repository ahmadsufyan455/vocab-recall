import 'package:flutter/material.dart';
import 'package:vocabulary_recall/db/app_database.dart';
import 'package:vocabulary_recall/screens/add_word_screen.dart';
import 'package:vocabulary_recall/screens/day7_test_screen.dart';
import 'package:vocabulary_recall/screens/home_screen.dart';
import 'package:vocabulary_recall/screens/today_review_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await openDb();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add-word': (context) => const AddWordScreen(),
        '/today-review': (context) => const TodayReviewScreen(),
        '/day7-test': (context) => const Day7TestScreen(),
      },
    );
  }
}
