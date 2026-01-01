import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ActionBubbleWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Offset position;

  const ActionBubbleWidget({
    super.key,
    required this.onTap,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 25,
      top: position.dy,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 24,
          ),
        )
            .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
            .scale(
          duration: 1500.ms,
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.05, 1.05),
        )
            .then()
            .scale(
          duration: 1500.ms,
          begin: const Offset(1.05, 1.05),
          end: const Offset(0.95, 0.95),
        ),
      )
          .animate()
          .fadeIn(duration: 200.ms)
          .scale(begin: const Offset(0.5, 0.5)),
    );
  }
}