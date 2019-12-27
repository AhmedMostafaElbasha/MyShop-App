import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
    @required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(3),
                child: FittedBox(
                  child: Text('\$${price.toStringAsFixed(2)}'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              '\$${(price * quantity).toStringAsFixed(2)}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 20,
                  child: FlatButton(
                    child: Text('+', style: TextStyle(fontSize: 30), textAlign: TextAlign.center,),
                    textColor: Colors.green,
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false).increaseQuantity(productId);
                    },
                  ),
                ),
                SizedBox(width: 7,),
                Container(
                  width: 30,
                  child: FlatButton(
                    child: Text('-', style: TextStyle(fontSize: 40),  textAlign: TextAlign.center,),
                    textColor: Theme.of(context).errorColor,
                    onPressed: () {
                      if (quantity > 1) {
                        Provider.of<Cart>(context, listen: false).decreaseQuantity(productId);
                      } else {
                        return;
                      }      
                    },
                  ),
                ),
                SizedBox(width: 7,),
                Text('$quantity x', style: TextStyle(fontSize: 14),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
