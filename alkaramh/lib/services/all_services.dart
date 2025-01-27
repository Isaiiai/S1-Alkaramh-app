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
            imageUrl: data['imageUrl'],
            isActive: data['is_active'] ?? false);
      }).toList();
    } catch (e) {
      print('Error mapping categories: ${e.toString()}');
      throw Exception('Failed to map categories: ${e.toString()}');
    }
  }
}

class ProductsFetchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Product>> fetchProducts() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('Products').get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['document_id'] = doc.id;
        return Product(
          id: data['id'],
          name: data['name'],
          description: data['description'],
          categoryId: data['category_id'],
          isActive: data['is_active'],
          rating: data['rating'],
        );
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
        description: data['description'],
        categoryId: data['category_id'],
        isActive: data['is_active'],
        rating: data['rating'],
      );
    } catch (e) {
      print('Error mapping product details: ${e.toString()}');
      throw Exception('Failed to map product details: ${e.toString()}');
    }
  }

  Future<List<ProductVariant>> fetchProductVariants(String productId) async {
    print('Fetching product variants for product ID: $productId');
    try {
      final int productIdInt = int.parse(productId); // Convert to integer
      final QuerySnapshot querySnapshot = await _firestore
          .collection('PRODUCT_VARIANT')
          .where('product_id', isEqualTo: productIdInt) // Use integer
          .get();

      print("Product Variants: ${querySnapshot.docs.length}");
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['document_id'] = doc.id;
        return ProductVariant.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching product variants: ${e.toString()}');
      throw Exception('Failed to fetch product variants: ${e.toString()}');
    }
  }
}
