import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/helpers/geralHelper.dart';

class CadUsuarioView extends StatefulWidget {
  @override
  _CadUsuarioViewState createState() => _CadUsuarioViewState();
}

class _CadUsuarioViewState extends State<CadUsuarioView> {
  bool _estaCarregando = false;
  final _controladorNome = TextEditingController();
  final _controladorLogin = TextEditingController();
  final _controladorSenha = TextEditingController();
  final _controladorConfirma = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuário"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: _estaCarregando
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _controladorNome,
                    decoration: InputDecoration(labelText: "Nome"),
                  ),
                  TextField(
                    controller: _controladorLogin,
                    decoration: InputDecoration(labelText: "Login"),
                  ),
                  TextField(
                    controller: _controladorSenha,
                    decoration: InputDecoration(labelText: "Senha"),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _controladorConfirma,
                    decoration: InputDecoration(labelText: "Confirmar Senha"),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RaisedButton(
                    child: Text("Salvar"),
                    onPressed: () async {
                      String campo = _validarCampos(
                          _controladorNome.text,
                          _controladorLogin.text,
                          _controladorSenha.text,
                          _controladorConfirma.text);

                      if (campo != "") {
                        await GeralHelper.exibirAlerta(
                            context, "Preencha o campo " + campo);
                      } else if (_validaSenha(
                          _controladorSenha.text, _controladorConfirma.text)) {
                        await GeralHelper.exibirAlerta(
                            context, "A senha deve ser igual! Verifique.");
                      } else {
                        _salvarUsuario(_controladorNome.text,
                            _controladorLogin.text, _controladorSenha.text);
                      }
                    },
                  )
                ],
              ),
      ),
    );
  }

  static String _validarCampos(
      String nome, String login, String senha, String confirmaSenha) {
    if (nome == "") {
      return "Nome";
    } else if (login == "") {
      return "Login";
    } else if (senha == "") {
      return "Senha";
    } else if (confirmaSenha == "") {
      return "Confirmar Senha";
    } else {
      return "";
    }
  }

  static bool _validaSenha(String senha, String confirmaSenha) {
    if (senha != confirmaSenha) {
      return true;
    } else {
      return false;
    }
  }

  Future<Null> _salvarUsuario(String nome, String login, String senha) async {
    var usuarioEncontrado = await Firestore.instance
        .collection("usuarios")
        .where("login", isEqualTo: login)
        .getDocuments();

    if (usuarioEncontrado.documents.length == 0) {
      Firestore.instance
          .collection("usuarios")
          .add({"nome": nome, "login": login, "senha": senha});
      Navigator.of(context).pop();
    } else {
      await GeralHelper.exibirAlerta(context, "Usuário já cadastrado!");
    }
  }
}
