import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;

  UserProductItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.price,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: ListTile(
          title: Text(title),
          subtitle: Text('\$${price.toStringAsFixed(2)}'),
          // leading: CircleAvatar(
          //   backgroundImage: NetworkImage(imageUrl),
          // ),
          leading: Container(
            height: double.infinity,
            width: 80,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AddProductScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  Provider.of<ProductsProvider>(context, listen: false)
                      .removeProduct(id);
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Product Item Deleted.'),
                      duration: Duration(seconds: 2),
                    ),
                  );    
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
