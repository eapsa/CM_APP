// ignore_for_file: non_constant_identifier_names

class Friend {
  final int id;
  final String name;
  final String email;

  Friend(this.id, this.name, this.email);

  Friend.fromMapLocal(Map<String, dynamic> item)
      : id = item['id'],
        name = item['name'],
        email = item['email'];

  Friend.fromMapAPI(Map<String, dynamic> item)
      : id = item['id'],
        name = item['name'],
        email = item['email'];

  Map<String, Object> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }

  @override
  String toString() {
    return '(id: $id, name: $name, email: $email)';
  }
}
