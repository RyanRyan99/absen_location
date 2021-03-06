import 'dart:async';
import 'package:absenlocation/map/bloc/bloc.dart';
import 'package:absenlocation/map/range_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'map/bloc/maps_bloc.dart';


class HomePage extends StatefulWidget {
  final bool isRadiusFixed;
  HomePage({@required this.isRadiusFixed}) : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _LocationLong = "";
  String _LocationLat = "";

  void _getPosisiLokasi() async {
    final posisi = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    print(posisi);
    setState(() {
      _LocationLong = "${posisi.longitude}";
      _LocationLat = "${posisi.latitude}";
      _marker.add(Marker(
          markerId: MarkerId('myMarker'),
          draggable: true,
          onTap: (){
            print('Marker Tapped');
          },
          position: LatLng(posisi.latitude, posisi.longitude)
      ));
    });
  }

  DateTime time_now =new DateTime.now();
  void time() async {
    DateTime time_now =new DateTime.now();
    setState(() {
      print(time_now);
    });
  }
  final controllerLong = new TextEditingController();
  final controllerLat = new TextEditingController();
  final controllerTime = new TextEditingController();
  void insertData(){
    var url = "https://bintang-niagajaya.000webhostapp.com/Absen_GPS/api_insert.php";
    http.post(url, body: {
      "longitude": controllerLong.text = _LocationLong,
      "latitude": controllerLat.text = _LocationLat,
      "timeinout": controllerTime.text = DateTime.now().toString(),
    });
  }
  //Maps
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _Kbintang = CameraPosition(
      bearing: 106.861746,
      target: LatLng(-6.471297, 106.861746),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );

  final Set<Marker> _marker = {};
  final Set<Circle> _circle = {};
  double _radius = 50.0;
  double _zoom = 18.0;
  bool _isRadiusFixed = false;
  bool _showFixedGpsIcon = false;
  MapsBloc _mapsBloc;
  static const LatLng _center = const LatLng(-6.471446, 106.86158);
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.hybrid;

  @override
  void initState() {
    super.initState();
    _marker.add(Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      onTap: (){
        print('Marker Tapped');
      },
      position: LatLng(-6.4714692, 106.861746)
    ));
    _mapsBloc = BlocProvider.of<MapsBloc>(context);
  }

  Widget _GoogleMapsWidget(MapsState state){
    return GoogleMap(
      onTap: (LatLng location){
        if(_isRadiusFixed){
          _mapsBloc.add(GenerateMarkerToCompareLocation(
            mapPosition: location,
            radiusLocation: _lastMapPosition,
            radius: _radius,
          ));
        }
      },
      //onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: _zoom,
      ),
      circles: _circle,
      markers: _marker,
      onCameraIdle: (){
        if(_isRadiusFixed != true)
          _mapsBloc.add(GenerateMarkerWithRadius(
            lastPosition: _lastMapPosition, radius: _radius,
          ));
      },
      mapType: _currentMapType,
    );
  }

  //EndMaps
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: new Stack(
        children: <Widget>[
          Container(
            child: BlocListener(
              bloc: _mapsBloc,
              listener: (BuildContext context, MapsState state){
                if(state is LocationUserfound){
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _lastMapPosition = LatLng(state.locationModel.lat, state.locationModel.long);
                  //
                }
                if (state is MarkerWithRadius) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _showFixedGpsIcon = false;

                  if (_marker.isNotEmpty) {
                    _marker.clear();
                  }
                  if (_circle.isNotEmpty) {
                    _circle.clear();
                  }
                  _marker.add(state.raidiusModel.marker);
                  _circle.add(state.raidiusModel.circle);
                }
                if (state is RadiusFixedUpdate) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _isRadiusFixed = state.radiusFixed;
                }

                if (state is MapTypeChanged) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _currentMapType = state.mapType;
                }
                if (state is RadiusUpdate) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _radius = state.radius;
                  _zoom = state.zoom;
                 //
                }
                if (state is MarkerWithSnackbar) {
                  _marker.add(state.marker);
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(state.snackBar);
                }
                if (state is LocationFromPlaceFound) {
                  Scaffold.of(context)..hideCurrentSnackBar();
                  _lastMapPosition =
                      LatLng(state.locationModel.lat, state.locationModel.long);
                }
                if (state is Failure) {
                  print('Gagal');
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Error'), Icon(Icons.error)],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                }
                if (state is Loading) {
                  print('loading');
                  Scaffold.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Memuat'),
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );
                }
              },
              child: BlocBuilder(
                bloc: _mapsBloc,
                builder: (BuildContext context, MapsState state){
                  return Scaffold(
                    body: new Stack(
                      children: <Widget>[
                        _GoogleMapsWidget(state),
                        Padding(
                          padding: const EdgeInsets.only(top: 600),
                           child: Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                             RaisedButton(
                               color: Colors.red,
                               child: Text("Absen", style: TextStyle(color: Colors.white),),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                               onPressed: () async {
                                 final posisi = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
                                 print(posisi);
                                 setState(() {
                                   _LocationLong = "${posisi.longitude}";
                                   _LocationLat = "${posisi.latitude}";
                                   _marker.add(Marker(
                                       markerId: MarkerId('myMarker'),
                                       draggable: true,
                                       onTap: (){
                                         print('Marker Tapped');
                                       },
                                       position: LatLng(posisi.latitude, posisi.longitude)
                                   ));
                                 });
                                 // ignore: unrelated_type_equality_checks
                                 if(posisi == _center){
                                   showDialog(
                                       context: (context),
                                       child: AlertDialog(
                                         content: Text("Lokasi Akurat."),
                                       )
                                   );
                                 }
                                 else {
//                                   insertData();
                                   showDialog(
                                       context: (context),
                                       child: AlertDialog(
                                         content: Text("Lokasi Tidak Akurat."),
                                       )
                                   );
                                 }
                               },
                             ),
                             RaisedButton(
                               color: Colors.red,
                               child: Text("Get Lokasi", style: TextStyle(color: Colors.white),),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                               onPressed: (){
                                 _getPosisiLokasi();
                               },
                             )
                           ],
                          ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
