import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoporia_app/constants/discount.dart';
import 'package:shoporia_app/models/cart_model.dart';
import 'package:shoporia_app/models/products_model.dart';
import 'package:shoporia_app/providers/cart_provider.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ProductsModel;
    return Scaffold(
        appBar: AppBar(
          title: Text('Product details'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  arguments.image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 300,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${arguments.name.substring(0, 1).toUpperCase()}${arguments.name.substring(1)}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'BHD ${arguments.new_price}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'BHD ${arguments.old_price}',
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.grey,
                          color: Colors.grey,
                          fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.green,
                      size: 30,
                    ),
                    Text(
                      '${discount(arguments.old_price, arguments.new_price)}%',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                arguments.maxQuantity == 0
                    ? Text(
                        'out of stock',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            fontSize: 16),
                      )
                    : Text(
                        'Only ${arguments.maxQuantity} stock remaining',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(arguments.description),
              ],
            ),
          ),
        ),
        bottomNavigationBar: arguments.maxQuantity != 0
            ? Row(
                children: [
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .5,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(CartModel(
                                productId: arguments.id, quantity: 1));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added to cart')));
                      },
                      child: Text('Add to cart'),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .5,
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(CartModel(
                                productId: arguments.id, quantity: 1));
                        Navigator.pushNamed(context, '/checkout');
                      },
                      child: Text('Buy Now'),
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder()),
                    ),
                  ),
                ],
              )
            : SizedBox());
  }
}
