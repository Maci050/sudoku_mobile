# Sudoku Master: Learn and Play

Sudoku Master: Learn and Play es una aplicación de Sudoku desarrollada con Flutter para Android.
Incluye múltiples modos de juego, estadísticas, sistema de logros, desafío diario y un modo de entrenamiento para aprender técnicas de resolución.

## Features

- Generación de sudokus con distintas dificultades
- Sistema de notas
- Resaltado de errores y duplicados
- Resaltado de filas, columnas y regiones
- Temporizador de partida
- Sistema de pistas con explicación de técnicas
- Corrección automática de notas
- Desafío diario
- Historial de partidas
- Estadísticas del jugador
- Racha de días jugados
- Calendario de actividad
- Sistema de logros
- Modo entrenamiento con progresión por niveles
- Ajustes de aplicación (vibración, animaciones, tema, etc.)

## Project Structure

El proyecto está organizado siguiendo una arquitectura modular basada en features.

lib/
  core/

  features/
    achievements/
    activity/
    daily_challenge/
    game/
    history/
    settings/
    stats/
    streak/
    tips/
    training/

Cada feature contiene generalmente tres capas:

data/
domain/
presentation/

Esto permite una mejor organización del código y facilita la escalabilidad del proyecto.

## Technologies

- Flutter
- Riverpod (gestión de estado)
- Hive (persistencia local)
- Material 3
- Confetti (animaciones)
- Vibration API
- Wakelock

## Getting Started

### Clone the repository

git clone https://github.com/Maci050/sudoku_mobile.git
cd sudoku_mobile

### Install dependencies

flutter pub get

### Run the application

flutter run

## Build

### Build APK

flutter build apk --release

### Build App Bundle

flutter build appbundle

## Future Improvements

- Mejoras en el generador de sudokus
- Más técnicas de resolución
- Sincronización en la nube
- Rankings o estadísticas globales

## Author

Proyecto creado por Yeray

## License

This project is released under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

You are free to:

- Use the code
- Study and modify it
- Share and redistribute it

Under the following conditions:

- Attribution: You must give appropriate credit to the original author.
- NonCommercial: You may not use this project for commercial purposes.

Full license text:
https://creativecommons.org/licenses/by-nc/4.0/