import 'dart:convert';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/user.dart';

final URL = 'https://flutter-products-c38a5.firebaseio.com/';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selectedProdId;
  bool _isLoading = false;

  Future<bool> addProduct(Product product) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': product.title,
      'description': product.description,
      'image':
          'https://images-platform.99static.com/XBtH07UYycmRkfOBXBoudCic1Nk=/filters:quality(100)/99designs-contests-attachments/112/112915/attachment_112915908',
      'price': product.price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
    };

    return http
        .post('${URL}products.json', body: json.encode(productData))
        .then((http.Response resp) {
          if(resp.statusCode != 200 && resp.statusCode != 201) {
            _isLoading = false;
            notifyListeners();
            notifyListeners();
            return false;
          } else {
            final Map<String, dynamic> response = json.decode(resp.body);
            _products.add(Product(
              id: response['name'],
              title: product.title,
              description: product.description,
              image: product.image,
              price: product.price,
              userEmail: _authenticatedUser.email,
              userId: _authenticatedUser.id,
            ));
            _isLoading = false;
            notifyListeners();
            return true;
          }
    });
  }
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;

  String get selectedProductId {
    return _selectedProdId;
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selectedProdId;
    });
  }

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  Product get selectedProduct {
    if (_selectedProdId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selectedProdId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<Null> updateProduct(Product product) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateDate = {
      'title': product.title,
      'description': product.description,
      'image':
          'https://images-platform.99static.com/XBtH07UYycmRkfOBXBoudCic1Nk=/filters:quality(100)/99designs-contests-attachments/112/112915/attachment_112915908',
      'price': product.price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
    };
    return http
        .put('${URL}products/${selectedProduct.id}.json',
            body: json.encode(updateDate))
        .then((http.Response resp) {
      _products[selectedProductIndex] = Product(
        id: product.id,
        title: product.title,
        description: product.description,
        image: product.image,
        price: product.price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: selectedProduct.isFavorite,
      );
      _isLoading = false;
      notifyListeners();
    });
  }

  void deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selectedProdId = null;
    notifyListeners();
    http
        .delete('${URL}products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;

      // fetchProducts();
      notifyListeners();
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http.get('${URL}products.json').then((http.Response response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String productId, dynamic item) {
        final Product product = Product(
          id: productId,
          title: item['title'],
          description: item['description'],
          image: item['image'],
          price: item['price'],
          userEmail: item['userEmail'],
          userId: item['userId'],
        );
        fetchedProductList.add(product);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = _products[selectedProductIndex].isFavorite;

    _products[selectedProductIndex] = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      image: selectedProduct.image,
      price: selectedProduct.price,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFavorite: !isCurrentlyFavorite,
    );
    notifyListeners();
  }

  void selectProduct(String productId) {
    _selectedProdId = productId;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    _authenticatedUser = User(id: 'xx', email: email, password: password);
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
