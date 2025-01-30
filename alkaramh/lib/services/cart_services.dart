import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  static const String cartKey = 'cartItems';

  Future<void> addToCart({
    required String productName,
    required String categoryId,
    required String discription,
    required String variantId,
    required String variantName,
    required String variantPrice,
    required String quantity,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final cartItems = prefs.getStringList(cartKey) ?? [];
      print('Porduct Id : $productName');
      print('Variant Id : $variantId');
      print('Variant Name : $variantName');
      print('Variant Price : $variantPrice');
      print('Quantity : $quantity');

      final newItem = {
        'productName': productName,
        'categoryId': categoryId,
        'discription': discription,
        'variantId': variantId,
        'variantName': variantName,
        'variantPrice': variantPrice,
        'quantity': quantity,
      };

      cartItems.add(jsonEncode(newItem));
      await prefs.setStringList(cartKey, cartItems);
      print("Cart Items : $cartItems");

      return;
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final cartItems = prefs.getStringList(cartKey) ?? [];

      return cartItems
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  Future<void> removeFromCart(int index) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final cartItems = prefs.getStringList(cartKey) ?? [];

      if (index >= 0 && index < cartItems.length) {
        cartItems.removeAt(index);
        await prefs.setStringList(cartKey, cartItems);
      }
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(cartKey);
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}
