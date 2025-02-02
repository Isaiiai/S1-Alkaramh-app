import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}