import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/datas/cart_product.dart';
import 'package:loja_virtual_flutter/datas/product_data.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/ui/cart_screen.dart';
import 'package:loja_virtual_flutter/ui/login_screen.dart';

class CategoryScreen extends StatefulWidget {

  final ProductData product;
  CategoryScreen(this.product);

  @override
  _CategoryScreenState createState() => _CategoryScreenState(product);
}

class _CategoryScreenState extends State<CategoryScreen> {

  final ProductData product;
  _CategoryScreenState(this.product);
  String color;

  @override
  Widget build(BuildContext context) {

    final primarycolor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url){
                return NetworkImage(url);
              }).toList(),
              dotSize: 5,
              dotSpacing: 15,
              dotBgColor: Colors.transparent,
              dotColor: primarycolor,
              dotIncreasedColor: primarycolor,
              autoplay: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primarycolor
                  ),
                ),
                SizedBox(height: 16,),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 34,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5
                    ),
                    children: product.color.map((color){
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            this.color = color;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: color == this.color ? primarycolor : Colors.grey[400],
                              width: 3
                            )
                          ),
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            color,
                            style: TextStyle(
                              color: color == this.color ? primarycolor : Colors.grey[400],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 16,),
                SizedBox(
                  height: 44,
                  child: RaisedButton(
                    onPressed: this.color != null ? (){
                      if(UserModel.of(context).isLoggedIn()){
                        CartProduct cartProduct = CartProduct();

                        cartProduct.color = color;
                        cartProduct.quantity = 1;
                        cartProduct.pid = product.id;
                        cartProduct.category = product.category;

                        CartModel.of(context).addCartItem(cartProduct);

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CartScreen())
                        );
                      } else{
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );
                      }
                    } : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn() ? "Adicionar ao carrinho" : "Entre para comprar",
                      style: TextStyle(fontSize: 18),
                    ),
                    color: primarycolor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16,),
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

