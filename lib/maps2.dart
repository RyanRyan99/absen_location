import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  //List<Wisata> potsList = [];
  static double nLat = -0.225660;
  static double nLong = 100.634132;
  dynamic gab;

  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    double a = -0.225660;
    double b = 100.634132;
    nLat = a;
    nLong = b;
  }

  static LatLng _center = LatLng(nLat, nLong);

  LatLng _lastPosition = _center;

  static final CameraPosition _kGooglePlex =
  CameraPosition(target: LatLng(nLat, nLong), zoom: 14.4746);

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(nLat, nLong),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        //This marker id can be anything that uniquely identifier each marker.
        markerId: MarkerId(_lastPosition.toString()),
        position: _lastPosition,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "DETAILS",
          style: TextStyle(color: Colors.black, fontFamily: 'Roboto', fontSize: 20),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 2000.0,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                    ),
                  ),
                ],
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: ListTile(
                  title: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(30),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Nama',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontFamily: 'Open Sans'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                          ),
                          Text(
                            'Dora Grestya',
                            style:
                            TextStyle(fontSize: 14, fontFamily: 'Open Sans'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                          ),
                          Text(
                            'Check In',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontFamily: 'Open Sans'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                          ),
                          Text(
                            '09:30 10:00',
                            style:
                            TextStyle(fontSize: 14, fontFamily: 'Open Sans'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                          ),
                          Text(
                            'Check Out',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontFamily: 'Open Sans'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                          ),
                          Text(
                            '17:30 10:00',
                            style:
                            TextStyle(fontSize: 14, fontFamily: 'Open Sans'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                          ),
                          Text(
                            'Place',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontFamily: 'Open Sans'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                          ),
                          Text(
                            'Payakumbuh',
                            style:
                            TextStyle(fontSize: 14, fontFamily: 'Open Sans'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                child: GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: _kGooglePlex,
                                    onMapCreated: (GoogleMapController controller) {
                                      _controller.complete(controller);
                                      _onAddMarkerButtonPressed();
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}