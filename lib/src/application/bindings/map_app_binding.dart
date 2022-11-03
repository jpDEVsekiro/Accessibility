import 'package:aps_dsd/src/application/controllers/map_app_controller.dart';
import 'package:aps_dsd/src/domain/services/i_firebase_service.dart';
import 'package:aps_dsd/src/domain/services/i_gps_service.dart';
import 'package:aps_dsd/src/domain/services/i_login_service.dart';
import 'package:aps_dsd/src/infra/services/firebase_service.dart';
import 'package:aps_dsd/src/infra/services/gps_service.dart';
import 'package:aps_dsd/src/infra/services/login_service.dart';
import 'package:get/get.dart';

class MapAppBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut<IGpsService>(() => GpsService());
    Get.lazyPut<ILoginService>(() => LoginService());
    Get.lazyPut<IFirebaseService>(() => FirebaseService(), fenix: true, tag: 'firebase');
    Get.put(MapAppController());
  }
}
