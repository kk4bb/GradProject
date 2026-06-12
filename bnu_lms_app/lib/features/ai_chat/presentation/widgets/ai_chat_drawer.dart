import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../cubit/ai_cubit.dart';
import '../cubit/ai_state.dart';
import '../screens/ai_chat_screen.dart';

class AiChatDrawer extends StatefulWidget {
  const AiChatDrawer({super.key});

  @override
  State<AiChatDrawer> createState() => _AiChatDrawerState();
}

class _AiChatDrawerState extends State<AiChatDrawer> {
  @override
  void initState() {
    super.initState();
    context.read<AICubit>().loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return Drawer(
      backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── Header & New Chat Button ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chat History',
                    style: isLight ? AppLightTextStyles.headlineLarge : AppDarkTextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const AiChatScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isLight ? Colors.white : ColorsManager.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          if (isLight)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00BCD4).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Color(0xFF00BCD4),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'New Chat',
                            style: TextStyle(
                              color: Color(0xFF00BCD4),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              color: isLight ? Colors.grey[200] : Colors.grey[800],
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 8),

            // ─── Sessions List ────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<AICubit, AIState>(
                buildWhen: (previous, current) {
                  return current is AILoadingSessions ||
                      current is AISessionsLoaded ||
                      current is AIError;
                },
                builder: (context, state) {
                  if (state is AILoadingSessions) {
                    return _buildLoadingState();
                  }

                  if (state is AIError) {
                    return _buildErrorState(state.message, isLight);
                  }

                  if (state is AISessionsLoaded) {
                    if (state.sessions.isEmpty) {
                      return _buildEmptyState(isLight);
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: state.sessions.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final session = state.sessions[index];
                        return _buildSessionItem(context, session, isLight);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Individual Session Item (Swipe-to-delete) ──────────────────────────
  Widget _buildSessionItem(BuildContext context, dynamic session, bool isLight) {
    return Dismissible(
      key: Key(session.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
      ),
      confirmDismiss: (direction) async {
        return await _confirmDelete(context);
      },
      onDismissed: (direction) {
        context.read<AICubit>().deleteSession(session.id);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          hoverColor: isLight ? Colors.grey[100] : Colors.grey[800],
          splashColor: const Color(0xFF00BCD4).withValues(alpha: 0.1),
          highlightColor: const Color(0xFF00BCD4).withValues(alpha: 0.05),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AiChatScreen(sessionId: session.id),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLight ? Colors.transparent : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: isLight ? Colors.grey[400] : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title.isNotEmpty ? session.title : 'Untitled Chat',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isLight ? Colors.black87 : Colors.white.withValues(alpha: 0.9),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(session.createdAt),
                        style: TextStyle(
                          color: isLight ? Colors.grey[500] : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isLight ? Colors.grey[300] : Colors.grey[700],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── UI States ────────────────────────────────────────────────────────────

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF00BCD4),
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildEmptyState(bool isLight) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.forum_rounded,
              size: 64,
              color: isLight ? Colors.grey[300] : Colors.grey[700],
            ),
            const SizedBox(height: 16),
            Text(
              'No previous chats',
              style: TextStyle(
                color: isLight ? Colors.grey[600] : Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a new conversation to see your history here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isLight ? Colors.grey[500] : Colors.grey[500],
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message, bool isLight) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load sessions',
              style: TextStyle(
                color: isLight ? Colors.black87 : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isLight ? Colors.grey[600] : Colors.grey[400],
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0 && now.day == date.day) {
      return 'Today';
    } else if (difference.inDays == 1 || (difference.inDays == 0 && now.day != date.day)) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Chat'),
        content: const Text(
          'This action cannot be undone. Are you sure you want to delete this conversation?',
          style: TextStyle(fontSize: 15, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
