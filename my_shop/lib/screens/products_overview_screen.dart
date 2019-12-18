import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

enum FilterType {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterType selectedValue) {
              setState(() {
                if (selectedValue == FilterType.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites Only'),
                value: FilterType.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterType.All,
              ),
            ],
          )
        ],
      ),
      body: new ProductsGrid(
        isFavorite: _showOnlyFavorites,
      ),
    );
  }
}
