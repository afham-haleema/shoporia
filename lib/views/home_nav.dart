import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoporia_app/providers/cart_provider.dart';
import 'package:shoporia_app/providers/user_provider.dart';
import 'package:shoporia_app/views/cart_page.dart';
import 'package:shoporia_app/views/home.dart';
import 'package:shoporia_app/views/orders_page.dart';
import 'package:shoporia_app/views/profile_page.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false);
    super.initState();
  }

  int selectedindex = 0;
  List pages = [Home(), OrdersPage(), CartPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedindex,
        onTap: (value) {
          setState(() {
            selectedindex = value;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey.shade400,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined), label: 'Orders'),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(builder: (context, value, child) {
                if (value.carts.length > 0) {
                  return Badge(
                    label: Text(value.carts.length.toString()),
                    child: Icon(Icons.shopping_cart_outlined),
                    backgroundColor: Colors.red.shade500,
                  );
                }
                return Icon(Icons.shopping_cart_outlined);
              }),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
        ],
      ),
    );
  }
}
