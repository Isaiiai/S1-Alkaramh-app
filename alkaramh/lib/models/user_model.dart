class Address {
  String firstName;
  String lastName;
  String address;
  String apartment;
  String country;
  String city;
  String state;
  String zip;

  Address({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.apartment,
    required this.country,
    required this.city,
    required this.state,
    required this.zip,
  });

  Address.fromJson(Map<String, dynamic> json)
      : firstName = json['first_name'],
        lastName = json['last_name'],
        address = json['address'],
        apartment = json['apartment'],
        country = json['country'],
        city = json['city'],
        state = json['state'],
        zip = json['zip'];

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'apartment': apartment,
      'country': country,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }
}

class User {
  String id;
  String companyId;
  String email;
  String phone;
  String hashedPassword;
  String name;
  String role;
  DateTime createdAt;
  DateTime updatedAt;
  Address address;

  User({
    required this.id,
    required this.companyId,
    required this.email,
    required this.phone,
    required this.hashedPassword,
    required this.name,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        companyId = json['company_id'],
        email = json['email'],
        phone = json['phone'],
        hashedPassword = json['hashed_password'],
        name = json['name'],
        role = json['role'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']),
        address = Address.fromJson(json['address']);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'email': email,
      'phone': phone,
      'hashed_password': hashedPassword,
      'name': name,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'address': address.toJson(),
    };
  }
}