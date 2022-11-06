// ignore_for_file: non_constant_identifier_names

class Workout {
  final int id;
  final int user_id;
  final int time;
  final double distance;
  final double speed;
  final String date;
  final String description;
  final int is_updated;

  Workout(this.id, this.user_id, this.time, this.distance, this.speed,
      this.date, this.description, this.is_updated);

  Workout.fromMapLocal(Map<String, dynamic> item)
      : id = item['id'],
        user_id = item['user_id'],
        time = item['time'],
        distance = item['distance'],
        speed = item['speed'],
        date = item['date'],
        description = item['description'],
        is_updated = item['is_updated'];

  Workout.fromMapAPI(Map<String, dynamic> item)
      : id = item['id'],
        user_id = item['user_id'],
        time = item['time'],
        distance = item['distance'],
        speed = item['speed'],
        date = item['date'],
        description = item['description'],
        is_updated = 1;

  Map<String, Object> toMapLocal() {
    return {
      'id': id,
      'user_id': user_id,
      'time': time,
      'distance': distance,
      'speed': speed,
      'date': date,
      'description': description,
      'is_updated': is_updated
    };
  }

  Map<String, Object> toMapAPI() {
    return {
      'user_id': user_id,
      'time': time,
      'distance': distance,
      'speed': speed,
      'date': date,
      'description': description,
    };
  }

  @override
  String toString() {
    return '''(id: $id,
              user_id: $user_id,
              time: $time,
              distance: $distance,
              speed: $speed,
              date: $date,
              description: $description,
              is_updated: $is_updated)''';
  }
}
