import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendButton extends ConsumerWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Material(
        // to hide background color and corners
        color: Colors.transparent,
        // this is for the splash to not go behind
        // the child's constraints
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          // TODO implement onTap()
          onTap: () {},
          // TODO implement onLongPress()
          onLongPress: () {},
          splashColor: Colors.grey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            // flex: 3,
            child: CircleAvatar(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
