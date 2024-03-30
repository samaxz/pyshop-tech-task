import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentSection extends ConsumerStatefulWidget {
  const CommentSection({super.key});

  @override
  ConsumerState createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
