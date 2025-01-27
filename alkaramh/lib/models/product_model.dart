import 'package:alkaramh/models/company_details.dart';

class Product {
  final int id;
  final String categoryId;
  final String name;
  final String description;
  final String? imageUrl;
  final bool isActive;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.categoryId,
    required this.isActive,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? '',
      categoryId: json['category_id'],
      isActive: json['isActive'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category_id': categoryId,
      'isActive': isActive,
      'rating': rating,
    };
  }
}

class ProductVariant {
  final int id;
  final int productid;
  final String name;
  final double price;
  final double discountedPrice;
  final bool isAvailable;

  ProductVariant({
    required this.id,
    required this.productid,
    required this.name,
    required this.price,
    required this.discountedPrice,
    required this.isAvailable,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: int.parse(json['id']?.toString() ?? '0'),
      productid: int.parse(json['productid']?.toString() ?? '0'),
      name: json['name']?.toString() ?? '',
      price: double.parse(json['price']?.toString() ?? '0.0'),
      discountedPrice: double.parse(json['discounted_price']?.toString() ?? '0.0'),
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productid': productid,
      'name': name,
      'price': price,
      'discounted_price': discountedPrice,
      'isAvailable': isAvailable,
    };
  }
}

class Category {
  final String id;
  final String categoryName;
  final String? imageUrl;
  final bool isActive;

  Category({
    required this.id,
    required this.categoryName,
    this.imageUrl,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      categoryName: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      isActive: json['is_active'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $categoryName, isActive: $isActive)';
  }
}
