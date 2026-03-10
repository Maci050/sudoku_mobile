import 'package:vibration/vibration.dart';

class FeedbackService {
  static Future<void> vibrateLight() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(duration: 40);
    }
  }

  static Future<void> vibrateWin() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(duration: 90);
    }
  }
}