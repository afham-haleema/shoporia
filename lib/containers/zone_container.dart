import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shoporia_app/constants/discount.dart';
import 'package:shoporia_app/controllers/db_service.dart';
import 'package:shoporia_app/models/products_model.dart';

class ZoneContainer extends StatefulWidget {
  final String category;
  const ZoneContainer({super.key, required this.category});

  @override
  State<ZoneContainer> createState() => _ZoneContainerState();
}

class _ZoneContainerState extends State<ZoneContainer> {
  Widget specialQuote({required int price, required int discount}) {
    List<String> quotes = ['Starting at ${price}', 'Get upto ${discount}% off'];
    int random = Random().nextInt(2);
    return Text(
      quotes[random],
      style: TextStyle(color: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readProducts(widget.category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProductsModel> products =
              ProductsModel.fromJsonList(snapshot.data!.docs)
                  as List<ProductsModel>;
          if (products.isEmpty) {
            return Center(
              child: Text('No products found'),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(4),
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${widget.category.substring(0, 1).toUpperCase() + widget.category.substring(1)}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/specific',
                                  arguments: {'name': widget.category});
                            },
                            icon: Icon(Icons.chevron_right))
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 4,
                    children: [
                      for (int i = 0;
                          i < (products.length > 4 ? 4 : products.length);
                          i++)
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/view_product',
                                arguments: products[i]);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * .43,
                            height: 200,
                            color: Colors.white,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child: Image.network(
                                  products[i].image,
                                  height: 120,
                                )),
                                Text(
                                  '${products[i].name.substring(0, 1).toUpperCase()}${products[i].name.substring(1)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                specialQuote(
                                    price: products[i].new_price,
                                    discount: int.parse(discount(
                                        products[i].old_price,
                                        products[i].new_price)))
                              ],
                            ),
                          ),
                        )
                    ],
                  )
                ],
              ),
            );
          }
        } else {
          return Shimmer(
              child: Container(
                width: double.infinity,
                height: 400,
              ),
              gradient:
                  LinearGradient(colors: [Colors.grey.shade200, Colors.white]));
        }
      },
    );
  }
}
