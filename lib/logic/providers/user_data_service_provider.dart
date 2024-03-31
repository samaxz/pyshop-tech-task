import 'package:pyshop_task_camera_app/logic/providers/dio_provider.dart';
import 'package:pyshop_task_camera_app/logic/services/user_data_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_data_service_provider.g.dart';

@riverpod
UserDataService userDataService(UserDataServiceRef ref) {
  return UserDataService(
    ref.watch(dioProvider),
  );
}
