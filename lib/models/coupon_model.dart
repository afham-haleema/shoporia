import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String id;
  String description;
  String code;
  int discount;

  CouponModel(
      {required this.code,
      required this.description,
      required this.discount,
      required this.id});

  factory CouponModel.fromJson(Map<String, dynamic> json, id) {
    return CouponModel(
        id: id ?? "",
        code: json['code'] ?? "",
        discount: json['discount'] ?? 0,
        description: json['description'] ?? "");
  }

  static List<CouponModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
            (e) => CouponModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
