//model for the company details

class Company {
  final int id;
  final String name;
  final String domain;

  Company({
    required this.id,
    required this.name,
    required this.domain,
  });

  Company.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        domain = json['domain'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domain': domain,
    };
  }
}
