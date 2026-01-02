import 'package:ai_action_flow/app/config/constants/app_images.dart';
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
      right: 0,
      left: 330,
      top: 350,
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 6,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset(AppImages.floatingIconImage)
          )),
      ),
    );
  }
}