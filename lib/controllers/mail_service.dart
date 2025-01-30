import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shoporia_app/models/orders_model.dart';

class MailService {
  final gmailSmtp =
      gmail(dotenv.env['GMAIL_MAIL']!, dotenv.env['GMAIL_PASSWORD']!);

  sendMailfromGmail(String receiver, OrdersModel order) async {
    final message = Message()
      ..from = Address(dotenv.env['GMAIL_MAIL']!, 'No reply')
      ..recipients.add(receiver)
      ..subject = 'Order receipt'
      ..html = """
<body style=" font-family: Verdana, Geneva, Tahoma, sans-serif">
    <h1 style="text-align: center;">Orders Receipt</h1>

    <table style="width: 100%; border-collapse: collapse; font-family: Arial, sans-serif; margin:10px auto; max-width: 1000px;">
        <thead>
            <tr style="background-color: #f2f2f2; color: #333; text-align: left;">
                <th style="padding: 8px; border-bottom: 2px solid #ddd;">Image</th>
                <th style="padding: 8px; border-bottom: 2px solid #ddd;">Product</th>
                <th style="padding: 8px; border-bottom: 2px solid #ddd;">Price</th>
                <th style="padding: 8px; border-bottom: 2px solid #ddd;">Quantity</th>
                <th style="padding: 8px; border-bottom: 2px solid #ddd;">Total</th>
            </tr>
        </thead>

        <tbody>
        ${order.products.map((product) => """
<tr style="border-bottom: 1px solid #ddd; padding:  8px;">
                <td> <img src="${product.image}" alt="" style="width: 100px;"></td>
                <td style="padding: 8px;">${product.name}</td>
                <td style="padding: 8px;">₹${product.single_price}</td>
                <td style="padding: 8px;">${product.quantity}</td>
                <td style="padding: 8px;">₹${product.total_price}</td>
            </tr>
""").join("")}
    </tbody>
     
    </table>
    
    <br>

    <!-- discount and total will be in center -->
     <div class="total" style="width: 100%;   margin:   10px auto; max-width: 1000px;">
        <!-- <hr> -->

        <p style="text-align: right;  font-size: 16px; font-weight: 400;">Discount: - BHD${order.discount}</p>
        <p style="text-align: right;  font-size: 20px; font-weight: 800;">Total: BHD${order.total}</p>
     </div>
    <p style="text-align: center; font-size: 14px; color: #666;">Thank you for shopping with us!</p>
</body>
""";

    try {
      final SendReport = await send(message, gmailSmtp);
    } on MailerException catch (e) {
      for (var p in e.problems) {
        print('problem:${p.code} :${p.msg}');
      }
    }
  }
}
