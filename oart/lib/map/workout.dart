import 'package:google_maps_flutter/google_maps_flutter.dart';

class Workout {
  int? time;
  double distance;
  double? speed;
  String? description;
  List<String>? images;
  List<LatLng>? coords;
  int? userId;
  Workout({
    this.time,
    this.distance = 0,
    this.speed,
    this.description,
    this.images,
    this.coords,
    this.userId,
  });
}
