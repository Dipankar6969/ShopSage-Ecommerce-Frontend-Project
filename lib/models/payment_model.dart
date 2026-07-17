class PaymentModel {
    PaymentModel({
        required this.shippingAddress,
        required this.id,
        required this.user,
        required this.orderItems,
        required this.status,
        required this.orderNumber,
        required this.totalPrice,
        required this.createdDate,
        required this.v,
        required this.payment,
    });

    final ShippingAddress? shippingAddress;
    final String? id;
    final String? user;
    final List<OrderItem> orderItems;
    final String? status;
    final String? orderNumber;
    final int? totalPrice;
    final DateTime? createdDate;
    final int? v;
    final String? payment;

    factory PaymentModel.fromJson(Map<String, dynamic> json){ 
        return PaymentModel(
            shippingAddress: json["shippingAddress"] == null ? null : ShippingAddress.fromJson(json["shippingAddress"]),
            id: json["_id"],
            user: json["user"],
            orderItems: json["orderItems"] == null ? [] : List<OrderItem>.from(json["orderItems"]!.map((x) => OrderItem.fromJson(x))),
            status: json["status"],
            orderNumber: json["orderNumber"],
            totalPrice: json["totalPrice"],
            createdDate: DateTime.tryParse(json["createdDate"] ?? ""),
            v: json["__v"],
            payment: json["payment"],
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
