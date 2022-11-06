import 'package:oart/data_types/all.dart';

class FeedRepository {
  Future<List<Workout>> getPage() async {
    return [
      Workout(1, 1, 1, 1, 1, "00/00/0000",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit", 1),
      Workout(1, 1, 1, 1, 1, "00/00/0000", "", 1),
      Workout(1, 1, 1, 1, 1, "00/00/0000", "", 1),
      Workout(1, 1, 1, 1, 1, "00/00/0000", "", 1)
    ];
  }

  Future<void> addFriend(int id, String friendId) async {}
}
