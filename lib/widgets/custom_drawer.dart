import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/tiles/drawer_tile.dart';
import 'package:loja_virtual_flutter/ui/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _builDrawerBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 112, 128, 144), // Slate Gray
            Color.fromARGB(255, 242, 242, 242) // Anti-Flash White
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _builDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32, top: 16),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: 8,
                        left: 0,
                        child: Text(
                          "Xablau\nCutelaria",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            //color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: ScopedModelDescendant<UserModel>(
                          builder: (context, child, model){
                            print(model.isLoggedIn());
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  child: Text(
                                    !model.isLoggedIn() ? "Entre ou cadastre-se" : "Sair",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: (){
                                    if(!model.isLoggedIn()) {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                                    } else{
                                      model.signOut();
                                    }
                                  },
                                )
                              ],
                            );
                          },
                        )
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Início", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.shopping_cart, "Carrinho", pageController, 2),
              DrawerTile(Icons.location_on, "Lojas", pageController, 3),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos", pageController, 4),
            ],
          )
        ],
      ),
    );
  }
}
