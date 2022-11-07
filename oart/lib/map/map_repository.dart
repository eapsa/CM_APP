import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:oart/map/workout.dart' as map;
import 'package:oart/storage_services/api_service.dart';
import 'package:oart/storage_services/database.dart';

import '../data_types/all.dart';

class MapRepository {
  Future<void> saveWorkout(map.Workout workout) async {
    APIService api = APIService();
    DatabaseService db = DatabaseService();
    DateTime date = DateTime.now();

    NetworkInfo net = NetworkInfo();
    if (await net.getWifiIP() == null) {
      int? tempWorkoutId = await db.getWorkoutCount();
      tempWorkoutId = -(tempWorkoutId!);

      print('Temporary identifier = $tempWorkoutId');

      Workout serviceWorkout = Workout(
          tempWorkoutId,
          workout.userId!,
          workout.time!,
          workout.distance,
          workout.speed,
          date.toString().replaceAll(' ', 'T'),
          workout.description!,
          0);

      await db.createWorkout(serviceWorkout);

      workout.images ??= <String>[];
      print('Images length = ${workout.images!.length}');
      for (int i = 0; i < workout.images!.length; i++) {
        await db.createImage(Image.fromMapLocal({
          'id': -1,
          'workout_id': tempWorkoutId,
          'name':
              '${workout.name!.replaceAll('_', '-')}$i _${serviceWorkout.date}',
          'image': workout.images![i]
        }));
      }

      workout.coords ??= <LatLng>[];
      print('Coordinates length = ${workout.coords!.length}');
      for (int i = 0; i < workout.coords!.length; i++) {
        await db.createCoordinates(Coordinate.fromMapLocal({
          'id': -1,
          'workout_id': tempWorkoutId,
          'latitude': workout.coords![i].latitude,
          'longitude': workout.coords![i].longitude
        }));
      }

      //TESTING

      // List<Workout> works = await db.getWorkoutsToSynchronize();
      // for (int i = 0; i < works.length; i++) {
      //   print('Before1 ${works[i].toString()}');
      // }

      // List<Workout> worksAll = await db.getWorkouts();
      // for (int i = 0; i < worksAll.length; i++) {
      //   print('Before2 ${worksAll[i].toString()}');
      // }

      // List<Image> imgs = await db.getImages(tempWorkoutId);
      // for (int i = 0; i < imgs.length; i++) {
      //   print('Before ${imgs[i].name}');
      // }

      // List<Coordinate> coords = await db.getCoordinates(tempWorkoutId);
      // for (int i = 0; i < coords.length; i++) {
      //   print('Before (${coords[i].latitude},${coords[i].longitude})');
      // }

      // int newId = -1001;
      // await db.updateWorkout(tempWorkoutId, newId);

      // works = await db.getWorkouts();
      // for (int i = 0; i < works.length; i++) {
      //   if (works[i].id == newId) print('After ${works[i].toString()}');
      // }

      // imgs = await db.getImages(newId);
      // for (int i = 0; i < imgs.length; i++) {
      //   print('After ${imgs[i].name}');
      // }

      // coords = await db.getCoordinates(newId);
      // for (int i = 0; i < coords.length; i++) {
      //   print('After (${coords[i].latitude},${coords[i].longitude})');
      // }
    } else {
      Workout serviceWorkout = Workout(
          -1,
          workout.userId!,
          workout.time!,
          workout.distance,
          workout.speed,
          date.toString(),
          workout.description!,
          0);

      List<Map<String, String>> images = <Map<String, String>>[];
      if (workout.images != null) {
        for (int i = 0; i < workout.images!.length; i++) {
          images.add({
            'name':
                '${workout.name!.replaceAll('_', '-')}_${serviceWorkout.date}',
            'image': workout.images![i]
          });
        }
      }

      List<Map<String, double>> coordinates = <Map<String, double>>[];
      if (workout.coords != null) {
        for (int i = 0; i < workout.coords!.length; i++) {
          coordinates.add({
            'latitude': workout.coords![i].latitude,
            'longitude': workout.coords![i].longitude
          });
        }
      }

      Workout registered =
          await api.postWorkout(serviceWorkout.toMapAPI(), images, coordinates);

      Workout dbWorkout = Workout.fromMapAPI(registered.toMapLocal());
      await db.createWorkout(dbWorkout);

      List<Coordinate> APIcoords =
          await api.getWorkoutCoordinates(registered.id);
      for (Coordinate coord in APIcoords) {
        await db.createCoordinates(coord);
      }

      List<Image> APIimages = await api.getWorkoutImages(registered.id);
      for (Image image in APIimages) {
        print(image.name);
        await db.createImage(image);
      }

      //TESTING

      // List<Workout> works = await db.getWorkouts();
      // for (int i = 0; i < works.length; i++) {
      //   if (works[i].id == registered.id) print(works[i].toString());
      // }

      // List<Image> imgs = await db.getImages(registered.id);
      // for (int i = 0; i < imgs.length; i++) {
      //   if (APIimages[i].name == imgs[i].name) print('Image names are equal');
      //   if (APIimages[i].image == imgs[i].image) {
      //     print('Image ares equal');
      //   } else {
      //     print('Nothing is equal');
      //   }
      // }

      // List<Coordinate> coords = await db.getCoordinates(registered.id);
      // for (int i = 0; i < imgs.length; i++) {
      //   print('(${coords[i].latitude},${coords[i].longitude})');
      // }
    }
  }
}
