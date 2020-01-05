import 'package:flutter/material.dart';
import 'package:my_shop/widgets/error_state.dart';
import 'package:my_shop/widgets/loading_state.dart';

import 'package:provider/provider.dart';

import '../widgets/user_product_item.dart';
import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/add_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: FutureBuilder(
          future:  Provider.of<ProductsProvider>(context, listen: false).fetchAndSetProducts(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return LoadingState();
            } else {
              if (dataSnapshot.error != null) {
                return ErrorState();
              } else {
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Consumer<ProductsProvider>(
                    builder: (context, productsData, child) => ListView.builder(
                      itemCount: productsData.products.length,
                      itemBuilder: (_, index) => UserProductItem(
                        id: productsData.products[index].id,
                        title: productsData.products[index].title,
                        imageUrl: productsData.products[index].imageUrl,
                        price: productsData.products[index].price,
                      ),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
