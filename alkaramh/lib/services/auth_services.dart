import 'package:alkaramh/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;

  AuthResult({required this.success, this.errorMessage});
}

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        try {
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
            'name': name,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });
          return AuthResult(success: true);
        } catch (e) {
          // Rollback auth if Firestore fails
          await userCredential.user?.delete();
          return AuthResult(
              success: false, errorMessage: 'Failed to create user profile');
        }
      }
      return AuthResult(success: false);
    } on FirebaseAuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    }
  }

  Future<AuthResult> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return AuthResult(success: true);
      }
      return AuthResult(success: false, errorMessage: 'Login failed');
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Wrong password provided';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        default:
          message = e.message ?? 'An error occurred';
      }
      return AuthResult(success: false, errorMessage: message);
    } catch (e) {
      return AuthResult(success: false, errorMessage: e.toString());
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  Future<bool> isLogin() async {
    await Future.delayed(Duration(seconds: 2));
    return false;
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
