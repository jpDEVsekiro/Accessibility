import 'package:aps_dsd/src/application/controllers/map_app_controller.dart';
import 'package:aps_dsd/src/domain/models/place.dart';
import 'package:aps_dsd/src/domain/services/i_firebase_service.dart';
import 'package:aps_dsd/src/ui/widgets/button_app.dart';
import 'package:aps_dsd/src/ui/widgets/rating_bar.dart';
import 'package:aps_dsd/src/ui/widgets/text_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingDialog {
  BuildContext? dialogContext;
  Future<bool?> show(Place place, BuildContext? dialogContext) async {
    double ratingRampas = 0;
    double ratingPortas = 0;
    double ratingBanheiros = 0;
    double ratingVagas = 0;
    double ratingPisos = 0;
    if (dialogContext != null) {
      await Get.dialog(
        Dialog(
          alignment: Alignment.center,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogContext.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: dialogContext.height * 0.02, left: dialogContext.width * 0.6),
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                          width: dialogContext.width * 0.08,
                          height: dialogContext.width * 0.08,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.all(Radius.circular(dialogContext.width * 0.05))),
                          child: Icon(Icons.close, color: Colors.red, size: dialogContext.width * 0.07)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: dialogContext.height * 0.03,
                        left: dialogContext.width * 0.05,
                        right: dialogContext.width * 0.05),
                    child: TextApp(
                      place.name ?? 'Local sem nome',
                      style: TextStyle(fontSize: dialogContext.width * 0.06, fontWeight: FontWeight.w400),
                    ),
                  ),
                  RattingBar(
                      title: 'Rampas:',
                      ignoreGesture: false,
                      rating: ratingRampas,
                      onRatingUpdate: (value) => ratingRampas = value),
                  RattingBar(
                      title: 'Portas acessíveis:',
                      ignoreGesture: false,
                      rating: ratingPortas,
                      onRatingUpdate: (value) => ratingPortas = value),
                  RattingBar(
                      title: 'Banheiros acessíveis:',
                      ignoreGesture: false,
                      rating: ratingBanheiros,
                      onRatingUpdate: (value) => ratingBanheiros = value),
                  RattingBar(
                      title: 'Vagas de estacionamento para deficientes:',
                      ignoreGesture: false,
                      rating: ratingVagas,
                      onRatingUpdate: (value) => ratingVagas = value),
                  RattingBar(
                      title: 'Pisos adequados:',
                      ignoreGesture: false,
                      rating: ratingPisos,
                      onRatingUpdate: (value) => ratingPisos = value),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: dialogContext.height * 0.04),
                    child: ButtonApp(
                      width: dialogContext.height * 0.3,
                      height: dialogContext.height * 0.06,
                      onTap: () {
                        Get.find<IFirebaseService>(tag: 'firebase').saveRating({
                          'userId': Get.find<MapAppController>().user?.id,
                          'userName': Get.find<MapAppController>().user?.displayName,
                          'userEmail': Get.find<MapAppController>().user?.email,
                          'placeId': place.placeid,
                          'placeName': place.name,
                          'rampas': ratingRampas,
                          'portas': ratingPortas,
                          'banheiros': ratingBanheiros,
                          'vagas': ratingVagas,
                          'pisos': ratingPisos,
                        });
                        Get.back(result: true);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return null;
  }

  void close({BuildContext? dialogContext}) {
    Get.closeAllSnackbars();
    if (dialogContext == null) {
      Get.back();
    } else {
      try {
        Navigator.pop(dialogContext);
      } finally {}
    }
  }
}
