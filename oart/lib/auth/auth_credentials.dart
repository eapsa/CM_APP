class AuthCredentials {
  final String? username;
  final String email;
  final String? password;
  int? userId;

  AuthCredentials({
    this.password,
    this.userId,
    this.username,
    required this.email,
  });
}
