import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  List<Widget> imageSliders = [];
  // created controller to display Google Maps
  late GoogleMapController _controller;
  //on below line we have set the camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(40.636839, -8.657503),
    zoom: 14,
  );

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  // list of locations to display polylines
  List<LatLng> latLen = [
    LatLng(40.636839, -8.657503),
    LatLng(40.681987, -8.600407),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // declared for loop for various locations
    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
          // added markers
          Marker(
        markerId: MarkerId(i.toString()),
        position: latLen[i],
        infoWindow: InfoWindow(
          title: 'HOTEL',
          snippet: '5 Star Hotel',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: Colors.green,
      ));
    }
    imageSliders = imgList
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
                      ],
                    )),
              ),
            ))
        .toList();
    imageSliders.add(_map(widget.workout));
  }

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
                Padding(
                    padding:
                        EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
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
          "Workout ${widget.workout.id}",
          textAlign: TextAlign.left,
        )),
        Expanded(
            //width: deviceWidth(context) * 0.4,
            child: Text(
          "${widget.workout.date.split(' ')[0]} \n ${widget.workout.date.split(' ')[1].split('.')[0]}",
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
        const FittedBox(fit: BoxFit.scaleDown, child: Text("DurationDuration")),
      ],
    );
  }

  Widget _carousel() {
    return Container(
        child: CarouselSlider(
      options: CarouselOptions(
        height: deviceHeight(context) * 0.4,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        pageViewKey: const PageStorageKey<String>('carousel_slider'),
      ),
      items: imageSliders,
    ));
  }

  Widget _map(Workout workout) {
    return Container(
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: _kGoogle,
                  mapType: MapType.normal,
                  markers: _markers,
                  polylines: _polyline,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                ),
              ],
            )),
      ),
    );
  }
}

final List<String> imgList = [
  'run.png',
];
