import 'package:flutter/material.dart';
import 'package:vocabulary_recall/db/app_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showDay7Test = false;

  @override
  void initState() {
    super.initState();
    _checkDay7Condition();
  }

  Future<void> _checkDay7Condition() async {
    final cycleStartDate = await getCycleStartDate();
    if (cycleStartDate != null) {
      final daysSinceCycleStart = DateTime.now()
          .difference(cycleStartDate)
          .inDays;
      setState(() {
        _showDay7Test = daysSinceCycleStart >= 7;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily English')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/today-review');
              },
              child: const Text('Review Today'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/add-word');
                _checkDay7Condition();
              },
              child: const Text('Add New Word'),
            ),
            if (_showDay7Test) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/day7-test');
                  _checkDay7Condition();
                },
                child: const Text('Day 7 Test'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
