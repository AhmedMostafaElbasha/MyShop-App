import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
// import '../widgets/cart_item.dart' as cartItem;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: <Widget>[
          CartDetailBar(cart: cart),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title: cart.items.values.toList()[index].title,
                productId: cart.items.keys.toList()[index],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartDetailBar extends StatelessWidget {
  const CartDetailBar({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Spacer(),
            Chip(
              label: Text(
                '\$${cart.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.title.color,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            PlaceOrderButton(cart: cart)
          ],
        ),
      ),
    );
  }
}

class PlaceOrderButton extends StatefulWidget {
  const PlaceOrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<PlaceOrderButton> {
  @override
  Widget build(BuildContext context) {
    var _isLoading = false;

    return FlatButton(
      child: !_isLoading ? Text('PLACE ORDER') : CircularProgressIndicator(),
      onPressed: (widget.cart.totalAmount == 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );

                setState(() {
                  _isLoading = false;
                });

                widget.cart.clearCart();

                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Order Placed Successfully'),
                ));
              } catch (error) {
                setState(() {
                  _isLoading = false;
                });
                
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('Order Placement Failed'),
                ));
              }
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
