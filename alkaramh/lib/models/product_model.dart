import 'package:alkaramh/models/company_details.dart';
import 'package:alkaramh/services/language_helper_function.dart';
import 'package:flutter/material.dart';

class Product {
  final int id;
  final String categoryId;
  final String name;
  final String arabicName;
  final String description;
  final String arabicDescription;
  final String? imageUrl;
  final bool isActive;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.description,
    required this.arabicDescription,
    this.imageUrl,
    required this.categoryId,
    required this.isActive,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      arabicName: json['arabic_name'],
      description: json['description'],
      arabicDescription: json['arabic_description'],
      imageUrl: json['imageUrl'] ?? '',
      categoryId: json['category_id'],
       isActive: json['isActive'] ?? false, 
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'arabic_name': arabicName,
      'description': description,
      'arabic_description': arabicDescription,
      'imageUrl': imageUrl,
      'category_id': categoryId,
      'isActive': isActive,
      'rating': rating,
    };
  }

  String getLocalizedName(BuildContext context) {
    return LocalizationHelper.getLocalizedText(
      context: context,
      englishText: name,
      arabicText: arabicName,
    );
  }

  String getLocalizedDescription(BuildContext context) {
    return LocalizationHelper.getLocalizedText(
      context: context,
      englishText: description,
      arabicText: arabicDescription,
    );
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
  final String categoryarabicName;
  final String? imageUrl;
  final bool isActive;

  Category({
    required this.id,
    required this.categoryName,
    required this.categoryarabicName,
    this.imageUrl,
    required this.isActive,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? '',
      categoryName: json['name'] ?? '',
      categoryarabicName: json['arabic_name'] ?? '',
      imageUrl: json['imageUrl'],
      isActive: json['is_active'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $categoryName, isActive: $isActive)';
  }
}
