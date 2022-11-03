import 'package:aps_dsd/src/domain/models/place.dart';
import 'package:aps_dsd/src/domain/services/i_firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService implements IFirebaseService {
  late FirebaseApp firebaseApp;
  @override
  Future<void> init() async {
    firebaseApp = await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBikF2qGS3ylaNkllZr8W-b9mFHEd5LO1E',
        appId: '1:951533522749:android:87414c312a63a5e6d37f54',
        messagingSenderId: '951533522749',
        projectId: 'accessibility-7385f',
      ),
    );
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
