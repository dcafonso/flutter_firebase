import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/helpers/geralHelper.dart';

class CadTarefaView extends StatefulWidget {
  final String userLogadoID;
  CadTarefaView(this.userLogadoID);

  @override
  _CadTarefaViewState createState() => _CadTarefaViewState();
}

class _CadTarefaViewState extends State<CadTarefaView> {
  bool _estaCarregando = false;
  final _controladorNome = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incluir Tarefa"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: _estaCarregando
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _controladorNome,
                    decoration: InputDecoration(labelText: "Nome Tarefa"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text("Salvar"),
                    onPressed: () async {
                      if (_controladorNome.text != "") {
                        _salvarTarefa(
                            widget.userLogadoID, _controladorNome.text);
                      } else {
                        await GeralHelper.exibirAlerta(
                            context, "Preencha o campo Nome");
                      }
                    },
                  )
                ],
              ),
      ),
    );
  }

  Future<Null> _salvarTarefa(String usuarioID, String nome) async {
    var usuarioEncontrado =
        Firestore.instance.collection("usuarios").document(usuarioID);

    if (usuarioEncontrado != null) {
      Firestore.instance
          .collection("usuarios")
          .document(usuarioID)
          .collection("tarefas")
          .add({"nome": nome, "feito": false, "datainclusao": DateTime.now()});

      Navigator.of(context).pop();
    }
  }
}
