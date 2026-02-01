import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// A lightweight, user-friendly confetti celebration overlay.
///
/// Usage:
/// ```dart
/// // In your StatefulWidget, create a controller:
/// final _confettiController = ConfettiController(duration: const Duration(seconds: 2));
///
/// // Add the overlay to your widget tree:
/// Stack(
///   children: [
///     YourContent(),
///     CelebrationConfetti(controller: _confettiController),
///   ],
/// )
///
/// // Trigger the celebration:
/// _confettiController.play();
/// ```
class CelebrationConfetti extends StatelessWidget {
  final ConfettiController controller;
  final Alignment alignment;
  final double blastIntensity;
  final int numberOfParticles;

  const CelebrationConfetti({
    super.key,
    required this.controller,
    this.alignment = Alignment.topCenter,
    this.blastIntensity = 0.05,
    this.numberOfParticles = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirection: pi / 2, // straight down
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 8,
        minBlastForce: 3,
        emissionFrequency: blastIntensity,
        numberOfParticles: numberOfParticles,
        gravity: 0.2,
        shouldLoop: false,
        colors: const [
          Color(0xFF26C6DA), // Cyan
          Color(0xFF66BB6A), // Green
          Color(0xFFFFCA28), // Amber
          Color(0xFFAB47BC), // Purple
          Color(0xFFEF5350), // Red
          Color(0xFF42A5F5), // Blue
        ],
        createParticlePath: _createParticlePath,
      ),
    );
  }

  /// Creates small, lightweight particle shapes
  Path _createParticlePath(Size size) {
    final random = Random();
    final shapeType = random.nextInt(3);

    switch (shapeType) {
      case 0:
        // Small circle
        return Path()..addOval(
          Rect.fromCircle(center: Offset.zero, radius: size.width * 0.4),
        );
      case 1:
        // Small square
        return Path()..addRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: size.width * 0.6,
            height: size.height * 0.6,
          ),
        );
      default:
        // Small star
        return _createStarPath(size.width * 0.4);
    }
  }

  Path _createStarPath(double radius) {
    const points = 5;
    final path = Path();
    final innerRadius = radius * 0.4;

    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : innerRadius;
      final angle = (i * pi / points) - (pi / 2);
      final x = r * cos(angle);
      final y = r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }
}

/// Mixin to easily add confetti to any StatefulWidget
mixin ConfettiMixin<T extends StatefulWidget> on State<T> {
  late final ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  /// Call this to trigger the confetti celebration
  void celebrate() {
    confettiController.play();
  }

  /// Widget to add to your Stack
  Widget buildConfettiOverlay({Alignment alignment = Alignment.topCenter}) {
    return CelebrationConfetti(
      controller: confettiController,
      alignment: alignment,
    );
  }
}
