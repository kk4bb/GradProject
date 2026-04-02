import 'package:flutter/material.dart';

import '../../../../shared/resources/colors_manager.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLight;
  final VoidCallback onSend;
  final VoidCallback onAttachment;

  const MessageInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLight,
    required this.onSend,
    required this.onAttachment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: onAttachment,
              icon: Icon(
                Icons.attach_file,
                color: isLight ? Colors.grey[600] : Colors.grey[400],
              ),
              tooltip: 'Attach file',
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Ask a question...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: isLight ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                  style: TextStyle(
                    color: isLight ? Colors.black87 : Colors.white,
                    fontSize: 15,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}