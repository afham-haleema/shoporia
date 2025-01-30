import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoporia_app/controllers/db_service.dart';

class AuthService {
  Future<String> createUserWithEmail(
      String name, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await DbService().saveUserData(name: name, email: email);
      return 'account created';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'login successful';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> SignInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUsers = await GoogleSignIn().signIn();
      if (googleUsers == null) {
        return 'Google sign-in cancelled';
      }
      GoogleSignInAuthentication? googleAuth =
          await googleUsers?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return 'login successful';
    } catch (e) {
      print('${e}');
      return 'google sign-in failed';
    }
  }

  Future logout() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future sendResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return 'mail sent';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<bool> isLoggedIn() async {
    var user = await FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
