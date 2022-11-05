import 'package:google_maps_flutter/google_maps_flutter.dart';

class Workout {
  int? time;
  double distance;
  double speed;
  String? description;
  List<String>? images;
  List<LatLng>? coords;
  int? userId;
  String? name;
  Workout({
    this.time = 0,
    this.distance = 0,
    this.speed = 0,
    this.description,
    this.images,
    this.coords,
    this.userId,
    this.name,
  });
}
