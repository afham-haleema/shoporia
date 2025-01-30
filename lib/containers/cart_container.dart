import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoporia_app/constants/discount.dart';
import 'package:shoporia_app/models/cart_model.dart';
import 'package:shoporia_app/providers/cart_provider.dart';

class CartContainer extends StatefulWidget {
  final String name, image, productId;
  final int new_price, old_price, maxQuantity, selectedQuantity;
  const CartContainer(
      {super.key,
      required this.image,
      required this.maxQuantity,
      required this.name,
      required this.new_price,
      required this.old_price,
      required this.productId,
      required this.selectedQuantity});

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  int count = 1;

  increaseCount(int max) async {
    if (count >= max) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('maximum qty reached')));
    } else {
      Provider.of<CartProvider>(context, listen: false)
          .addToCart(CartModel(productId: widget.productId, quantity: count));
      setState(() {
        count++;
      });
    }
  }

  decreaseCount() async {
    if (count > 1) {
      Provider.of<CartProvider>(context, listen: false)
          .decreaseCount(widget.productId);
      setState(() {
        count--;
      });
    }
  }

  @override
  void initState() {
    count = widget.selectedQuantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  child: Image.network(widget.image),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.name.substring(0, 1).toUpperCase()}${widget.name.substring(1)}',
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Text(
                            'BHD ${widget.new_price}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'BHD ${widget.old_price}',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Colors.grey),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.green,
                            size: 20,
                          ),
                          Text(
                            '${discount(widget.old_price, widget.new_price)}%',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .deleteItem(widget.productId);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade400,
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  'Quantity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300),
                  child: IconButton(
                      onPressed: () async {
                        increaseCount(widget.maxQuantity);
                      },
                      icon: Icon(Icons.add)),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '${count}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade300),
                  child: IconButton(
                      onPressed: () async {
                        decreaseCount();
                      },
                      icon: Icon(Icons.remove)),
                ),
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: 10,
                ),
                Text('Total:'),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'BHD ${widget.new_price * count}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
