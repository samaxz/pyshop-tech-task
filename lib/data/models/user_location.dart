import 'package:json_annotation/json_annotation.dart';

part 'user_location.g.dart';

@JsonSerializable()
class UserLocation {
  final double latitude;
  final double longitude;

  const UserLocation({
    required this.latitude,
    required this.longitude,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);

  @override
  String toString() {
    return 'UserLocation{latitude: $latitude, longitude: $longitude}';
  }
}
