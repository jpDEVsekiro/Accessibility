import 'package:aps_dsd/src/application/controllers/map_app_controller.dart';
import 'package:aps_dsd/src/domain/models/place.dart';
import 'package:aps_dsd/src/domain/services/i_firebase_service.dart';
import 'package:aps_dsd/src/infra/repositories/http/http.dart';
import 'package:aps_dsd/src/ui/widgets/button_app.dart';
import 'package:aps_dsd/src/ui/widgets/rating_bar.dart';
import 'package:aps_dsd/src/ui/widgets/rating_dialog.dart';
import 'package:aps_dsd/src/ui/widgets/text_app.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ModalPlace {
  final RxInt _current = 0.obs;
  final RxList<double> rattingList = [0.0, 0.0, 0.0, 0.0, 0.0].obs;
  final CarouselController _controller = CarouselController();

  Future<Place?> getFinalPlace(String placeId) async {
    dynamic request = await Http().request(url: '/details/json', method: Method.get, params: {
      'key': 'AIzaSyDaxIfpA2hPt0NFqjYeRYJlCDMV59ZIkOA',
      'place_id': placeId,
      'language': 'pt-BR',
    });
    if (request is CustomException) {
      return null;
    }
    return Place.fromJson(request.data['result']);
  }

  void show(Place placeIncomplete) {
    Rx<Place> place = placeIncomplete.obs;
    if (placeIncomplete.placeid != null) {
      getFinalPlace(placeIncomplete.placeid!).then((Place? placeComplete) {
        if (placeComplete != null) {
          place.value = placeComplete;
        }
      });
      Get.find<IFirebaseService>(tag: 'firebase').pickRating(place.value).then((List rating) {
        _changeAvaliatio(rating);
      });
    }
    showCupertinoModalBottomSheet(
      context: Get.context!,
      enableDrag: false,
      builder: (BuildContext context) {
        return Container(
          height: context.height * 0.47,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(top: context.height * 0.021, left: context.width * 0.8),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                      width: context.width * 0.08,
                      height: context.width * 0.08,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(context.width * 0.05))),
                      child: Icon(Icons.close, color: Colors.red, size: context.width * 0.07)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: context.width * 0.05, right: context.width * 0.05),
                child: SizedBox(
                    width: context.width * 0.9,
                    child: TextApp(
                      place.value.name ?? 'Local sem nome',
                      style: TextStyle(
                        fontSize: context.width * 0.05,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                      maxLines: 2,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: context.width * 0.05,
                    right: context.width * 0.05,
                    top: context.height * 0.01,
                    bottom: context.height * 0.02),
                child: SizedBox(
                    width: context.width * 0.9,
                    child: TextApp(
                      place.value.vicinity ?? '',
                      style: TextStyle(
                        fontSize: context.width * 0.03,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                      maxLines: 2,
                    )),
              ),
              Obx(
                () => place.value.photos?.isEmpty == true
                    ? const SizedBox()
                    : CarouselSlider(
                        carouselController: _controller,
                        options: CarouselOptions(
                          reverse: false,
                          scrollDirection: Axis.horizontal,
                          aspectRatio: 1.5,
                          autoPlay: false,
                          onPageChanged: (index, reason) {
                            _current.value = index;
                          },
                        ),
                        items: place.value.photos?.map((i) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    'https://maps.googleapis.com/maps/api/place/photo?maxwidth=1600&maxheight=1600&photoreference=${i?.photoreference}&key=AIzaSyDaxIfpA2hPt0NFqjYeRYJlCDMV59ZIkOA',
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: LoadingAnimationWidget.discreteCircle(
                                            color: Colors.greenAccent,
                                            secondRingColor: Colors.green,
                                            thirdRingColor: Colors.cyan,
                                            size: ((Get.height + Get.width) / 10) * 0.5),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }).toList() ??
                            [],
                      ),
              ),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: place.value.photos?.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () {
                            _controller.animateToPage(entry.key);
                          },
                          child: Container(
                            width: context.width * 0.03,
                            height: context.width * 0.03,
                            margin:
                                EdgeInsets.symmetric(vertical: context.height * 0.02, horizontal: context.width * 0.01),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey)
                                    .withOpacity(_current.value == entry.key ? 1 : 0.4)),
                          ),
                        );
                      }).toList() ??
                      [],
                ),
              ),
              Obx(
                () {
                  if (place.value.website == null) return const SizedBox();
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.height * 0.01),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                          child: Icon(Icons.web, color: Colors.blueAccent, size: context.width * 0.1),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: context.width * 0.05),
                          child: GestureDetector(
                            onTap: () {
                              launchUrlString('https${place.value.website!.substring(4)}');
                            },
                            child: SizedBox(
                              width: context.width * 0.75,
                              child: TextApp(
                                place.value.website ?? '',
                                style: TextStyle(
                                    fontSize: context.width * 0.04,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blueAccent,
                                    decorationStyle: TextDecorationStyle.solid),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Obx(
                () {
                  if (place.value.internationalPhoneNumber == null) return const SizedBox();
                  return Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
                        child: Icon(Icons.phone, color: Colors.blueAccent, size: context.width * 0.1),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: context.width * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            launchUrlString('tel://${place.value.internationalPhoneNumber!}');
                          },
                          child: SizedBox(
                            width: context.width * 0.75,
                            child: TextApp(
                              place.value.internationalPhoneNumber ?? '',
                              style: TextStyle(
                                  fontSize: context.width * 0.04,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blueAccent,
                                  decorationStyle: TextDecorationStyle.solid),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Obx(
                () => Column(
                  children: [
                    RattingBar(title: 'Rampas:', ignoreGesture: true, rating: rattingList[0]),
                    RattingBar(title: 'Portas acessíveis:', ignoreGesture: true, rating: rattingList[1]),
                    RattingBar(title: 'Banheiros acessíveis:', ignoreGesture: true, rating: rattingList[2]),
                    RattingBar(
                        title: 'Vagas de estacionamento para deficientes:',
                        ignoreGesture: true,
                        rating: rattingList[3]),
                    RattingBar(title: 'Pisos adequados:', ignoreGesture: true, rating: rattingList[4]),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.height * 0.03),
                child: ButtonApp(
                  onTap: () async {
                    if (Get.find<MapAppController>().user?.id != null) {
                      await RatingDialog().show(place.value, context);
                      Get.find<IFirebaseService>(tag: 'firebase').pickRating(place.value).then((List rating) {
                        _changeAvaliatio(rating);
                      });
                    } else {
                      await Get.find<MapAppController>().onTapLogin();
                      if (Get.find<MapAppController>().user?.id != null) {
                        await RatingDialog().show(place.value, Get.context);
                        Get.find<IFirebaseService>(tag: 'firebase').pickRating(place.value).then((List rating) {
                          _changeAvaliatio(rating);
                        });
                      }
                    }
                  },
                  width: context.width * 0.75,
                  height: context.height * 0.055,
                ),
              )
            ]),
          ),
        );
      },
    );
  }

  void goToRating() async {}

  void _changeAvaliatio(List rating) {
    if (rating.isEmpty) return;
    double rampas = 0;
    double banheiros = 0;
    double pisos = 0;
    double portas = 0;
    double estacionamento = 0;
    for (dynamic item in rating) {
      rampas += item['rampas'];
      banheiros += item['banheiros'];
      pisos += item['pisos'];
      portas += item['portas'];
      estacionamento += item['vagas'];
    }
    rattingList.value = [
      rampas / rating.length,
      banheiros / rating.length,
      pisos / rating.length,
      portas / rating.length,
      estacionamento / rating.length,
    ];
  }
}
