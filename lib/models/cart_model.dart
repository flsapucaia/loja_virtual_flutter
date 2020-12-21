import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/datas/cart_product.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:correios_frete/correios_frete.dart';

class CartModel extends Model{
  UserModel user;
  bool isLoading = false;
  String couponCode;
  int discountPercentage = 0;
  String cep  = "";
  double shipPrice = 0;

  List<CartProduct> products = [];

  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCartItens();
    }
  }

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("cart").add(cartProduct.toMap()).then((doc){
        cartProduct.cid = doc.documentID;
      });
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.cid).delete();
    products.remove(cartProduct);
    notifyListeners();
  }

  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
      .document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void _loadCartItens() async{
    QuerySnapshot querry = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .getDocuments();
    products = querry.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null){
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductsPrice() * discountPercentage / 100;
  }

  void setCep(String cep){
    this.cep = cep;
    print(this.cep);
  }

  void calcShipPrice(String cep) async{
    Result result = await CalcPriceTerm("","","04510","40800866",cep,"1","1","20","20","20",
        "20","N","0","N","xml","3");
    double valor = double.parse(result.valor.toString().replaceAll(",", "."));
    setShipPrice(valor);
  }

  void setShipPrice(double shipPrice){
    this.shipPrice = shipPrice;
  }

  double getShipPrice(){
    return shipPrice;
  }

  //  double getShipPrice(){              // TODO: Testar biblioteca de calculo de frete
  //   double valor = 9.99;
  //   return valor;
  // }

  Future<String> finishOrder() async{
    if(products.length == 0){
      return null;
    }
    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = this.shipPrice;
    double discount = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection("orders").add({
      "clientId": user.firebaseUser.uid,
      "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
      "shipPrice": shipPrice,
      "productsPrice": productsPrice,
      "discount": discount,
      "totalPrice": productsPrice - discount + shipPrice,
      "status": 1
      }
    );
    await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("orders")
        .document(refOrder.documentID).setData({
          "OrderId": refOrder.documentID
        }
    );
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }
    products.clear();
    couponCode = null;
    discountPercentage = 0;
    isLoading = false;
    cep = "";
    shipPrice = 0;
    notifyListeners();

    return refOrder.documentID;
  }
}