import 'package:flutter/material.dart';

import '../../../../shared/resources/colors_manager.dart';

class TypingIndicator extends StatefulWidget {
  final bool isLight;

  const TypingIndicator({
    super.key,
    required this.isLight,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}


class _TypingIndicatorState extends State<TypingIndicator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: widget.isLight
                ? const Color(0xFFE3F2FD)
                : const Color(0xFF1E3A5F),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: Color(0xFF00BCD4),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.isLight ? Colors.white : ColorsManager.darkSurface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(index: 0),
                const SizedBox(width: 4),
                _TypingDot(index: 1),
                const SizedBox(width: 4),
                _TypingDot(index: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final int index;

  const _TypingDot({required this.index});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = widget.index * 0.2;
        final animValue = (_controller.value - delay).clamp(0.0, 1.0);
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color.lerp(
              Colors.grey[400],
              const Color(0xFF00BCD4),
              animValue,
            ),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}