import 'package:flutter/material.dart';
import 'package:vocabulary_recall/db/app_database.dart';

class Day7TestScreen extends StatefulWidget {
  const Day7TestScreen({super.key});

  @override
  State<Day7TestScreen> createState() => _Day7TestScreenState();
}

class _Day7TestScreenState extends State<Day7TestScreen> {
  final _textController = TextEditingController();

  Future<void> _completeTest() async {
    await setLastDay7TestCompletedAt(DateTime.now());
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Day 7 Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Speak for 1 minute or write a paragraph using the words you\'ve learned.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'This test proves your learning happened.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _textController,
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Write your paragraph here (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _completeTest,
              child: const Text('Complete Test'),
            ),
          ],
        ),
      ),
    );
  }
}
