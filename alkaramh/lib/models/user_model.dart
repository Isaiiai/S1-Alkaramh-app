
import 'package:alkaramh/models/order_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;

  final DateTime createdAt;

  UserModel({
    required this.id, 
    required this.name,
    required this.email,

    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'createdAt': createdAt.toIso8601String(),
  };
}