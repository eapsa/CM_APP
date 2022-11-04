// ignore_for_file: non_constant_identifier_names

class Friend {
  final int id;
  final int user_id;
  final int friend_id;

  Friend(this.id, this.user_id, this.friend_id);

  Friend.fromMapLocal(Map<String, dynamic> item)
      : id = item['id'],
        user_id = item['user_id'],
        friend_id = item['friend_id'];

  Friend.fromMapAPIVersion1(Map<String, dynamic> item)
      : id = item['id'],
        user_id = item['user_id'],
        friend_id = item['friend_id'];

  Friend.fromMapAPIVersion2(Map<String, dynamic> item)
      : id = -1,
        user_id = -1,
        friend_id = item['friend_id'];

  Map<String, Object> toMap() {
    return {'id': id, 'user_id': user_id, 'friend_id': friend_id};
  }

  @override
  String toString() {
    return '(id: $id, user_id: $user_id, friend_id: $friend_id)';
  }
}
