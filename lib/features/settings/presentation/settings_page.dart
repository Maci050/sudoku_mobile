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
          const _SectionHeader(title: 'Juego'),
          SwitchListTile(
            title: const Text('Vibración'),
            subtitle: const Text('Respuesta háptica al interactuar'),
            value: settings.vibrationEnabled,
            onChanged: controller.setVibrationEnabled,
          ),
          SwitchListTile(
            title: const Text('Animaciones'),
            subtitle: const Text('Activar transiciones y efectos visuales'),
            value: settings.animationsEnabled,
            onChanged: controller.setAnimationsEnabled,
          ),
          SwitchListTile(
            title: const Text('Mantener pantalla encendida'),
            subtitle: const Text(
              'Evita que la pantalla se apague durante la partida',
            ),
            value: settings.keepScreenOn,
            onChanged: controller.setKeepScreenOn,
          ),
          SwitchListTile(
            title: const Text('Mostrar temporizador'),
            subtitle: const Text('Muestra el tiempo durante la partida'),
            value: settings.showTimer,
            onChanged: controller.setShowTimer,
          ),
          SwitchListTile(
            title: const Text('Confirmar antes de rendirse'),
            subtitle: const Text('Pide confirmación antes de mostrar la solución'),
            value: settings.confirmBeforeSurrender,
            onChanged: controller.setConfirmBeforeSurrender,
          ),
          const _SectionHeader(title: 'Ayudas'),
          SwitchListTile(
            title: const Text('Seleccionar casilla al pedir pista'),
            subtitle: const Text(
              'Selecciona automáticamente la casilla importante de la pista',
            ),
            value: settings.autoSelectHintCell,
            onChanged: controller.setAutoSelectHintCell,
          ),
          const _SectionHeader(title: 'Visual'),
          ListTile(
            title: const Text('Tema'),
            subtitle: Text(settings.themeMode.label),
            trailing: DropdownButton<AppThemeModeSetting>(
              value: settings.themeMode,
              underline: const SizedBox.shrink(),
              onChanged: (value) {
                if (value != null) {
                  controller.setThemeMode(value);
                }
              },
              items: AppThemeModeSetting.values
                  .map(
                    (mode) => DropdownMenuItem(
                      value: mode,
                      child: Text(mode.label),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}