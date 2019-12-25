import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Consumer<ProductsProvider>(
          builder: (context, productsData, child) => ListView.builder(
            itemCount: productsData.products.length,
            itemBuilder: (_, index) => UserProductItem(
              title: productsData.products[index].title,
              imageUrl: productsData.products[index].imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}
