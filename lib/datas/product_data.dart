import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  String category;
  String id;
  String title;
  String description;

  double price;

  List images;
  List color;

  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["item_title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"] + 0.0;
    images = snapshot.data["image"];
    color = snapshot.data["color"];
  }

  Map<String, dynamic> toResumedMap(){
    return{
      "title" : title,
      "description": description,
      "price" : price
    };
  }
}
