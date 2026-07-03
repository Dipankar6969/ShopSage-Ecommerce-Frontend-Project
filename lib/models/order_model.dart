class OrderModel {
    OrderModel({
        required this.user,
        required this.orderItems,
        required this.status,
        required this.shippingAddress,
        required this.orderNumber,
        required this.totalPrice,
        required this.createdDate,
        required this.id,
        required this.v,
    });

    final String? user;
    final List<OrderItem> orderItems;
    final String? status;
    final ShippingAddress? shippingAddress;
    final String? orderNumber;
    final int? totalPrice;
    final DateTime? createdDate;
    final String? id;
    final int? v;

    factory OrderModel.fromJson(Map<String, dynamic> json){ 
        return OrderModel(
            user: json["user"],
            orderItems: json["orderItems"] == null ? [] : List<OrderItem>.from(json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
            status: json["status"],
            shippingAddress: json["shippingAddress"] == null ? null : ShippingAddress.fromJson(json["shippingAddress"]),
            orderNumber: json["orderNumber"],
            totalPrice: json["totalPrice"],
            createdDate: DateTime.tryParse(json["createdDate"] ?? ""),
            id: json["_id"],
            v: json["__v"],
        );
    }

}

class OrderItem {
    OrderItem({
        required this.product,
        required this.quantity,
        required this.id,
    });

    final String? product;
    final int? quantity;
    final String? id;

    factory OrderItem.fromJson(Map<String, dynamic> json){ 
        return OrderItem(
            product: json["product"],
            quantity: json["quantity"],
            id: json["_id"],
        );
    }

}

class ShippingAddress {
    ShippingAddress({
        required this.city,
        required this.province,
        required this.country,
    });

    final String? city;
    final String? province;
    final String? country;

    factory ShippingAddress.fromJson(Map<String, dynamic> json){ 
        return ShippingAddress(
            city: json["city"],
            province: json["province"],
            country: json["country"],
        );
    }

}
