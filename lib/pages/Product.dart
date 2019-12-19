import 'package:first_app/models/product.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../widgets/ui_elements/TitleDefault.dart';
import '../widgets/products/PriceTag.dart';
import '../widgets/products/AddressTag.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure ?'),
          content: Text('This action cannot be undone!'),
          actions: <Widget>[
            FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
                // this.onDelete();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(product.title),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.white,
                onPressed: () => _showWarningDialog(context),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                height: 300.0,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/placeholder.jpg'),
              ),
              AddressTag('8624 Hawthorne Road Loganville, GA 30052'),
              Container(
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
              ),
            ],
          ),
        ));
  }
}
