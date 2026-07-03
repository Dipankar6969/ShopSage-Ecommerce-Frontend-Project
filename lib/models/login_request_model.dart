class LoginRequestModel {
    LoginRequestModel({
        required this.id,
        required this.address,
        required this.roles,
        required this.phone,
        required this.email,
        required this.name,
        required this.isActive,
        required this.token,
        required this.verifiedToken,
        required this.iat,
        required this.exp,
    });

    final String? id;
    final Address? address;
    final List<String> roles;
    final String? phone;
    final String? email;
    final String? name;
    final bool? isActive;
    final String? token;
    final LoginRequestModel? verifiedToken;
    final int? iat;
    final int? exp;

    factory LoginRequestModel.fromJson(Map<String, dynamic> json){ 
        return LoginRequestModel(
            id: json["_id"],
            address: json["address"] == null ? null : Address.fromJson(json["address"]),
            roles: json["roles"] == null ? [] : List<String>.from(json["roles"]!.map((x) => x)),
            phone: json["phone"],
            email: json["email"],
            name: json["name"],
            isActive: json["isActive"],
            token: json["token"],
            verifiedToken: json["verifiedToken"] == null ? null : LoginRequestModel.fromJson(json["verifiedToken"]),
            iat: json["iat"],
            exp: json["exp"],
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
