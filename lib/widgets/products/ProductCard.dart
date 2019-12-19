import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/product.dart';
import '../../widgets/ui_elements/TitleDefault.dart';

import './AddressTag.dart';
import './PriceTag.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(product.title),
          SizedBox(width: 8.0),
          Flexible(
            flex: 2,
            child: PriceTag(product.price.toString()),
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            iconSize: 30,
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.pushNamed<bool>(
              context,
              '/product/' + model.allProducts[productIndex].id,
            ),
          ),
          IconButton(
            icon: Icon(model.allProducts[productIndex].isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
            iconSize: 30,
            onPressed: () {
              model.selectProduct(model.allProducts[productIndex].id);
              model.toggleProductFavoriteStatus();
            },
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
            ),
            child: FadeInImage(
              image: NetworkImage(product.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/placeholder.jpg'),
            ),
          ),
          _buildTitle(),
          AddressTag('8624 Hawthorne Road Loganville, GA 30052'),
          Text(product.userEmail),
          _buildActionButton(context),
        ],
      ),
    );
  }
}
