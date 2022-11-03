import 'package:aps_dsd/src/domain/services/i_gps_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GpsService implements IGpsService {
  @override
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Stream<Position> listenCurrentPosition() {
    return Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  double distance(LatLng inicio, LatLng fim) {
    return Geolocator.distanceBetween(
        inicio.latitude, inicio.longitude, fim.latitude, fim.longitude);
  }
}
