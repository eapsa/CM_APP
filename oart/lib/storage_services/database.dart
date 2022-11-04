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
            user_id     INTEGER,
            friend_id   INTEGER
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

  Future<List<User>> getUsers() async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps = await db.query('User');

      return List.generate(
        maps.length,
        (i) {
          return User.fromMapLocal(maps[i]);
        },
      );
    } catch (ex) {
      print(ex);
      return <User>[];
    }
  }

  Future createWorkout(Workout workout) async {
    try {
      final Database db = await getDB();
      await db.insert('Workout', workout.toMap());
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

  Future createCoordinates(Coordinate coords) async {
    try {
      final Database db = await getDB();
      await db.insert('Coordinates', coords.toMap());
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
      await db.insert('Friends', {
        'id': friend.id + 1,
        'user_id': friend.friend_id,
        'friend_id': friend.user_id
      });
    } catch (e) {
      print(e);
      return;
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<int>> getFriends(int user_id) async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps =
          await db.query('Friends', where: 'user_id = $user_id');

      return List.generate(
        maps.length,
        (i) {
          return Friend.fromMapLocal(maps[i]).friend_id;
        },
      );
    } catch (ex) {
      print(ex);
      return <int>[];
    }
  }

  Future createImage(Image image) async {
    try {
      final Database db = await getDB();
      await db.insert('Images', image.toMap());
    } catch (e) {
      print(e);
      return;
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<Image>> getImages(int workout_id) async {
    try {
      final Database db = await getDB();
      final List<Map<String, dynamic>> maps =
          await db.query('Image', where: 'workout_id = $workout_id');

      return List.generate(
        maps.length,
        (i) {
          return Image.fromMapLocal(maps[i]);
        },
      );
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
}
