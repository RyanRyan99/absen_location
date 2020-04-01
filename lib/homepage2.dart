import 'package:absenlocation/map/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'map/bloc/maps_bloc.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  GoogleMapController _controller;
  final Set<Marker> _marker = {};
  final Set<Circle> _circle = {};
  double _radius = 100.0;
  double _zoom = 18.0;
  bool _showFixedGpsIcon = false;
  bool _isRadiusFixed = false;
  String error;
  static const LatLng _center = const LatLng(-6.471449, 106.861565);
  MapType _currentMapType = MapType.normal;
  LatLng _lastMapPosition = _center;

  MapsBloc _mapsBloc;

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
      onMapCreated: _onMapCreated,
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
  @override
  void initState() {
    super.initState();
    _mapsBloc = BlocProvider.of<MapsBloc>(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: _mapsBloc,
      ),
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }
}
