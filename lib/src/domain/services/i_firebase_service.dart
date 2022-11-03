import 'package:aps_dsd/src/domain/models/place.dart';

abstract class IFirebaseService {
  Future<void> init();
  Future<List> pickRating(Place place);
  Future<void> saveRating(Map<String, dynamic> ratting);
}
