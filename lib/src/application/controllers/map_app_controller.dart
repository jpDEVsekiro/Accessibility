import 'dart:ui' as ui;

import 'package:aps_dsd/src/domain/models/place.dart';
import 'package:aps_dsd/src/domain/services/i_firebase_service.dart';
import 'package:aps_dsd/src/domain/services/i_gps_service.dart';
import 'package:aps_dsd/src/domain/services/i_login_service.dart';
import 'package:aps_dsd/src/infra/repositories/http/http.dart';
import 'package:aps_dsd/src/ui/widgets/loading_app.dart';
import 'package:aps_dsd/src/ui/widgets/modal_place.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MapAppController extends GetxController {
  GoogleMapController? mapController;
  IGpsService gpsService = Get.find<IGpsService>();
  double zoom = 14.4746;
  RxList<Marker> places = <Marker>[].obs;
  GoogleSignInAccount? user;
  Rx<Position> myPosition = Position(
          accuracy: 0,
          altitude: 0,
          latitude: 0,
          longitude: 0,
          speed: 0,
          speedAccuracy: 0,
          timestamp: DateTime.now(),
          heading: 0)
      .obs;
  Rx<BitmapDescriptor> myIcon = BitmapDescriptor.defaultMarker.obs;
  static const CameraPosition cameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  RxBool isLogged = false.obs;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  @override
  void onReady() async {
    LoadingApp().show();
    Position position = await gpsService.getCurrentPosition();
    await Get.find<IFirebaseService>(tag: 'firebase').init();
    myPosition.value = position;
    //mapController?.setMapStyle(styleMap);
    await mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14.4746)));
    LoadingApp().close();
    gpsService.listenCurrentPosition().listen((Position position) {
      myPosition.value = position;
    });
    //pickPlaces();
    await Future.delayed(const Duration(seconds: 2));
    onTapLogin();
    super.onReady();
  }

  Future<void> pickPlaces({String? nextPageToken}) async {
    dynamic request = await Http().request(url: '/nearbysearch/json', method: Method.get, params: {
      'key': 'yourAPIkey',
      'location': '${myPosition.value.latitude} ${myPosition.value.longitude}',
      'radius': '50000',
      'language': 'pt-BR',
      'pagetoken': nextPageToken,
    });
    if (request is CustomException) return;
    request.data['results'].forEach((element) {
      places.add(Marker(
          markerId: MarkerId(element['place_id']),
          position: LatLng(element['geometry']['location']['lat'], element['geometry']['location']['lng']),
          icon: myIcon.value,
          infoWindow: InfoWindow(
              title: element['name'],
              snippet: element['vicinity'],
              onTap: () {
                print('tapped');
              })));
    });
    if (request.data['next_page_token'] != null) {
      pickPlaces(nextPageToken: request.data['next_page_token']);
    }
  }

  Future<void> pickPlace(LatLng placePick) async {
    dynamic request = await Http().request(url: '/nearbysearch/json', method: Method.get, params: {
      'key': 'yourAPIkey',
      'location': '${placePick.latitude} ${placePick.longitude}',
      'rankby': 'distance',
      'language': 'pt-BR',
    });
    List<Place> placesList = Place().fromListJson(request.data['results']);
    Place? place = placesList.firstWhereOrNull((element) =>
        gpsService.distance(
            placePick, LatLng(element.geometry?.location?.lat ?? 0, element.geometry?.location?.lng ?? 0)) <
        (32 - zoom));
    if (place != null) {
      if (gpsService.distance(LatLng(place.geometry?.location?.lat ?? 0, place.geometry?.location?.lng ?? 0),
              LatLng(placePick.latitude, placePick.longitude)) <
          0.5) {
        await mapController?.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(placePick.latitude - 0.00012, placePick.longitude), zoom: 19.4746)));
      } else {
        await mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng((place.geometry?.location?.lat ?? 0) - 0.00012, place.geometry?.location?.lng ?? 0),
            zoom: 19.4746)));
      }
      showModalPlace(place);
    }
  }

  Future<void> onTapLogin() async {
    if (user != null) {
      await Get.find<ILoginService>().logOut();
      isLogged.value = false;
      user = null;
      return;
    }
    user = await Get.find<ILoginService>().loginUser();
    if (user != null) {
      isLogged.value = true;
    }
  }

  void showModalPlace(Place place) {
    ModalPlace().show(place);
  }
}
