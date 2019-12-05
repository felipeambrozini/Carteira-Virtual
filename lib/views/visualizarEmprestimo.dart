import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projeto_teste/models/emprestimo.dart';
import 'package:projeto_teste/models/user.dart';
import 'package:projeto_teste/services/auth.dart';
import 'package:projeto_teste/utils/common.dart';
import 'package:projeto_teste/widget/custom_drawer.dart';

class VisualizarEmprestimo extends StatefulWidget {
  static const String routeName = '/visualizar';

  _VisualizarEmprestimoState createState() => _VisualizarEmprestimoState();
}

class _VisualizarEmprestimoState extends State<VisualizarEmprestimo> {
  User _currentUser;

  @override
  void initState() {
    super.initState();
    Auth.getUserLocal().then((user) {
      setState(() {
        _currentUser = user;
        print('Current user: ${_currentUser.toJson()}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: CustomDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Visualizar empréstimos'),
    );
  }

  Widget _buildBody() {
    if (_currentUser == null) return Common.progressContainer();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('emprestimo')
          .where('emprestarUserId', isEqualTo: _currentUser.userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return Common.errorContainer(error: snapshot.error);
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Common.progressContainer();
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.data.documents.length == 0)
              return Common.emptyContainer(
                  message: "Nenhum Empréstimo encontrado!");
            else
              return ListView(
                scrollDirection: Axis.vertical,
                children: snapshot.data.documents.map(_buildCard).toList(),
              );
        }
        return null;
      },
    );
  }

  Widget _buildCard(document) {
    final emprestimo = Emprestimo.fromDocument(document);
    return new Card(
          child: new Column(children: <Widget>[
            new Text("Descrição: " + emprestimo.description + "\n"),
            new Text("Valor: " + emprestimo.valor + "\n"),
            new Text("Data: " + emprestimo.date + "\n"), 
            new Text("Data de devolução: " + emprestimo.datePagamento + "\n"),
            new Text("Status do pagamento: " + emprestimo.stausPagamento +"\n"),
          ],
          ),
        );
}

}