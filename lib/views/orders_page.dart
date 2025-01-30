import 'package:flutter/material.dart';
import 'package:shoporia_app/containers/additional_confirm.dart';
import 'package:shoporia_app/controllers/db_service.dart';
import 'package:shoporia_app/models/orders_model.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  totalQuantitycalculator(List<OrderproductModel> products) {
    int qty = 0;
    products.map((e) => qty += e.quantity).toList();
    return qty;
  }

  Widget statusIcon(String status) {
    if (status == "PAID") {
      return statusContainer(
          text: "PAID", bgColor: Colors.lightGreen, textColor: Colors.white);
    }
    if (status == "SHIPPED") {
      return statusContainer(
          text: "SHIPPED", bgColor: Colors.yellow, textColor: Colors.black);
    } else if (status == "DELIVERED") {
      return statusContainer(
          text: "DELIVERED",
          bgColor: Colors.green.shade700,
          textColor: Colors.white);
    } else {
      return statusContainer(
          text: "CANCELED", bgColor: Colors.red, textColor: Colors.white);
    }
  }

  Widget statusContainer(
      {required String text,
      required Color bgColor,
      required Color textColor}) {
    return Container(
      color: bgColor,
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Orders',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          scrolledUnderElevation: 0,
          forceMaterialTransparency: true,
        ),
        body: StreamBuilder(
          stream: DbService().readOrder(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrdersModel> orders =
                  OrdersModel.fromJsonList(snapshot.data!.docs)
                      as List<OrdersModel>;

              if (orders.isEmpty) {
                return Center(
                  child: Text('No Orders Found'),
                );
              } else {
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, '/view_order',
                            arguments: orders[index]);
                      },
                      title: Text(
                          '${totalQuantitycalculator(orders[index].products)} Items Worth BHD ${orders[index].total}'),
                      subtitle: Text(
                          'Ordered on ${DateTime.fromMillisecondsSinceEpoch(orders[index].created_at).toString()}'),
                      trailing: statusIcon(orders[index].status),
                    );
                  },
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class Vieworder extends StatefulWidget {
  const Vieworder({super.key});

  @override
  State<Vieworder> createState() => _VieworderState();
}

class _VieworderState extends State<Vieworder> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Delivery Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                color: const Color.fromARGB(255, 223, 220, 220),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('order ID : ${arguments.id}'),
                    Text(
                        'order on : ${DateTime.fromMillisecondsSinceEpoch(arguments.created_at)}'),
                    Text('order by : ${arguments.name}'),
                    Text('Phone No : ${arguments.phone}'),
                    Text('Delivery address : ${arguments.address}'),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: arguments.products
                    .map((e) => Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(e.image),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                          '${e.name.substring(0, 1).toUpperCase()}${e.name.substring(1)}'))
                                ],
                              ),
                              Text(
                                'BHD ${e.single_price.toString()} x ${e.quantity.toString()}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'BHD ${e.total_price.toString()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Padding(
                padding: EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discount : BHD ${arguments.discount}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Total : BHD ${arguments.total}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Status : ${arguments.status}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * .95,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ModifyOrder(order: arguments));
                  },
                  child: Text('Modify Order'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ModifyOrder extends StatefulWidget {
  final OrdersModel order;
  const ModifyOrder({super.key, required this.order});

  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Modify this order'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose what do u want to do. ',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
          SizedBox(
            height: 15,
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => AdditionalConfirm(
                        contentType: 'After cancelling this cant be changed',
                        onNo: () {
                          Navigator.pop(context);
                        },
                        onYes: () async {
                          await DbService().updateOrder(
                              docId: widget.order.id,
                              data: {'status': 'CANCELED'});
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('order updated')));
                          Navigator.pop(context);
                          Navigator.pop(context);
                          setState(() {});
                        }));
              },
              child: Text(
                'Cancel Order',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}
