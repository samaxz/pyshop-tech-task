import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pyshop_task_camera_app/logic/notifiers/user_data_notifier.dart';

class SendButton extends ConsumerStatefulWidget {
  const SendButton({super.key});

  @override
  ConsumerState createState() => _SendButtonState();
}

class _SendButtonState extends ConsumerState<SendButton> {
  bool pressed = false;

  Future<void> sendData() async {
    // closes keyboard if it's open
    FocusManager.instance.primaryFocus?.unfocus();

    if (pressed) return;
    setState(() => pressed = true);

    // wait for a sec before calling the method again
    await Future.delayed(
      const Duration(seconds: 1),
      () async {
        final notifier = ref.read(userDataNotifierProvider.notifier);
        await notifier.sendUserData();
        setState(() => pressed = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // this makes the circle avatar to take full size
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          // this makes the splash take full icon size
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: sendData,
                onLongPress: sendData,
                splashColor: pressed ? Colors.transparent : Colors.grey,
                child: const Icon(Icons.send_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
