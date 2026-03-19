import 'package:flutter/material.dart';

class ThemeBackground extends StatelessWidget {
  final Widget child;
  final String? assetPath;

  const ThemeBackground({
    super.key,
    required this.child,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath == null) {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            assetPath!,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.white.withValues(alpha: 0.20),
          ),
        ),
        child,
      ],
    );
  }
}