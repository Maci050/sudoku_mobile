import 'package:flutter/material.dart';
import '../data/achievements_storage.dart';
import '../domain/achievement.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = AchievementsStorage();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logros'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: allAchievements.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final achievement = allAchievements[index];
          final unlocked = storage.isUnlocked(achievement.id);

          return Card(
            child: ListTile(
              leading: Text(
                achievement.emoji,
                style: TextStyle(
                  fontSize: 26,
                  color: unlocked ? null : Colors.grey,
                ),
              ),
              title: Text(
                achievement.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: unlocked ? null : Colors.grey,
                ),
              ),
              subtitle: Text(
                achievement.description,
                style: TextStyle(
                  color: unlocked ? null : Colors.grey,
                ),
              ),
              trailing: Icon(
                unlocked ? Icons.check_circle : Icons.lock_outline,
              ),
            ),
          );
        },
      ),
    );
  }
}