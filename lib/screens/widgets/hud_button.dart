import 'package:flutter/material.dart';

class HudButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;
  final double size;
  final double iconSize;
  final double labelSize;

  const HudButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
    required this.size,
    required this.iconSize,
    required this.labelSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPrimary ? const Color(0xFF00E5FF) : Colors.white24,
              border: Border.all(color: const Color(0xFF00E5FF), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00E5FF).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: isPrimary ? Colors.black : Colors.white,
              size: iconSize,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: labelSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}