import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';


class HomePage extends StatefulWidget {
  HomePage() : super();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _LocationLong = "";
  String _LocationLat = "";

  void _getPosisiLokasi() async {
    final posisi = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(posisi);

    setState(() {
      _LocationLong = "${posisi.longitude}";
      _LocationLat = "${posisi.latitude}";
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
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-6.4714692, 106.8614672),
    zoom: 14.4746,
  );
  static final CameraPosition _Kbintang = CameraPosition(
      bearing: 106.861746,
      target: LatLng(-6.471297, 106.861746),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414
  );
  List<Marker> _markers = [];
  GoogleMapController _controllerMap;
  @override
  void initState() {
    super.initState();
    _markers.add(Marker(
      markerId: MarkerId('myMarker'),
      draggable: true,
      onTap: (){
        print('Marker Tapped');
      },
      position: LatLng(-6.4714692, 106.861746)
    ));
  }
  //EndMaps
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: new Stack(
        children: <Widget>[
          Container(
            height: 600,
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
              markers: Set.from(_markers),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(top: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  color: Colors.red,
                  child: Text("Absen", style: TextStyle(color: Colors.white),),
                  onPressed: (){insertData();},
                ),
                RaisedButton(
                  color: Colors.red,
                  child: Text("Get Lokasi", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                   _getPosisiLokasi();
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                  color: Colors.red,
                  child: Icon(Icons.gps_fixed, color: Colors.white,),
                  onPressed: (){
                    _goToBintang();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Future<void> _goToBintang() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_Kbintang));
  }
}
