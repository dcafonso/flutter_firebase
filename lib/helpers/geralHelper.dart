import 'package:flutter/material.dart';
import 'package:flutter_firebase/helpers/navegacaoHelper.dart';

class GeralHelper {
  static Future<void> exibirAlerta(
      BuildContext context, String mensagem) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Atenção"),
            content: Text(mensagem),
            actions: <Widget>[
              FlatButton(
                child: Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  static ListView menu(BuildContext context, String userLogadoID) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            "Nova Tarefa",
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(NavegacaoHelper.rotaCadTask,
                arguments: {"usuarioId": userLogadoID});
          },
        ),
        ListTile(
          title: Text(
            "Novo Usuário",
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(NavegacaoHelper.rotaCadUser);
          },
        ),
        ListTile(
          title: Text(
            "Logout",
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamedAndRemoveUntil(
                NavegacaoHelper.rotaLogin, (Route<dynamic> route) => false);
          },
        ),
      ],
    );
  }
}
