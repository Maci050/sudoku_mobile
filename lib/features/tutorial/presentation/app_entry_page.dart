import 'package:flutter/material.dart';
import '../data/tutorial_storage.dart';
import 'tutorial_page.dart';
import '../../home/presentation/home_page.dart';

class AppEntryPage extends StatelessWidget {
  const AppEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final seenTutorial = TutorialStorage().hasSeenTutorial();

    if (seenTutorial) {
      return const HomePage();
    } else {
      return TutorialPage();
    }
  }
}