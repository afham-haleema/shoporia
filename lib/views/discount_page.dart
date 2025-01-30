import 'package:flutter/material.dart';
import 'package:shoporia_app/controllers/db_service.dart';
import 'package:shoporia_app/models/coupon_model.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discounts',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: StreamBuilder(
        stream: DbService().readCoupons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CouponModel> discounts =
                CouponModel.fromJsonList(snapshot.data!.docs)
                    as List<CouponModel>;
            if (discounts.isEmpty) {
              return SizedBox();
            } else {
              return ListView.builder(
                itemCount: discounts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.discount_outlined),
                    title: Text(discounts[index].code),
                    subtitle: Text(discounts[index].description),
                  );
                },
              );
            }
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
