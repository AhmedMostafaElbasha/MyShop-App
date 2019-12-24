import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as order;

class OrderItem extends StatefulWidget {
  final order.OrderItem orderItem;

  OrderItem({@required this.orderItem});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expandable = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy  hh:mm')
                .format(widget.orderItem.orderDate)),
            trailing: IconButton(
              icon: Icon(_expandable ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expandable = !_expandable;
                });
              },
            ),
          ),
          if (_expandable)
            Container(
              height: min(widget.orderItem.products.length * 20.0 + 10, 100),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ListView(
                children: widget.orderItem.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${product.quantity}x \$${product.price} ',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
