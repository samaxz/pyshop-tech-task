import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentSection extends ConsumerStatefulWidget {
  const CommentSection({super.key});

  @override
  ConsumerState createState() => _CommentSectionState();
}

class _CommentSectionState extends ConsumerState<CommentSection> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15,
        right: 90,
        bottom: 30,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Material(
          // this is for the splash to not go behind
          // the child's constraints
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // TODO implement onTap()
            onTap: () {},
            // TODO implement onLongPress()
            onLongPress: () {},
            splashColor: Colors.grey,
            child: TextField(
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
                fillColor: Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
