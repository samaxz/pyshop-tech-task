import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pyshop_task_camera_app/logic/providers/text_controller_provider.dart';

class CommentSection extends ConsumerWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = ref.watch(textControllerProvider);
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: Colors.grey[700],
        ),
        hintText: 'Add a caption...',
        fillColor: Colors.white,
      ),
    );
  }
}
