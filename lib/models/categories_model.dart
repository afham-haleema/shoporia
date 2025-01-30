import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  String name, image, id;
  int priority;

  CategoriesModel(
      {required this.id,
      required this.image,
      required this.name,
      required this.priority});

  factory CategoriesModel.fromJson(Map<String, dynamic> json, id) {
    return CategoriesModel(
        id: id ?? "",
        image: json['image'] ?? "",
        name: json['name'] ?? "",
        priority: json['priority'] ?? 0);
  }

  static List<CategoriesModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) =>
            CategoriesModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
