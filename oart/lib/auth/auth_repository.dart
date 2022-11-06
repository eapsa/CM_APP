import 'package:oart/storage_services/api_service.dart';
import 'package:oart/storage_services/database.dart';

import '../data_types/all.dart';

class AuthRepository {
  Future<int> load() async {
    DatabaseService db = DatabaseService();
    List<User> user = await db.getUsers();

    if (user.isEmpty) {
      throw Exception("not signed in");
    }

    return user[0].id;
  }

  Future<int> login({
    required String email,
    required String password,
  }) async {
    APIService api = APIService();
    User user = await api.getUserByCredentials(email, password);

    DatabaseService db = DatabaseService();
    User dbUser = User.fromMapLocal({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'password': password
    });
    await db.createUser(dbUser);

    return user.id;
  }

  Future<int> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    APIService api = APIService();
    User user = await api.postUser(username, email, password);

    DatabaseService db = DatabaseService();
    User dbUser = User.fromMapLocal({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'password': password
    });
    await db.createUser(dbUser);
    return user.id;
  }

  Future<void> signOut() async {
    DatabaseService db = DatabaseService();
    await db.deleteTables();
  }

  Future<void> synchronize() async {
    print('Boas Funcao de sincronizacao');
    APIService api = APIService();
    DatabaseService db = DatabaseService();

    List<Workout> workouts = await db.getWorkoutsToSynchronize();
    List<Map<String, dynamic>> images = <Map<String, dynamic>>[];
    List<Map<String, dynamic>> coords = <Map<String, dynamic>>[];
    print('Boas Funcao de sincronizacao ${workouts.length}');
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
    }
  }
}
