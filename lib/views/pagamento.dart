import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:projeto_teste/models/emprestimo.dart';
import 'package:projeto_teste/models/user.dart';
import 'package:projeto_teste/services/auth.dart';
import 'package:projeto_teste/utils/common.dart';
import 'package:projeto_teste/views/visualizarEmprestimo.dart';
import 'package:projeto_teste/widget/custom_drawer.dart';

class Pagamento extends StatefulWidget {
  static const String routeName = '/pagamento';
  
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  User _currentUser;
  User _emprestouUser;
  Emprestimo _emprestimo;

  @override
  void initState() {
    super.initState();
    Auth.getUserLocal().then((user) {
      setState(() {
        _currentUser = user;
        _emprestouUser = user;
        print('Current user: ${_currentUser.toJson()}');
        print('Current user: ${_emprestouUser.toJson()}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      drawer: CustomDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('Pagar empréstimos'),
    );
  }

  Widget _buildBody() {
    if (_currentUser == null) return Common.progressContainer();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('emprestimo')
          .where('recebeUserId', isEqualTo: _currentUser.userId)
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
    return new GestureDetector(
  onTap: _pagar,
  child: new Card(child: new Column(children: <Widget>[
            new Text("Descrição: " + emprestimo.description+ "\n"),
            new Text("Valor: " + emprestimo.valor+ "\n"),
            new Text("Data: " + emprestimo.date + "\n"), 
            new Text("Data de pagamento: " + emprestimo.datePagamento +"\n"),
            new Text("Status do pagamento: " + emprestimo.stausPagamento +"\n"),
          ],
          ),),
);
}

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      label: Text('Realizar pagamento'),
      icon: Icon(Icons.payment),
      onPressed: _pagarmensagem,
    );
  }

void _pagar(){
  final _initialDateValue = DateTime.now();
  if (_initialDateValue as String != _emprestimo.datePagamento) {
       _emprestimo.valor = (int.parse(_emprestimo.valor) + int.parse(_emprestimo.valor)*1.1) as String;
       _currentUser.saldo = (int.parse(_currentUser.saldo)   - int.parse(_emprestimo.valor)) as String;
       _emprestouUser.saldo = (int.parse(_emprestouUser.saldo) + int.parse(_emprestimo.valor)) as String ;
       _emprestimo.stausPagamento = ('Sim');
      }
      else{
    _currentUser.saldo = (int.parse(_currentUser.saldo)   - int.parse(_emprestimo.valor)) as String;
    _emprestouUser.saldo = (int.parse(_emprestouUser.saldo) + int.parse(_emprestimo.valor)) as String ;
    _emprestimo.stausPagamento = ('Sim');
      }
}

void _pagarmensagem(){
    Flushbar(
      title: 'Pagamento',
      message: 'Pagamento realizado com sucesso!',
      duration: Duration(seconds: 3),
    )..show(context);
    Navigator.of(context).pushNamed(VisualizarEmprestimo.routeName);   
  }

}