import 'package:aps_dsd/src/domain/models/place.dart';
import 'package:aps_dsd/src/domain/services/i_firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService implements IFirebaseService {
  late FirebaseApp firebaseApp;
  @override
  Future<void> init() async {
    firebaseApp = await Firebase.initializeApp();
  }

  @override
  Future<List> pickRating(Place place) async {
    CollectionReference placesRating = FirebaseFirestore.instance.collection('placesRating');
    return placesRating.where('placeId', isEqualTo: place.placeid).get().then((value) => value.docs);
  }

  @override
  Future<void> saveRating(Map<String, dynamic> ratting) async {
    CollectionReference placesRating = FirebaseFirestore.instance.collection('placesRating');
    await placesRating.add(ratting);
  }
}
