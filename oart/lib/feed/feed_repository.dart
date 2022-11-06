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
      return await db.getWorkouts();
    } else {
      User? user = await db.getUser();

      List<Workout> apiWorkouts = await api.getWorkouts(user!.id);
      List<Workout> dbWorkouts = await db.getWorkouts();

      for (Workout workout in apiWorkouts) {
        if (dbWorkouts.contains(workout)) continue;
        await db.createWorkout(workout);
      }

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
      Map<int, List<Image>> images = {};
      List<Image> apiTemp = <Image>[];
      for (int id in idList) {
        apiTemp = await api.getWorkoutImages(id);

        if (dbImages[id]!.isEmpty) {
          for (Image image in apiTemp) {
            await db.createImage(image);
          }
        }

        images[id] = apiTemp;
      }

      return images;
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
      Map<int, List<Coordinate>> coordinates = {};
      List<Coordinate> apiTemp = <Coordinate>[];
      for (int id in idList) {
        apiTemp = await api.getWorkoutCoordinates(id);

        if (dbCoordinates[id]!.isEmpty) {
          for (Coordinate coordinate in apiTemp) {
            await db.createCoordinates(coordinate);
          }
        }
        coordinates[id] = apiTemp;
      }

      return coordinates;
    }
  }

  Future<void> addFriend(String id, String? friendId) async {}
}
