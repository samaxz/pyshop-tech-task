import 'package:pyshop_task_camera_app/logic/providers/dio_provider.dart';
import 'package:pyshop_task_camera_app/logic/services/location_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@riverpod
LocationService locationService(LocationServiceRef ref) {
  return LocationService(
    ref.watch(dioProvider),
  );
}
