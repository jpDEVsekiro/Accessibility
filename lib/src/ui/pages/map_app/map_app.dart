import 'package:aps_dsd/src/application/controllers/map_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapApp extends GetView<MapAppController> {
  const MapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Stack(children: [
          Obx(
            () => GoogleMap(
              markers: {
                ...controller.places,
              },
              onMapCreated: (GoogleMapController controllerMap) {
                controller.mapController = controllerMap;
              },
              onCameraMove: (CameraPosition cameraPosition) {
                controller.zoom = cameraPosition.zoom;
              },
              onTap: (LatLng latLng) {
                controller.pickPlace(latLng);
              },
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: MapAppController.cameraPosition,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: context.height * 0.025, left: context.width * 0.89 - context.height * 0.025),
            child: InkWell(
              onTap: controller.onTapLogin,
              child: Container(
                width: context.width * 0.11,
                height: context.width * 0.11,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    border: Border.all(
                      color: Colors.blueAccent[800] ?? Colors.blueAccent,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(context.width))),
                child: Obx(
                  () => controller.isLogged.value == false
                      ? Icon(
                          Icons.person_outline_outlined,
                          color: Colors.white,
                          size: context.width * 0.07,
                        )
                      : CircleAvatar(
                          radius: context.width,
                          backgroundImage: NetworkImage(
                            controller.user?.photoUrl ??
                                'https://st.depositphotos.com/1477718/2882/v/600/depositphotos_28827813-stock-illustration-disabled-icon.jpg',
                          ),
                        ),
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }
}
