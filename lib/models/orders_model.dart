import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  String id, name, user_id, phone, address, email, status;
  int discount, total, created_at;
  List<OrderproductModel> products;

  OrdersModel(
      {required this.address,
      required this.created_at,
      required this.discount,
      required this.email,
      required this.id,
      required this.name,
      required this.phone,
      required this.products,
      required this.status,
      required this.total,
      required this.user_id});

  factory OrdersModel.fromjson(Map<String, dynamic> json, String id) {
    return OrdersModel(
        address: json['address'] ?? '',
        created_at: json['created_at'] ?? 0,
        discount: json['discount'] ?? 0,
        email: json['email'] ?? '',
        id: id,
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        products: List<OrderproductModel>.from(
            json['products'].map((e) => OrderproductModel.fromjson(e))),
        status: json['status'] ?? '',
        total: json['total'] ?? 0,
        user_id: json['user_id'] ?? '');
  }

  static List<OrdersModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
            (e) => OrdersModel.fromjson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}

class OrderproductModel {
  String id, name, image;
  String category;
  int quantity, single_price, total_price;

  OrderproductModel(
      {required this.id,
      required this.image,
      required this.name,
      required this.category,
      required this.quantity,
      required this.single_price,
      required this.total_price});

  factory OrderproductModel.fromjson(Map<String, dynamic> json) {
    return OrderproductModel(
        id: json['id'] ?? '',
        image: json['image'] ?? '',
        name: json['name'] ?? '',
        quantity: json['quantity'] ?? 0,
        single_price: json['single_price'] ?? 0,
        total_price: json['total_price'] ?? 0,
        category: json['category'] ?? '');
  }
}
