import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFavorite;

  ProductsGrid({@required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context, listen: false);
    final products = isFavorite ? productsData.favoriteItems : productsData.products;

    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (contextt, index) => ChangeNotifierProvider.value(
        value: products[index],
        // create: (context) => products[index],
        child: ProductItem(
          // title: products[index].title,
          // id: products[index].id,
          // imageUrl: products[index].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
