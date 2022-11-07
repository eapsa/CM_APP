import '../data_types/all.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  final String databaseName = 'database.db';

  Future<Database> getDB() async {
    String path = await getDatabasesPath();

    return openDatabase(
      join(path, databaseName),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE User (
            id          INTEGER,
            name        TEXT,
            email       TEXT,
            password    TEXT
          );
          ''');

        await db.execute('''
          CREATE TABLE Workout (
            id          INTEGER,
            user_id     INTEGER, 
            time        INTEGER,
            distance    REAL,
            speed       REAL,
            date        TEXT,
            description TEXT,
            is_updated  INTEGER
          );
          ''');

        await db.execute('''
          CREATE TABLE Coordinates (
            id          INTEGER,
            workout_id  INTEGER,
            latitude    REAL,
            longitude   REAL
          );
          ''');

        await db.execute('''
          CREATE TABLE Friends (
            id          INTEGER,
            name        TEXT,
            email       TEXT
          );
          ''');

        await db.execute('''
          CREATE TABLE Images (
            id          INTEGER,
            workout_id  INTEGER,
            image       TEXT,
            name        TEXT
          );
          ''');
      },
      version: 1,
    );
  }

  Future createUser(User user) async {
    try {
      final Database db = await getDB();
      await db.insert('User', user.toMap());
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<User?> getUser() async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps = await db.query('User');

      return User.fromMapLocal(maps[0]);
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future createWorkout(Workout workout) async {
    try {
      final Database db = await getDB();
      await db.insert('Workout', workout.toMapLocal());
    } catch (e) {
      print(e);
      return;
    }
  }

  Future updateWorkout(int workoutId, int newId) async {
    try {
      final Database db = await getDB();
      await db.update('Workout', {'id': newId}, where: 'id = $workoutId');

      await db.update('Images', {'workout_id': newId},
          where: 'workout_id = $workoutId');

      await db.update('Coordinates', {'workout_id': newId},
          where: 'workout_id = $workoutId');
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<List<Workout>> getWorkouts() async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps = await db.query('Workout');

      return List.generate(
        maps.length,
        (i) {
          return Workout.fromMapLocal(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return <Workout>[];
    }
  }

  Future<List<Workout>> getWorkoutsToSynchronize() async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps =
          await db.query('Workout', where: 'id < 0');

      return List.generate(
        maps.length,
        (i) {
          return Workout.fromMapLocal(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return <Workout>[];
    }
  }

  Future createCoordinates(Coordinate coords) async {
    try {
      final Database db = await getDB();
      int? coordsId = await getCoordinatesCount();
      await db.insert('Coordinates', {
        'id': coordsId,
        'workout_id': coords.workout_id,
        'latitude': coords.latitude,
        'longitude': coords.longitude
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<Coordinate>> getCoordinates(int workout_id) async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps =
          await db.query('Coordinates', where: 'workout_id = $workout_id');

      return List.generate(
        maps.length,
        (i) {
          return Coordinate.fromMapLocal(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return <Coordinate>[];
    }
  }

  Future createFriend(Friend friend) async {
    try {
      final Database db = await getDB();
      await db.insert('Friends', friend.toMap());
    } catch (e) {
      print(e);
      return;
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<Friend>> getFriends() async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps = await db.query('Friends');

      return List.generate(
        maps.length,
        (i) {
          return Friend.fromMapLocal(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return <Friend>[];
    }
  }

  Future createImage(Image image) async {
    try {
      final Database db = await getDB();
      Image smallImage;

      String base64 = image.image;
      int? imageId = await getImagesCount();

      for (int i = 0; i < 9; i++) {
        smallImage = Image.fromMapLocal({
          'id': imageId! + i,
          'workout_id': image.workout_id,
          'name': '$i${image.name}',
          'image': image.image.substring(i * (image.image.length / 10).floor(),
              (i + 1) * (image.image.length / 10).floor()),
        });
        await db.insert('Images', smallImage.toMap());
      }
      smallImage = Image.fromMapLocal({
        'id': imageId! + 9,
        'workout_id': image.workout_id,
        'name': '9${image.name}',
        'image': image.image.substring(
            9 * (image.image.length / 10).floor(), image.image.length),
      });
      await db.insert('Images', smallImage.toMap());
    } catch (e) {
      print(e);
      return;
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<Image>> getImages(int workout_id) async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps = await db.query('Images',
          where: 'workout_id = $workout_id', orderBy: 'id ASC');

      List<Image> images = <Image>[];
      for (int i = 0; i < maps.length / 10; i++) {
        String base64Value = "";
        for (int j = 0; j < 10; j++) {
          base64Value += maps[i * 10 + j]['image'];
        }
        images.add(Image.fromMapLocal({
          'id': maps[i * 10]['id'],
          'name': (maps[i * 10]['name'] as String)
              .substring(1, (maps[i * 10]['name'] as String).length),
          'workout_id': maps[i]['workout_id'],
          'image': base64Value
        }));
      }
      return images;
    } catch (ex) {
      print(ex);
      return <Image>[];
    }
  }

  Future deleteTables() async {
    try {
      final Database db = await getDB();
      await db.execute('DELETE FROM Images;');
      await db.execute('DELETE FROM Coordinates;');
      await db.execute('DELETE FROM Friends;');
      await db.execute('DELETE FROM Workout;');
      await db.execute('DELETE FROM User;');
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<int?> getWorkoutCount() async {
    try {
      final Database db = await getDB();
      return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM Workout;'));
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<int?> getImagesCount() async {
    try {
      final Database db = await getDB();
      return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM Images;'));
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<int?> getCoordinatesCount() async {
    try {
      final Database db = await getDB();
      return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM Coordinates;'));
    } catch (e) {
      print(e);
    }
    return null;
  }
}
