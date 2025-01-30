import 'package:flutter/material.dart';
import 'package:shoporia_app/containers/category_container.dart';
import 'package:shoporia_app/containers/discount_container.dart';
import 'package:shoporia_app/containers/home_page_maker_container.dart';
import 'package:shoporia_app/containers/promo_container.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Best Deals',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PromoContainer(),
            DiscountContainer(),
            CategoryContainer(),
            HomePageMakerContainer()
          ],
        ),
      ),
    );
  }
}
