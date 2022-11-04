// ignore_for_file: non_constant_identifier_names

class Image {
  final int id;
  final int workout_id;
  final String name;
  final String image;

  Image(this.id, this.workout_id, this.image, this.name);

  Image.fromMapLocal(Map<String, dynamic> item)
      : id = item['id'],
        workout_id = item['workout_id'],
        name = item['name'],
        image = item['image'];

  Image.fromMapAPI(Map<String, dynamic> item)
      : id = -1,
        workout_id = item['workout_id'],
        name = item['name'],
        image = item['image'];

  Map<String, Object> toMap() {
    return {'id': id, 'workout_id': workout_id, 'name': name, 'image': image};
  }

  @override
  String toString() {
    return '''(id: $id, workout_id: $workout_id, name: $name, image: $image)''';
  }
}
