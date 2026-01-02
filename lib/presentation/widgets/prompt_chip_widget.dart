import 'package:flutter/material.dart';

class PromptChipWidget extends StatelessWidget {
  final String title;
  final String? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const PromptChipWidget({
    super.key,
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.blueAccent
                : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}