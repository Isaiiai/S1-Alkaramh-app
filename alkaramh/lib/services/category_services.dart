import 'package:alkaramh/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Category>> fetchCategories() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('category').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Add document ID to the data map
        data['document_id'] = doc.id;
        return Category(
            id: data['id'] ?? '',
            categoryName: data['name'] ?? '',
            categoryarabicName: data['arabic_name'] ?? '',
            imageUrl: data['imageUrl'],
            isActive: data['is_active'] ?? false);
      }).toList();
    } catch (e) {
      print('Error mapping categories: ${e.toString()}');
      throw Exception('Failed to map categories: ${e.toString()}');
    }
  }
}
