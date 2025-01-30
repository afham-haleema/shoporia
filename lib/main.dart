import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:shoporia_app/controllers/auth_service.dart';
import 'package:shoporia_app/firebase_options.dart';
import 'package:shoporia_app/providers/cart_provider.dart';
import 'package:shoporia_app/providers/user_provider.dart';
import 'package:shoporia_app/views/cart_page.dart';
import 'package:shoporia_app/views/checkout_page.dart';
import 'package:shoporia_app/views/discount_page.dart';
import 'package:shoporia_app/views/home_nav.dart';
import 'package:shoporia_app/views/login.dart';
import 'package:shoporia_app/views/orders_page.dart';
import 'package:shoporia_app/views/signup.dart';
import 'package:shoporia_app/views/specific_products.dart';
import 'package:shoporia_app/views/splash_screen.dart';
import 'package:shoporia_app/views/update_profile.dart';
import 'package:shoporia_app/views/view_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: '.env');
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (context) => CartProvider())
      ],
      child: MaterialApp(
        title: 'Shoporia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(188, 206, 204, 255)),
          useMaterial3: true,
        ),
        routes: {
          '/': (context) => SplashScreen(),
          '/checkuser': (context) => CheckUser(),
          '/login': (context) => Login(),
          '/home': (context) => HomeNav(),
          '/signup': (context) => Signup(),
          '/update_profile': (context) => UpdateProfile(),
          '/discount': (context) => DiscountPage(),
          '/specific': (context) => SpecificProducts(),
          '/view_product': (context) => ViewProduct(),
          '/cart': (context) => CartPage(),
          '/checkout': (context) => CheckoutPage(),
          '/orders': (context) => OrdersPage(),
          '/view_order': (context) => Vieworder(),
        },
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushNamed(context, '/home');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
