class ProductModel {
    ProductModel({
        required this.id,
        required this.name,
        required this.brand,
        required this.category,
        required this.price,
        required this.stock,
        required this.createdAt,
        required this.createdBy,
        required this.imageUrls,
        required this.description,
        required this.v,
    });

    final String? id;
    final String? name;
    final String? brand;
    final String? category;
    final int? price;
    final int? stock;
    final DateTime? createdAt;
    final String? createdBy;
    final List<String> imageUrls;
    final String? description;
    final int? v;

    factory ProductModel.fromJson(Map<String, dynamic> json){ 
        return ProductModel(
            id: json["_id"],
            name: json["name"],
            brand: json["brand"],
            category: json["category"],
            price: json["price"],
            stock: json["stock"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            createdBy: json["createdBy"],
            imageUrls: json["imageUrls"] == null ? [] : List<String>.from(json["imageUrls"]!.map((x) => x)),
            description: json["description"],
            v: json["__v"],
        );
    }

}
