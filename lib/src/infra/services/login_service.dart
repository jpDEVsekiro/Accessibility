import 'package:aps_dsd/src/domain/services/i_login_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginService implements ILoginService {
  @override
  Future<GoogleSignInAccount?> loginUser() async {
    try {
      GoogleSignInAccount? account = GoogleSignIn().currentUser ?? await GoogleSignIn().signIn();
      return account;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    await GoogleSignIn().disconnect();
  }
}
