import 'package:network_info_plus/network_info_plus.dart';
import 'package:oart/data_types/all.dart';
import 'package:oart/storage_services/api_service.dart';
import 'package:oart/storage_services/database.dart';

class FeedRepository {
  Future<List<Workout>> getPage() async {
    APIService api = APIService();
    DatabaseService db = DatabaseService();
    NetworkInfo net = NetworkInfo();

    if (await net.getWifiIP() == null) {
      return await db.getWorkouts();
    } else {
      User user = await db.getUser();

      List<Workout> apiWorkouts = await api.getWorkouts(user.id);
      List<Workout> dbWorkouts = await db.getWorkouts();

      for (Workout workout in apiWorkouts) {
        if (dbWorkouts.contains(workout)) continue;
        await db.createWorkout(workout);
      }

      return apiWorkouts;
    }
  }

  Future<void> addFriend(int id, String friendId) async {}
}
