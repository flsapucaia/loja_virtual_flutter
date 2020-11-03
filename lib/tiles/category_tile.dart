import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/ui/products_screen.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image(
        image: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(
        snapshot.data["title"],
        style: TextStyle(fontSize: 18),
      ),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(snapshot)));
      },
    );
  }
}
