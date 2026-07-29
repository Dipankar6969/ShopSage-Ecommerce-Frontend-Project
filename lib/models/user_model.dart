class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? phone;
  final DateTime? createdAt;
  final bool? isActive;
  final List<String>? roles;
  final String? profileImageUrl;
  final int? v;
  final Address? address;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.createdAt,
    this.isActive,
    this.roles,
    this.profileImageUrl,
    this.v,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      phone: json["phone"],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      isActive: json["isActive"],
      roles: json["roles"] != null ? List<String>.from(json["roles"]) : [],
      profileImageUrl: json["profileImageUrl"],
      v: json["__v"],
      address: json["address"] != null
          ? Address.fromJson(json["address"])
          : null,
    );
  }
}

class Address {
  final String? city;
  final String? country;

  Address({this.city, this.country});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(city: json["city"], country: json["country"]);
  }
}
