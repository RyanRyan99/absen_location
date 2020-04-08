import 'package:absenlocation/map/bloc/bloc.dart';
import 'package:absenlocation/map/bloc/maps_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RangeRadius extends StatefulWidget {
  final bool isRadiusFixed;
  const RangeRadius({@required this.isRadiusFixed});

  @override
  _RangeRadiusState createState() => _RangeRadiusState();
}

class _RangeRadiusState extends State<RangeRadius> {
  double _radius = 50;
  MapsBloc _mapsBloc;
  @override
  void initState() {
    super.initState();
    _mapsBloc = BlocProvider.of<MapsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _mapsBloc,
      listener: (context, state) {
        if (state is RadiusUpdate) {
          _radius = state.radius;
        }
      },
      child: Positioned(
        bottom: 20.0,
        left: 10.0,
        right: 10.0,
        child: BlocBuilder(
          bloc: _mapsBloc,
          builder: (context, state) {
            return Column(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    widget.isRadiusFixed != true ? 'Check' : 'Cencel'
                  ),
                  onPressed: () => _mapsBloc.add(IsRadiusFixedPressed(
                      isRadiusFixed: widget.isRadiusFixed)),
                  color:
                  widget.isRadiusFixed != true ? Colors.red : Colors.red,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
