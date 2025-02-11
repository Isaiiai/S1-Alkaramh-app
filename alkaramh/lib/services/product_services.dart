import 'package:alkaramh/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsFetchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('Products').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['document_id'] = doc.id;

        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error mapping products: ${e.toString()}');
      throw Exception('Failed to map products: ${e.toString()}');
    }
  }

  Future<Product> fetchProductDetails(String productId) async {
    try {
      final DocumentSnapshot documentSnapshot =
          await _firestore.collection('Products').doc(productId).get();

      final data = documentSnapshot.data() as Map<String, dynamic>;
      data['document_id'] = documentSnapshot.id;

      return Product(
        id: data['id'],
        name: data['name'],
        arabicName: data['arabic_name'],
        description: data['description'],
        arabicDescription: data['arabic_description'],
        categoryId: data['category_id'],
        isActive: data['is_active'],
        imageUrl: data['imageUrl'],
      );
    } catch (e) {
      print('Error mapping product details: ${e.toString()}');
      throw Exception('Failed to map product details: ${e.toString()}');
    }
  }

  Future<List<ProductVariant>> fetchProductVariants(String productId) async {
    try {
      final int productIdInt = int.parse(productId);
      final QuerySnapshot querySnapshot = await _firestore
          .collection('PRODUCT_VARIANT')
          .where('product_id', isEqualTo: productIdInt)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['document_id'] = doc.id;
        return ProductVariant.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch product variants: ${e.toString()}');
    }
  }
}
