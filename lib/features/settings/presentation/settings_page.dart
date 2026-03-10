import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/app_settings.dart';
import 'settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Vibración'),
            subtitle: const Text('Respuesta háptica al interactuar'),
            value: settings.vibrationEnabled,
            onChanged: controller.toggleVibration,
          ),
          SwitchListTile(
            title: const Text('Sonido'),
            subtitle: const Text('Efectos de sonido al jugar'),
            value: settings.soundEnabled,
            onChanged: controller.toggleSound,
          ),
          SwitchListTile(
            title: const Text('Animaciones'),
            subtitle: const Text('Activar transiciones y efectos visuales'),
            value: settings.animationsEnabled,
            onChanged: controller.toggleAnimations,
          ),
          SwitchListTile(
            title: const Text('Mantener pantalla encendida'),
            subtitle: const Text(
              'Evita que la pantalla se apague durante la partida',
            ),
            value: settings.keepScreenOn,
            onChanged: controller.toggleKeepScreenOn,
          ),
          const Divider(),
          ListTile(
            title: const Text('Tema'),
            subtitle: Text(_themeLabel(settings.themeMode)),
            trailing: DropdownButton<AppThemeMode>(
              value: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  controller.setThemeMode(value);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: AppThemeMode.system,
                  child: Text('Sistema'),
                ),
                DropdownMenuItem(
                  value: AppThemeMode.light,
                  child: Text('Claro'),
                ),
                DropdownMenuItem(
                  value: AppThemeMode.dark,
                  child: Text('Oscuro'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _themeLabel(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return 'Seguir configuración del sistema';
      case AppThemeMode.light:
        return 'Tema claro';
      case AppThemeMode.dark:
        return 'Tema oscuro';
    }
  }
}