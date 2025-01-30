import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  String name;
  String description;
  String image;
  String category;
  String id;
  int old_price;
  int new_price;
  int maxQuantity;
  // int quantity;

  ProductsModel({
    required this.category,
    required this.description,
    required this.id,
    required this.image,
    required this.maxQuantity,
    required this.name,
    required this.new_price,
    required this.old_price,
    // required this.quantity});
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json, id) {
    return ProductsModel(
      id: id ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      image: json['image'] ?? "",
      old_price: json['old_price'] ?? 0,
      new_price: json['new_price'] ?? 0,
      maxQuantity: json['maxQuantity'] ?? 0,
      // quantity: json['quantity'] ?? 0,
      category: json['category'] ?? "",
    );
  }

  static List<ProductsModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) =>
            ProductsModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
