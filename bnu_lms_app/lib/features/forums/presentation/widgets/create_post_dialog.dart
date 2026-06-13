import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';
import '../cubit/forums_cubit.dart';
import '../cubit/forums_state.dart';

/// A dialog that allows creating a new discussion topic (Instructor/Doctor)
/// or a post within an existing discussion (Student/TA).
///
/// Pass [courseId] when the action is "create discussion" (no discussionId).
/// Pass [discussionId] + [discussionTitle] when the action is "create post".
class CreatePostDialog extends StatefulWidget {
  /// Used when creating a new discussion topic.
  final int? courseId;

  /// Used when creating a post inside an existing discussion.
  final int? discussionId;
  final String? discussionTitle;

  /// Label shown in the AppBar / title of the dialog.
  final String label;

  const CreatePostDialog({
    super.key,
    this.courseId,
    this.discussionId,
    this.discussionTitle,
    this.label = 'New Discussion',
  }) : assert(
          courseId != null || (discussionId != null && discussionTitle != null),
          'Provide either courseId (for a new discussion) or discussionId+title (for a new post).',
        );

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext ctx) async {
    final text = _controller.text.trim();
    final desc = _descController.text.trim();
    if (text.isEmpty) return;

    setState(() => _submitting = true);

    final cubit = ctx.read<ForumsCubit>();

    if (widget.courseId != null) {
      await cubit.createDiscussion(widget.courseId!, text, desc);
    } else {
      await cubit.createPost(widget.discussionId!, widget.discussionTitle!, text);
    }

    if (ctx.mounted) Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context, listen: false).isLightTheme();
    final hintText = widget.courseId != null
        ? 'Enter a topic title for the new discussion…'
        : 'Write your post here…';

    return BlocListener<ForumsCubit, ForumsState>(
      listener: (ctx, state) {
        if (state is ForumsError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: ColorsManager.red),
          );
          setState(() => _submitting = false);
        }
      },
      child: AlertDialog(
        backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                autofocus: true,
                maxLines: widget.courseId != null ? 1 : 4,
                style: TextStyle(color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(color: ColorsManager.grayMedium),
                  filled: true,
                  fillColor: isLight ? const Color(0xFFF5F7FA) : ColorsManager.darkBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
              if (widget.courseId != null) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  style: TextStyle(color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter discussion body/details...',
                    hintStyle: TextStyle(color: ColorsManager.grayMedium),
                    filled: true,
                    fillColor: isLight ? const Color(0xFFF5F7FA) : ColorsManager.darkBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ],
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: _submitting ? null : () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: ColorsManager.grayMedium)),
          ),
          ElevatedButton(
            onPressed: _submitting ? null : () => _submit(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: _submitting
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('Post', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

/// Helper to show the dialog without boilerplate.
void showCreatePostDialog(
  BuildContext context, {
  int? courseId,
  int? discussionId,
  String? discussionTitle,
  String label = 'New Discussion',
}) {
  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<ForumsCubit>(),
      child: CreatePostDialog(
        courseId: courseId,
        discussionId: discussionId,
        discussionTitle: discussionTitle,
        label: label,
      ),
    ),
  );
}
