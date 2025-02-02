import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String userId;
  final List<Map<String, dynamic>> cartItems;
  final AddressModel address;
  final String totalAmount;
  final Timestamp? createdAt = Timestamp.now();
  final String status = 'pending';

  OrderModel({
    required this.userId,
    required this.cartItems,
    required this.address,
    required this.totalAmount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      userId: json['userId'] ?? '',
      cartItems: List<Map<String, dynamic>>.from(json['cartItems'] ?? []),
      address: AddressModel.fromJson(json['address']),
      totalAmount: json['totalAmount'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'cartItems': cartItems,
        'address': address.toJson(),
        'totalAmount': totalAmount,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      };
}

//info: Address details in the Variable Name
class AddressModel {
  final String name;

  final String phoneNumber;
  final String address;
  final String district;
  final String landMark;

  AddressModel({
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.district,
    required this.landMark,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      district: json['district'] ?? '',
      landMark: json['landMark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'phoneNumber': phoneNumber,
        'district;': district,
        'landMark': landMark,
      };
}
