import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addToCart({
    required String productName,
    required String productarabicName,
    required String categoryId,
    required String discription,
    required String arabicDiscription,
    required String variantId,
    required String variantName,
    required String variantPrice,
    required String quantity,
    required String productImageUrl,
    
  }) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final cartItem = {
        'productName': productName,
        'productarabicName': productarabicName,
        'productImageUrl': productImageUrl,
        'categoryId': categoryId,
        'discription': discription,
        'arabicDiscription': arabicDiscription,
        'variantId': variantId,
        'variantName': variantName,
        'variantPrice': variantPrice,
        'quantity': quantity,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('cartItems')
          .doc(userId)
          .collection('cart')
          .add(cartItem);

    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection('cartItems')
          .doc(userId)
          .collection('cart')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  Future<void> removeFromCart(String itemId) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('cartItems')
          .doc(userId)
          .collection('cart')
          .doc(itemId)
          .delete();

    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final cartRef = _firestore
          .collection('cartItems')
          .doc(userId)
          .collection('cart');
      
      final cartItems = await cartRef.get();
      
      for (var doc in cartItems.docs) {
        await doc.reference.delete();
      }

    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
  
  Future<void> updateQuantity(String itemId, String newQuantity) async {
    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _firestore
          .collection('cartItems')
          .doc(userId)
          .collection('cart')
          .doc(itemId)
          .update({'quantity': newQuantity});

    } catch (e) {
      throw Exception('Failed to update quantity: $e');
    }
  }
}