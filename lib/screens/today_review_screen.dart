import 'package:flutter/material.dart';
import 'package:vocabulary_recall/db/app_database.dart';

class TodayReviewScreen extends StatefulWidget {
  const TodayReviewScreen({super.key});

  @override
  State<TodayReviewScreen> createState() => _TodayReviewScreenState();
}

class _TodayReviewScreenState extends State<TodayReviewScreen> {
  List<Map<String, dynamic>> _words = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    setState(() {
      _isLoading = true;
    });
    final words = await getWords();
    setState(() {
      _words = words;
      _currentIndex = 0;
      _isLoading = false;
    });
  }

  Future<void> _submitReview() async {
    if (_words.isEmpty || _currentIndex >= _words.length) {
      return;
    }

    final wordId = _words[_currentIndex]['id'] as int;
    await submitReview(wordId);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Today Review')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Today Review')),
        body: const Center(child: Text('No words to review today')),
      );
    }

    final currentWord = _words[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Today Review')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentWord['word'] as String,
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              currentWord['meaning'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _submitReview,
              child: const Text('Reviewed'),
            ),
          ],
        ),
      ),
    );
  }
}
