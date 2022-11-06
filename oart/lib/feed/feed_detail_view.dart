import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oart/data_types/workout.dart';
import 'package:oart/feed/feed_navigator_cubit.dart';

class FeedDetailView extends StatefulWidget {
  const FeedDetailView({super.key});
  @override
  State<FeedDetailView> createState() => _FeedDetailView();
}

class _FeedDetailView extends State<FeedDetailView> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  late GoogleMapController mapController;

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
  }

  @override
  Widget build(BuildContext context) {
    final workout = context.read<FeedNavigatorCubit>().workout;
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout ${workout.id}"),
      ),
      body: _feedDetail(workout),
    );
  }

  Widget _feedDetail(Workout workout) {
    return SingleChildScrollView(
        //color: Colors.amber,
        child: Column(children: [
      _map(workout),
      Padding(padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
      _name(workout),
      Padding(padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
      Text(workout.description),
      _status(workout),
      Padding(padding: EdgeInsets.only(bottom: deviceWidth(context) * 0.05)),
      _carousel(),
    ]));
  }

  Widget _name(Workout workout) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: deviceWidth(context) * 0.05)),
        Expanded(
            child: Text(
          workout.date.split('.')[0],
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        )),
        Padding(padding: EdgeInsets.only(right: deviceWidth(context) * 0.05)),
      ],
    );
  }

  Widget _status(Workout workout) {
    return Row(
      children: [
        Expanded(child: _speed(workout)),
        Expanded(child: _distance(workout)),
        Expanded(child: _time(workout)),
      ],
    );
  }

  Widget _speed(Workout workout) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${workout.speed.floor().toString().padLeft(2, '0')}:${((workout.speed % 1) * 60).floor().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Speed (min/km)")),
      ],
    );
  }

  Widget _distance(Workout workout) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  (workout.distance / 1000).toStringAsFixed(2),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Distance (Km)")),
      ],
    );
  }

  Widget _time(Workout workout) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${((workout.time / 1000) / 60).round().toString().padLeft(2, '0')}:${((workout.time / 1000) % 60).round().toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ))),
        const FittedBox(fit: BoxFit.scaleDown, child: Text("Duration")),
      ],
    );
  }

  Widget _map(Workout workout) {
    late GoogleMapController mapController;

    LatLng center = const LatLng(45.521563, -122.677433);

    void onMapCreated(GoogleMapController controller) {
      mapController = controller;
    }

    return SizedBox(
      width: deviceWidth(context), // or use fixed size like 200
      height: deviceHeight(context) * 0.5,
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
                    ],
                  )),
            ),
          ))
      .toList();
}

final List<String> imgList = [
  'run.png',
];
