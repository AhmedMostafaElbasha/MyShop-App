import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Please Wait...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) => OrderItem(
                orderItem: orderData.orders[index],
              ),
            ),
    );
  }
}
