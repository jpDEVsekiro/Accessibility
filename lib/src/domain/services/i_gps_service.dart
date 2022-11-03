import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class IGpsService {
  Future<Position> getCurrentPosition();
  Stream<Position> listenCurrentPosition();
  double distance(LatLng inicio, LatLng fim);
}
