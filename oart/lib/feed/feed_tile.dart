import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:oart/data_types/all.dart' as data;

class FeedTile extends StatefulWidget {
  FeedTile({
    required this.workout,
    this.imageList,
    this.coordList,
    this.userName,
    super.key,
  });
  final data.Workout workout;
  List<data.Image>? imageList;
  List<data.Coordinate>? coordList;
  String? userName;
  @override
  State<FeedTile> createState() => _FeedTileState();
}

class _FeedTileState extends State<FeedTile> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  List<Widget> imageSliders = [];

  @override
  initState() {
    super.initState();

    if (widget.imageList!.isEmpty) {
      imageSliders = imgList
          .map(
            (item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 11, 2, 45),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Image.asset(
                            item,
                            fit: BoxFit.cover,
                            width: 1000.0,
                          ),
                        ],
                      ))),
            ),
          )
          .toList();
    } else {
      imageSliders = widget.imageList!
          .map((item) => Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.memory(
                          base64.decode(item.image),
                          fit: BoxFit.cover,
                          width: 1000.0,
                          // color: Colors.amber,
                        ),
                      ],
                    )),
              ))
          .toList();
    }
    // imageSliders.add(_map(widget.workout));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(deviceWidth(context) * 0.02),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            child: Container(
                color: const Color.fromARGB(50, 255, 255, 255),
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: deviceWidth(context) * 0.05)),
                    _name(),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: deviceWidth(context) * 0.05)),
                    Text(widget.workout.description),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: deviceWidth(context) * 0.05)),
                    _carousel(),
                    _status(),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: deviceWidth(context) * 0.05)),
                    // Divider(
                    //   color: Theme.of(context).colorScheme.primary,
                    //   height: 30,
                    //   thickness: 5.0,
                    // )
                  ],
                ))));
  }

  Widget _name() {
    return Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: deviceWidth(context) * 0.05,
                    bottom: deviceWidth(context) * 0.01),
                child: Text(
                  "${widget.userName}'s workout",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(left: deviceWidth(context) * 0.05),
                child: Text(
                  "${widget.workout.date.split('T')[0]} ${widget.workout.date.split('T')[1].split('.')[0]}",
                  textAlign: TextAlign.left,
                )),
          ],
        ));
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
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${widget.workout.speed.floor().toString().padLeft(2, '0')}:${((widget.workout.speed % 1) * 60).floor().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Speed (min/km)")),
      ],
    );
  }

  Widget _distance() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  (widget.workout.distance / 1000).toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Distance (Km)")),
      ],
    );
  }

  Widget _time() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${((widget.workout.time / 1000) / 60).round().toString().padLeft(2, '0')}:${((widget.workout.time / 1000) % 60).round().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Duration")),
      ],
    );
  }

  Widget _carousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: deviceHeight(context) * 0.4,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        pageViewKey: const PageStorageKey<String>('carousel_slider'),
      ),
      items: imageSliders,
    );
  }
}

final List<String> imgList = [
  'run.png',
];
