import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/helpers/geralHelper.dart';
import 'package:flutter_firebase/helpers/navegacaoHelper.dart';

class PrincipalView extends StatefulWidget {
  final String userLogadoID;
  PrincipalView(this.userLogadoID);

  @override
  _PrincipalViewState createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tarefas"),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: GeralHelper.menu(context, widget.userLogadoID),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: FutureBuilder<QuerySnapshot>(
                  future: _recuperarTarefas(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return ListView.builder(
                          padding: EdgeInsets.all(20),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title:
                                  Text(snapshot.data.documents[index]["nome"]),
                              value: snapshot.data.documents[index]["feito"] ??
                                  false,
                              secondary: GestureDetector(
                                child: CircleAvatar(
                                  child: Icon(snapshot.data.documents[index]
                                          ["feito"]
                                      ? Icons.check
                                      : Icons.close),
                                ),
                                onTap: () {
                                  setState(() {
                                    _atualizaCheck(
                                        snapshot.data.documents[index],
                                        snapshot.data.documents[index]
                                            ["feito"]);
                                  });
                                },
                              ),
                              onChanged: (marcou) {
                                setState(() {
                                  _atualizaCheck(snapshot.data.documents[index],
                                      snapshot.data.documents[index]["feito"]);
                                });
                              },
                            );
                          },
                        );
                        break;

                      default:
                        return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: new FloatingActionButton(
                  child: Text(
                    "+",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                  onPressed: () {
                    Navigator.of(context).pushNamed(NavegacaoHelper.rotaCadTask,
                        arguments: {"usuarioId": widget.userLogadoID});
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<QuerySnapshot> _recuperarTarefas() async {
    return await Firestore.instance
        .collection("usuarios")
        .document(widget.userLogadoID)
        .collection("tarefas")
        .orderBy("datainclusao")
        .getDocuments();
  }

  void _atualizaCheck(
      DocumentSnapshot tarefaSelecionada, bool tarefaFeita) async {
    return await Firestore.instance
        .collection("usuarios")
        .document(widget.userLogadoID)
        .collection("tarefas")
        .document(tarefaSelecionada.documentID)
        .updateData({"feito": !tarefaFeita});
  }
}
