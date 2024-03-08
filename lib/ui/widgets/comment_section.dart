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
          // shape: const CircleBorder(),
          // this is for the splash to not go behind
          // the child's constraints
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            // TODO implement onTap()
            onTap: () {},
            // TODO implement onLongPress()
            onLongPress: () {},
            splashColor: Colors.grey,
            // TODO remove this
            child: Padding(
              // padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              padding: EdgeInsets.zero,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  filled: true,
                  hintStyle: TextStyle(
                    color: Colors.grey[700],
                  ),
                  hintText: "Email",
                  fillColor: Colors.white70,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
