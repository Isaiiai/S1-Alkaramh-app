import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishListServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addToWishList({
    required String productId,
    required String productName,
    required String productarabicName,
    required String description,
    required String arabicDescription,
  }) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final wishListItem = {
        'productId': productId,
        'productName': productName,
        'productarabicName': productarabicName,
        'description': description,
        'arabicDescription': arabicDescription,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('wishList')
          .doc(userId)
          .collection('items')
          .doc(productId)
          .set(wishListItem);
    } catch (e) {
      throw Exception('Failed to add item to wishlist: $e');
    }
  }

  Future<void> removeFromWishList(String productId) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('wishList')
          .doc(userId)
          .collection('items')
          .doc(productId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove item from wishlist: $e');
    }
  }

  Future<void> clearWishList() async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final wishListRef = _firestore
          .collection('wishList')
          .doc(userId)
          .collection('items');
      
      final items = await wishListRef.get();
      
      for (var doc in items.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear wishlist: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getWishList() async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('wishList')
          .doc(userId)
          .collection('items')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Failed to get wishlist items: $e');
    }
  }

  Future<bool> isInWishList(String productId) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final docSnapshot = await _firestore
          .collection('wishList')
          .doc(userId)
          .collection('items')
          .doc(productId)
          .get();

      return docSnapshot.exists;
    } catch (e) {
      throw Exception('Failed to check wishlist status: $e');
    }
  }
}