import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/tiles/cart_tile.dart';
import 'package:loja_virtual_flutter/ui/login_screen.dart';
import 'package:loja_virtual_flutter/widgets/cart_price.dart';
import 'package:loja_virtual_flutter/widgets/discount_card.dart';
import 'package:loja_virtual_flutter/widgets/ship_card.dart';
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
      body: ScopedModelDescendant<CartModel>(
        // ignore: missing_return
        builder: (context, child, model){
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(child: CircularProgressIndicator(),);
          } else if(!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, size: 80, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16,),
                  Text(
                    "Faça o login para comprar.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    ),
                  SizedBox(height: 16,),
                  RaisedButton(
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    },
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            );
          } else if(model.products == null || model.products.length == 0){
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 16,),
                    Text(
                      "Nenhum produto no carrinho!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16,),
                  ],
                ),
              );
            } else{
                return ListView(
                  children: <Widget>[
                    Column(
                      children: model.products.map((product) => CartTile(product)).toList(),
                    ),
                    DiscountCard(),
                    ShipCard(),
                    CartPrice(() async{
                     String orderId = await model.finishOrder();
                     if(orderId != null){
                       print(orderId);
                     }
                    }),
                  ],
                );
            }
        },
      ),
    );
  }
}
