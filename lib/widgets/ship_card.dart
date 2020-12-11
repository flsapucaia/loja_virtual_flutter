import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/cart_model.dart';

class ShipCard extends StatefulWidget {
  @override
  _ShipCardState createState() => _ShipCardState();
}

class _ShipCardState extends State<ShipCard> {
  final TextEditingController cepController = TextEditingController();
  //GlobalKey<FormState> _cepKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.location_on),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              //key: _cepKey,
              controller: cepController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu CEP"
              ),
              onFieldSubmitted: (cep){
                if(cep.length == 8){
                  CartModel.of(context).setCep(cep);
                } else{
                  Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Cep inválido"),
                        backgroundColor: Colors.red,
                      )
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}