import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:oart/data_types/workout.dart';

class FeedTile extends StatefulWidget {
  const FeedTile({required this.workout, super.key});
  final Workout workout;
  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(deviceWidth(context) * 0.02),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Container(
                //color: Colors.amber,
                child: Column(
              children: [
                Padding(
                    padding:
                        EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
                _name(),
                Padding(
                    padding:
                        EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
                Text(widget.workout.description),
                _carousel(),
                _status(),
                Padding(
                    padding:
                        EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
                const Divider(
                  height: 30,
                  thickness: 3.0,
                )
              ],
            ))));
  }

  Widget _name() {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: deviceWidth(context) * 0.05)),
        Expanded(
            child: Text(
          "${widget.workout.id}",
          textAlign: TextAlign.left,
        )),
        Expanded(
            //width: deviceWidth(context) * 0.4,
            child: Text(
          widget.workout.date,
          textAlign: TextAlign.right,
        )),
        Padding(padding: EdgeInsets.only(right: deviceWidth(context) * 0.05)),
      ],
    );
  }

  Widget _status() {
    return Row(
      children: [
        Expanded(child: _speed()),
        Expanded(child: _distance()),
        Expanded(child: _time()),
      ],
    );
  }

  Widget _speed() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "${widget.workout.speed.floor().toString().padLeft(2, '0')}:${((widget.workout.speed % 1) * 60).floor().toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )),
        const Text("Speed (min/km)"),
      ],
    );
  }

  Widget _distance() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              (widget.workout.distance / 1000).toStringAsFixed(2),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )),
        const Text("Distance (Km)"),
      ],
    );
  }

  Widget _time() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              "${((widget.workout.time / 1000) / 60).round().toString().padLeft(2, '0')}:${((widget.workout.time / 1000) % 60).round().toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            )),
        const Text("Duration"),
      ],
    );
  }

  Widget _carousel() {
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        pageViewKey: const PageStorageKey<String>('carousel_slider'),
      ),
      items: imageSliders,
    ));
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        item,
                        fit: BoxFit.cover,
                        width: 1000.0,
                        color: Colors.amber,
                      ),
                      // Positioned(
                      //   bottom: 0.0,
                      //   left: 0.0,
                      //   right: 0.0,
                      //   child: Container(
                      //     decoration: const BoxDecoration(
                      //       gradient: LinearGradient(
                      //         colors: [
                      //           Color.fromARGB(200, 0, 0, 0),
                      //           Color.fromARGB(0, 0, 0, 0)
                      //         ],
                      //         begin: Alignment.bottomCenter,
                      //         end: Alignment.topCenter,
                      //       ),
                      //     ),
                      //     padding: const EdgeInsets.symmetric(
                      //         vertical: 10.0, horizontal: 20.0),
                      //     child: Text(
                      //       'No. ${imgList.indexOf(item)} image',
                      //       style: const TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 20.0,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )),
            ),
          ))
      .toList();
}

final List<String> imgList = [
  'run.png',
];
