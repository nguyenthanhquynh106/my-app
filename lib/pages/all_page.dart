import 'package:flutter/material.dart';
import 'package:my_app/models/english_today.dart';

class AllWordsPage extends StatelessWidget {
  final List<EnglishToday> words;
  const AllWordsPage({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('All words...'),
      ),
    );
  }
}
