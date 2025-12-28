import 'package:flutter/material.dart';
import 'package:vocabulary_recall/db/app_database.dart';

class AddWordScreen extends StatefulWidget {
  const AddWordScreen({super.key});

  @override
  State<AddWordScreen> createState() => _AddWordScreenState();
}

class _AddWordScreenState extends State<AddWordScreen> {
  final _wordController = TextEditingController();
  final _meaningController = TextEditingController();

  Future<void> _saveWord() async {
    final word = _wordController.text.trim();
    final meaning = _meaningController.text.trim();

    if (word.isEmpty || meaning.isEmpty) {
      return;
    }

    await insertWord(word, meaning);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _meaningController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Word'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _wordController,
              decoration: const InputDecoration(
                labelText: 'Word',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _meaningController,
              decoration: const InputDecoration(
                labelText: 'Meaning',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveWord,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

