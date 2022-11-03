import 'package:google_sign_in/google_sign_in.dart';

abstract class ILoginService {
  Future<GoogleSignInAccount?> loginUser();
  Future<void> logOut();
}
