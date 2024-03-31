import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pyshop_task_camera_app/logic/notifiers/user_data_notifier.dart';

class SendButton extends ConsumerWidget {
  const SendButton({super.key});

  Future<void> sendData(WidgetRef ref) async {
    final notifier = ref.read(userDataNotifierProvider.notifier);
    final userData = ref.read(userDataNotifierProvider);
    if (userData.isLoading) return;
    await notifier.uploadUserData();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                onTap: () => sendData(ref),
                onLongPress: () => sendData(ref),
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
