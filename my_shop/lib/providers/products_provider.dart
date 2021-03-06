import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this._products, this.userId);

  List<Product> get favoriteItems {
    return _products.where((product) => product.isFavorite).toList();
  }

  List<Product> get products {
    return [..._products];
  }

  Product findById(String id) {
    return products.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://myshop-99f16.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://myshop-99f16.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: favoriteData == null ? false : favoriteData[productId] ?? false,
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://myshop-99f16.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    var index = _products.indexWhere((product) => product.id == productId);
    if (index >= 0) {
      final url =
          'https://myshop-99f16.firebaseio.com/products/$productId.json?auth=$authToken';
      try {
        await http.patch(url,
            body: json.encode({
              'description': newProduct.description,
              'title': newProduct.title,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
        _products[index] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      print('...');
    }
  }

  Future<void> removeProduct(String productId) async {
    final url =
        'https://myshop-99f16.firebaseio.com/products/$productId.json?auth=$authToken';
    final existingProductIndex =
        _products.indexWhere((product) => product.id == productId);
    var existingProduct = _products[existingProductIndex];
    _products.removeWhere((product) => product.id == productId);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete this product item');
    }

    existingProduct = null;
  }
}
