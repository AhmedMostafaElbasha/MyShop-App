import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/http_exception.dart';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderDate;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.orderDate,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;

  List<OrderItem> get orders {
    return [..._orders];
  }

  Orders(this.authToken, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://myshop-99f16.firebaseio.com/orders.json?auth=$authToken';

    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          orderDate: DateTime.parse(orderData['orderDate']),
          products: (orderData['products'] as List<dynamic>)
              .map((cartItem) => CartItem(
                    id: cartItem['id'],
                    title: cartItem['title'],
                    price: cartItem['price'],
                    quantity: cartItem['quantity'],
                  ))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw HttpException('cannot fetch the orders data.');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://myshop-99f16.firebaseio.com/orders.json?auth=$authToken';

    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'orderDate': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cartItem) => {
                  'id': cartItem.id,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        products: cartProducts,
        amount: total,
        orderDate: timeStamp,
      ),
    );
    notifyListeners();
  }
}
