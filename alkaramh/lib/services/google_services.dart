import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<UserCredential> signupWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gauth = await gUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gauth.accessToken,
      idToken: gauth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  //info: Sign in with google
  static Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      if (googleSignInAccount == null) {
        throw 'Google sign in cancelled';
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Create user document after successful sign in
      if (userCredential.user != null) {
        await AuthServices()
            .createUserDocumentForGoogleSignIn(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      print('Error in Google sign in: $e');
      throw e;
    }
  }

  //info: Sign out from Google
  static Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  static Future<bool> isUserLoggedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  // Get current user details
  static Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  //info: login with google
  static Future<UserCredential> loginWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }
}
