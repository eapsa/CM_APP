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
      bool a = true;
      for (Workout workout in apiWorkouts) {
        a = true;
        for (Workout dbWorkout in dbWorkouts) {
          print('Boas ${dbWorkout.id} - ${workout.id}');
          if (dbWorkout.id == workout.id) {
            print('Boas API');
            a = false;
            break;
          }
        }

        if (dbWorkouts.isEmpty || a) {
          print('Boas');
          await db.createWorkout(workout);
          dbWorkouts.add(workout);
        }
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
      // throw Exception('Must have an internet connection');
      return;
    }

    List<Friend> friends = await db.getFriends();
    for (Friend friend in friends) {
      if (friend.id == int.parse(friendId!)) return;
    }

    Friend friend = await api.postFriend(int.parse(id), int.parse(friendId!));
    await db.createFriend(friend);
  }

  Future<Map<int, String>> getUserNames(Set<int> userList) async {
    DatabaseService db = DatabaseService();
    Map<int, String> userNames = {};

    User? user = await db.getUser();
    List<Friend> friends = await db.getFriends();

    for (int id in userList) {
      print('Boas set');
      if (user!.id == id) userNames[id] = user.name;
      for (Friend friend in friends) {
        print('Boas Friend ${friend.toString()}');
        if (friend.id == id) userNames[id] = friend.name;
      }
    }
    for (int i = 0; i < userList.length; i++) {
      print('Boas FeedRepository ${userNames[userList.elementAt(0)]}');
    }
    return userNames;
  }

  Future<void> synchronize() async {
    NetworkInfo net = NetworkInfo();

    if (await net.getWifiIP() == null) {
      return;
    }
    APIService api = APIService();
    DatabaseService db = DatabaseService();

    List<Workout> workouts = await db.getWorkoutsToSynchronize();
    List<Map<String, dynamic>> images = <Map<String, dynamic>>[];
    List<Map<String, dynamic>> coords = <Map<String, dynamic>>[];
    for (int i = 0; i < workouts.length; i++) {
      for (Image image in await db.getImages(workouts[i].id)) {
        images.add(image.toMap());
      }
      for (Coordinate coord in await db.getCoordinates(workouts[i].id)) {
        coords.add(coord.toMap());
      }
      Workout workout =
          await api.postWorkout(workouts[i].toMapAPI(), images, coords);

      await db.updateWorkout(workouts[i].id, workout.id);
      print('Boas updated workout');
    }
  }
}
