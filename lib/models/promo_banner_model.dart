import 'package:cloud_firestore/cloud_firestore.dart';

class PromoBannerModel {
  String title;
  String image;
  String category;
  String id;

  PromoBannerModel(
      {required this.category,
      required this.id,
      required this.image,
      required this.title});

  factory PromoBannerModel.fromJson(Map<String, dynamic> json, id) {
    return PromoBannerModel(
        id: id ?? "",
        image: json['image'] ?? "",
        title: json['title'] ?? 0,
        category: json['category'] ?? "");
  }

  static List<PromoBannerModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) =>
            PromoBannerModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
