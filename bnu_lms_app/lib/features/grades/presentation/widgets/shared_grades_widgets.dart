import 'package:flutter/material.dart';

class HorizontalProgressBar extends StatelessWidget {
  final double current;
  final double max;
  final Color color;
  final Color backgroundColor;

  const HorizontalProgressBar({
    Key? key,
    required this.current,
    required this.max,
    required this.color,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = max > 0 ? (current / max) : 0;
    if (percentage > 1.0) percentage = 1.0;
    if (percentage < 0.0) percentage = 0.0;

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class PillBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final bool hasDot;

  const PillBadge({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.hasDot = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
