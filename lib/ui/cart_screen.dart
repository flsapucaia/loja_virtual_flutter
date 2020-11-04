import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meu Carrinho"),
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: 8),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int cartCount = model.products.length;
                return Text(
                  "${cartCount ?? 0} ${cartCount ==1 ? "Item" : "Itens"}",
                  style: TextStyle(fontSize: 16),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
