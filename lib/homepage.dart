import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:timezone/timezone.dart';

class HomePage extends StatefulWidget {
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
      "timeinout": controllerTime.text = time_now.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: new Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(top: 200),
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
                  color: Colors.red,
                  child: Text("Time", style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    time();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
