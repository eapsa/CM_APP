// ignore_for_file: non_constant_identifier_names

class Coordinate {
  final int id;
  final int workout_id;
  final double latitude;
  final double longitude;

  Coordinate(this.id, this.workout_id, this.latitude, this.longitude);

  Coordinate.fromMapLocal(Map<String, dynamic> item)
      : id = item['id'],
        workout_id = item['workout_id'],
        latitude = item['latitude'],
        longitude = item['longitude'];

  Coordinate.fromMapAPI(Map<String, dynamic> item)
      : id = -1,
        workout_id = -1,
        latitude = item['latitude'],
        longitude = item['longitude'];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'workout_id': workout_id,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  @override
  String toString() {
    return '(id: $id, workout_id: $workout_id, latitude: $latitude, longitude: $longitude)';
  }
}
