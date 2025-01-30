import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future createPaymentIntent(
    {required String name,
    required String address,
    required String amount}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  final secretKey = dotenv.env['STRIPE_SECRET_KEY']!;
  final body = {
    'amount': amount,
    'currency': 'aed',
    'automatic_payment_methods[enabled]': 'true',
    'description': 'Shop Payment',
    'shipping[name]': name,
    'shipping[address][line1]': address,
    'shipping[address][country]': 'UAE'
  };
  final response = await http.post(url,
      headers: {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    return json;
  } else {
    print('Error in calling payment Intent');
  }
}
