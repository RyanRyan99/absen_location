
import 'package:absenlocation/distance.dart';
import 'package:absenlocation/map/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'homepage.dart';
import 'map/maps.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
//      home: BlocProvider(
//        create: (context) => MapsBloc(),
//        child: HomePage(),
//      ),
    home: CalculateDistanceWidget(),

    );
  }
}
