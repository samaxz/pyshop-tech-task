import 'package:camera/camera.dart';
import 'package:pyshop_task_camera_app/data/models/user_location.dart';

class UserData {
  final String text;
  final UserLocation userLocation;
  // TODO remove this
  final XFile? photo;

  const UserData({
    required this.text,
    required this.userLocation,
    this.photo,
  });

  UserData copyWith({
    String? text,
    UserLocation? userLocation,
    XFile? photo,
  }) {
    return UserData(
      text: text ?? this.text,
      userLocation: userLocation ?? this.userLocation,
      photo: photo ?? this.photo,
    );
  }

  @override
  String toString() {
    return 'UserData{text: $text, userLocation: $userLocation, photo: $photo}';
  }
}
