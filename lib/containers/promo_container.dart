import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoporia_app/controllers/db_service.dart';
import 'package:shoporia_app/models/promo_banner_model.dart';

class PromoContainer extends StatefulWidget {
  const PromoContainer({super.key});

  @override
  State<PromoContainer> createState() => _PromoContainerState();
}

class _PromoContainerState extends State<PromoContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readPromos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PromoBannerModel> promos =
              PromoBannerModel.fromJsonList(snapshot.data!.docs)
                  as List<PromoBannerModel>;
          if (promos.isEmpty) {
            return SizedBox();
          } else {
            return CarouselSlider(
                items: promos
                    .map((promo) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/specific',
                                arguments: {'name': promo.category});
                          },
                          child: Image.network(promo.image, fit: BoxFit.fill),
                        ))
                    .toList(),
                options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    aspectRatio: 16 / 8,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal));
          }
        } else {
          return Shimmer(
              child: Container(
                width: double.infinity,
                height: 300,
              ),
              gradient:
                  LinearGradient(colors: [Colors.grey.shade200, Colors.white]));
        }
      },
    );
  }
}
