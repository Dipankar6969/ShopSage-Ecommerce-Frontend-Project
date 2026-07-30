class UserModel {
    UserModel({
        required this.address,
        required this.id,
        required this.name,
        required this.email,
        required this.password,
        required this.phone,
        required this.createdAt,
        required this.isActive,
        required this.roles,
        this.profileImageUrl,
        required this.v,
    });

    final Address? address;
    final String? id;
    final String? name;
    final String? email;
    final String? password;
    final String? phone;
    final DateTime? createdAt;
    final bool? isActive;
    final List<String> roles;
    final String? profileImageUrl;
    final int? v;

    factory UserModel.fromJson(Map<String, dynamic> json){ 
        return UserModel(
            address: json["address"] == null ? null : Address.fromJson(json["address"]),
            id: json["_id"],
            name: json["name"],
            email: json["email"],
            password: json["password"],
            phone: json["phone"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            isActive: json["isActive"],
            roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
            profileImageUrl: json["profileImageUrl"],
            v: json["__v"],
        );
    }

}

class Address {
    Address({
        required this.city,
        required this.country,
    });

    final String? city;
    final String? country;

    factory Address.fromJson(Map<String, dynamic> json){ 
        return Address(
            city: json["city"],
            country: json["country"],
        );
    }

}
