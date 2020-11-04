import 'package:flutter/material.dart';
import 'package:loja_virtual_flutter/models/user_model.dart';
import 'package:loja_virtual_flutter/ui/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignupScreen()));
              },
              child: Text(
                "+ CRIAR CONTA",
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.white
                ),
              ),
              textColor: Colors.white,
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            if(model.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "Email"
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // ignore: missing_return
                    validator: (text){
                      if(text.isEmpty || !text.contains("@")){
                        return "Email inválido";
                      }
                    },
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ),
                    obscureText: true,
                    // ignore: missing_return
                    validator: (text){
                      if(text.isEmpty || text.length <6){
                        return "Senha inválido";
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: (){
                        if(_emailController.text.isEmpty){
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Insira o email para recuperação."),
                                backgroundColor: Colors.red[700],
                                duration: Duration(seconds: 3),
                              )
                          );
                        } else {
                          model.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                              SnackBar(
                                content: Text("Email de recuperação de senha enviado."),
                                backgroundColor: Theme.of(context).primaryColor,
                                duration: Duration(seconds: 3),
                              )
                          );
                        }
                      },
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 16,),
                  RaisedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      if(_formKey.currentState.validate()){

                      }
                      model.signIn(
                        email: _emailController.text,
                        pass: _passController.text,
                        onSuccess: _onSuccess,
                        onFail: _onFail,
                      );
                    },
                  )
                ],
              ),
            );
          },
        )
    );
  }
  void _onSuccess(){
    Navigator.of(context).pop();
  }
  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("Falha ao entrar!"),
          backgroundColor: Colors.red[700],
          duration: Duration(seconds: 3),
        )
    );
  }
}