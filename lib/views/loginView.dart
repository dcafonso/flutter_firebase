import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/helpers/navegacaoHelper.dart';
import 'package:flutter_firebase/helpers/geralHelper.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _estaCarregando = false;
  final _controladorUsuario = TextEditingController();
  final _controladorSenha = TextEditingController();
  FocusNode focusNodeUsuario = FocusNode();
  FocusNode focusNodeSenha = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg.jpg"), fit: BoxFit.cover)),
      child: _estaCarregando
          ? CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _controladorUsuario,
                  focusNode: focusNodeUsuario,
                  decoration: InputDecoration(labelText: "Usuário"),
                ),
                TextField(
                  controller: _controladorSenha,
                  focusNode: focusNodeSenha,
                  decoration: InputDecoration(labelText: "Senha"),
                  obscureText: true,
                ),
                Divider(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Login"),
                        onPressed: () async {
                          setState(() {
                            _estaCarregando = true;
                          });

                          await _efetuarLogin(
                              _controladorUsuario.text, _controladorSenha.text);

                          setState(() {
                            _estaCarregando = false;
                          });
                        },
                      ),
                      RaisedButton(
                        child: Text("Cadastrar"),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(NavegacaoHelper.rotaCadUser);
                        },
                      ),
                    ])
              ],
            ),
    ));
  }

  Future<Null> _efetuarLogin(String usuario, String senha) async {
    QuerySnapshot userEncontrado = await Firestore.instance
        .collection("usuarios")
        .where("login", isEqualTo: usuario)
        .getDocuments();
    if (userEncontrado.documents.length > 0) {
      bool senhaValida = userEncontrado.documents[0]["senha"] == senha;

      if (senhaValida) {
        Navigator.of(context).pushNamed(NavegacaoHelper.rotaPrincipal,
            arguments: {"usuarioId": userEncontrado.documents[0].documentID});
      } else {
        await GeralHelper.exibirAlerta(context, "Senha Inválida!");
        FocusScope.of(context).requestFocus(focusNodeSenha);
      }
    } else {
      await GeralHelper.exibirAlerta(context, "Usuário não cadastrado!");
      FocusScope.of(context).requestFocus(focusNodeUsuario);
    }
  }
}
