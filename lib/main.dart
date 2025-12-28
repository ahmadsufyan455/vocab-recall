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
      title: 'Vocabulary Recall',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF43A047),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
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
