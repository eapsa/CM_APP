class User {
  final int id;
  final String name;
  final String email;
  final String password;

  User(this.id, this.name, this.email, this.password);

  User.fromMapLocal(Map<String, dynamic> item)
      : id = item['id'],
        name = item['name'],
        email = item['email'],
        password = item['password'];

  User.fromMapAPI(Map<String, dynamic> item)
      : id = item['id'],
        name = item['name'],
        email = item['email'],
        password = "***";

  Map<String, Object> toMap() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }

  @override
  String toString() {
    return '(id: $id, name: $name, email: $email, password: $password)';
  }
}
