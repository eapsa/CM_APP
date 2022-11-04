// ignore_for_file: non_constant_identifier_names

class Workout {
  final int id;
  final int user_id;
  final int time;
  final double distance;
  final double speed;
  final String date;
  final String description;
  final bool is_synchronized;

  Workout(this.id, this.user_id, this.time, this.distance, this.speed,
      this.date, this.description, this.is_synchronized);

  Workout.fromMapLocal(Map<String, dynamic> item)
      : id = item['id'],
        user_id = item['user_id'],
        time = item['time'],
        distance = item['distance'],
        speed = item['speed'],
        date = item['date'],
        description = item['description'],
        is_synchronized = item['is_synchronized'];

  Workout.fromMapAPI(Map<String, dynamic> item)
      : id = item['id'],
        user_id = item['user_id'],
        time = item['time'],
        distance = item['distance'],
        speed = item['speed'],
        date = item['date'],
        description = item['description'],
        is_synchronized = true;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'time': time,
      'distance': distance,
      'speed': speed,
      'date': date,
      'description': description,
      'is_synchronized': is_synchronized
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
              is_synchronized: $is_synchronized)''';
  }
}
