class RegisterRequestModel {
    RegisterRequestModel({
        required this.id,
        required this.address,
        required this.email,
        required this.isActive,
        required this.name,
        required this.phone,
        required this.roles,
        required this.token,
    });

    final String? id;
    final Address? address;
    final String? email;
    final bool? isActive;
    final String? name;
    final String? phone;
    final List<String> roles;
    final String? token;

    factory RegisterRequestModel.fromJson(Map<String, dynamic> json){ 
        return RegisterRequestModel(
            id: json["_id"],
            address: json["address"] == null ? null : Address.fromJson(json["address"]),
            email: json["email"],
            isActive: json["isActive"],
            name: json["name"],
            phone: json["phone"],
            roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
            token: json["token"],
        );
    }

}

class Address {
    Address({
        required this.city,
        required this.province,
        required this.country,
    });

    final String? city;
    final String? province;
    final String? country;

    factory Address.fromJson(Map<String, dynamic> json){ 
        return Address(
            city: json["city"],
            province: json["province"],
            country: json["country"],
        );
    }

}
