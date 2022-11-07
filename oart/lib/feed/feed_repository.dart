import 'package:network_info_plus/network_info_plus.dart';
import 'package:oart/data_types/all.dart';
import 'package:oart/storage_services/api_service.dart';
import 'package:oart/storage_services/database.dart';

class FeedRepository {
  Future<List<Workout>> getWorkouts() async {
    APIService api = APIService();
    DatabaseService db = DatabaseService();
    NetworkInfo net = NetworkInfo();

    if (await net.getWifiIP() == null) {
      List<Workout> workouts = await db.getWorkouts();
      workouts.sort((a, b) => b.date.compareTo(a.date));
      return workouts;
    } else {
      User? user = await db.getUser();

      List<Workout> apiWorkouts = await api.getWorkouts(user!.id);
      List<Workout> dbWorkouts = await db.getWorkouts();

      for (Workout workout in apiWorkouts) {
        for (Workout dbWorkout in dbWorkouts) {
          print('Boas ${dbWorkout.id} - ${workout.id}');
          if (dbWorkout.id == workout.id) {
            print('Boas API');
            break;
          }
          await db.createWorkout(workout);
        }
        if (dbWorkouts.isEmpty) await db.createWorkout(workout);
      }
      apiWorkouts.sort((a, b) => b.date.compareTo(a.date));
      return apiWorkouts;
    }
  }

  Future<Map<int, List<Image>>> getImages(List<int> idList) async {
    APIService api = APIService();
    DatabaseService db = DatabaseService();
    NetworkInfo net = NetworkInfo();

    Map<int, List<Image>> dbImages = {};
    for (int id in idList) {
      dbImages[id] = await db.getImages(id);
    }

    if (await net.getWifiIP() == null) {
      return dbImages;
    } else {
      List<Image> apiTemp = <Image>[];
      for (int id in idList) {
        if (dbImages[id]!.isEmpty) {
          apiTemp = await api.getWorkoutImages(id);

          for (Image image in apiTemp) {
            await db.createImage(image);
          }

          dbImages[id] = apiTemp;
        }
      }

      return dbImages;
    }
  }

  Future<Map<int, List<Coordinate>>> getCoordinates(List<int> idList) async {
    APIService api = APIService();
    DatabaseService db = DatabaseService();
    NetworkInfo net = NetworkInfo();

    Map<int, List<Coordinate>> dbCoordinates = {};
    for (int id in idList) {
      dbCoordinates[id] = await db.getCoordinates(id);
    }

    if (await net.getWifiIP() == null) {
      return dbCoordinates;
    } else {
      List<Coordinate> apiTemp = <Coordinate>[];
      for (int id in idList) {
        if (dbCoordinates[id]!.isEmpty) {
          apiTemp = await api.getWorkoutCoordinates(id);
          for (Coordinate coordinate in apiTemp) {
            await db.createCoordinates(coordinate);
          }
          dbCoordinates[id] = apiTemp;
        }
      }

      return dbCoordinates;
    }
  }

  Future<void> addFriend(String id, String? friendId) async {
    APIService api = APIService();
    DatabaseService db = DatabaseService();
    NetworkInfo net = NetworkInfo();

    if (await net.getWifiIP() == null) {
      throw Exception('Must have an internet connection');
    }

    Friend friend = await api.postFriend(int.parse(id), int.parse(friendId!));
    await db.createFriend(friend);
  }
}
