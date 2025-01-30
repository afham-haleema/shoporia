import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shoporia_app/constants/payment.dart';
import 'package:shoporia_app/controllers/db_service.dart';
import 'package:shoporia_app/controllers/mail_service.dart';
import 'package:shoporia_app/models/orders_model.dart';
import 'package:shoporia_app/providers/cart_provider.dart';
import 'package:shoporia_app/providers/user_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController couponController = TextEditingController();
  int discount = 0;
  int toPay = 0;
  String discountText = '';
  bool paymentSuccess = false;
  Map<String, dynamic> dataOfOrder = {};

  discountCalculator(int percent, int totalCost) {
    discount = (percent * totalCost) ~/ 100;
    setState(() {});
  }

  Future<void> initpaymentSheet(int cost) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false);
      final data = await createPaymentIntent(
          name: user.name,
          address: user.address,
          amount: (cost * 100).toString());
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              customFlow: false,
              merchantDisplayName: 'Shoporia Store payment',
              paymentIntentClientSecret: data['client_secret'],
              customerEphemeralKeySecret: data['ephermalKey'],
              customerId: data['id'],
              style: ThemeMode.dark));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('error :${e}')));
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userData, child) => Consumer<CartProvider>(
            builder: (context, cartData, child) {
              return Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(userData.email),
                                Text(userData.address),
                                Text(userData.phone)
                              ],
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/update_profile');
                              },
                              icon: Icon(Icons.edit_outlined))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Have a coupon ?'),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: couponController,
                            decoration: InputDecoration(
                                labelText: 'Coupon code',
                                hintText: 'Enter coupon for extra discount',
                                border: InputBorder.none,
                                fillColor: Colors.grey.shade200,
                                filled: true),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
                              QuerySnapshot querySnapshot = await DbService()
                                  .verifyDiscount(
                                      code:
                                          couponController.text.toUpperCase());
                              if (querySnapshot.docs.isNotEmpty) {
                                QueryDocumentSnapshot doc =
                                    querySnapshot.docs.first;
                                String code = doc.get('code');
                                int percent = doc.get('discount');
                                discountText =
                                    'A discount of ${percent} has been applied';
                                discountCalculator(percent, cartData.totalCost);
                              } else {
                                discountText = 'No discount code found';
                              }
                              setState(() {});
                            },
                            child: Text('Apply'))
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    discountText == '' ? Container() : Text(discountText),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Total quantity of products : ${cartData.totalQuantity}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Subtotal : ${cartData.totalCost}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    Text(
                      'Extra discount - BHD ${discount}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Divider(),
                    Text(
                      'Total payable : BHD ${cartData.totalCost - discount}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
            onPressed: () async {
              final user = Provider.of<UserProvider>(context, listen: false);
              if (user.name == '' ||
                  user.address == '' ||
                  user.phone == '' ||
                  user.email == '') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please fill your delivery details')));
                return;
              }
              await initpaymentSheet(
                  Provider.of<CartProvider>(context, listen: false).totalCost -
                      discount);
              try {
                await Stripe.instance.presentPaymentSheet();
                final cart = Provider.of<CartProvider>(context, listen: false);
                User? currentUser = FirebaseAuth.instance.currentUser;
                List products = [];
                for (int i = 0; i < cart.products.length; i++) {
                  products.add({
                    'id': cart.products[i].id,
                    'name': cart.products[i].name,
                    'image': cart.products[i].image,
                    'single_price': cart.products[i].new_price,
                    'total_price':
                        cart.products[i].new_price * cart.carts[i].quantity,
                    'quantity': cart.carts[i].quantity,
                  });
                }

                Map<String, dynamic> orderData = {
                  'user_id': currentUser!.uid,
                  'name': user.name,
                  'email': user.email,
                  'address': user.address,
                  'phone': user.phone,
                  'discount': discount,
                  'total': cart.totalCost - discount,
                  'products': products,
                  'status': 'PAID',
                  'created_at': DateTime.now().millisecondsSinceEpoch,
                };

                dataOfOrder = orderData;

                await DbService().createOrder(data: orderData);
                for (int i = 0; i < cart.products.length; i++) {
                  DbService().decrementQty(
                      productd: cart.products[i].id,
                      qty: cart.carts[i].quantity);
                }
                await DbService().emptyCart();

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Payment done',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Payment Failed',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red.shade400,
                  ),
                );
              }
              if (paymentSuccess) {
                MailService().sendMailfromGmail(
                    user.email, OrdersModel.fromjson(dataOfOrder, ''));
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, foregroundColor: Colors.white),
            child: Text('Proceed to pay')),
      ),
    );
  }
}
