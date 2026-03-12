import 'package:vibration/vibration.dart';
import '../../features/settings/data/settings_storage.dart';

class FeedbackService {
  static Future<void> _tryVibrate({int duration = 35}) async {
    final settings = SettingsStorage().loadSettings();
    if (!settings.vibrationEnabled) return;

    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) return;

    await Vibration.vibrate(duration: duration);
  }

  static Future<void> vibrateTap() async {
    await _tryVibrate(duration: 25);
  }

  static Future<void> vibrateWin() async {
    await _tryVibrate(duration: 60);
  }

  static Future<void> vibrateError() async {
    await _tryVibrate(duration: 45);
  }
}