import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendButton extends ConsumerWidget {
  const SendButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      // this makes the circle avatar to take full size
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CircleAvatar(
          // this makes the splash take full icon size
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                // TODO implement onTap()
                onTap: () {},
                // TODO implement onLongPress()
                onLongPress: () {},
                splashColor: Colors.grey,
                child: const Icon(Icons.send_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
