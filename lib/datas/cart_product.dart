import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual_flutter/datas/product_data.dart';

class CartProduct{
  String cid; // Category id
  String pid; // Product id
  String category;
  int quantity;
  String color;

  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    color = document.data["color"];
  }

  Map<String, dynamic> toMap(){
    return {
      "category" : category,
      "pid" : pid,
      "quantity" : quantity,
      "color" : color,
      "product" : productData.toResumedMap()
    };
  }
}