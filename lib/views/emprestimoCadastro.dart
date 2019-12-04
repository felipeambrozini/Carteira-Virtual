import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_teste/models/emprestimo.dart';
import 'package:projeto_teste/models/user.dart';
import 'package:projeto_teste/services/auth.dart';
import 'package:projeto_teste/utils/common.dart';
import 'package:projeto_teste/views/visualizarEmprestimo.dart';
import 'package:projeto_teste/widget/custom_drawer.dart';

class EmprestimoCadastro extends StatefulWidget {
  static const String routeName = '/emprestimo';

  final Emprestimo emprestimo;

  EmprestimoCadastro({this.emprestimo});

  @override
  _EmprestimoCadastro createState() => _EmprestimoCadastro();
}

class _EmprestimoCadastro extends State<EmprestimoCadastro> {
  final _formKey = new GlobalKey<FormState>();
  final _descriptionController = new TextEditingController();
  final _valorController = new TextEditingController();
  final _dateController = new TextEditingController();
  final _dateDevolucaoController = new TextEditingController();
  final _dateFormat = DateFormat("dd/MM/yyyy");
  final _initialDateValue = DateTime.now();
  
  User _currentUser;
  User _recebeEmprestimoUser;
  Emprestimo _emprestimo = new Emprestimo();

  @override
  void initState() {
    super.initState();

    if (widget.emprestimo != null) {
      _emprestimo = Emprestimo.fromMap(widget.emprestimo.toMap());
      _descriptionController.text = _emprestimo.description;
      _valorController.text = _emprestimo.valor;
      _dateController.text = _emprestimo.date;
      _dateDevolucaoController.text = _emprestimo.dateDevolucao;
      _recebeEmprestimoUser.userId = _emprestimo.recebeUserId;
      _currentUser.userId = _emprestimo.emprestarUserId;
    }
    _loadLocalUser();
  }

  Future _loadLocalUser() async {
    final user = await Auth.getUserLocal();
    final recebeuser = await Auth.getUserLocal();
    setState(() {
      _currentUser = user;
      _recebeEmprestimoUser = recebeuser;
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
      title: Text('Realizar empréstimos'),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDescriptionTextField(),
            _buildValorTextField(),
            _buildDateTextField(),
            _buildDateDevoluTextField(),
            _showAllUsers(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Digite uma descrição',
        prefixIcon: Icon(Icons.description),
      ),
      validator: (text) => text.isEmpty ? 'Descrição inválida' : null,
    );
  }

  Widget _buildValorTextField() {
    return TextFormField(
      controller: _valorController,
      keyboardType: TextInputType.number,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: 'Digite o valor do empréstimo',
        prefixIcon: Icon(Icons.attach_money),
      ),
      validator: (text) => text.isEmpty ? 'Descrição inválida' : null,
    );
  }

  Widget _buildDateTextField() {
    return DateTimeField(
      controller: _dateController,
      keyboardType: TextInputType.datetime,
      format: _dateFormat,
      initialValue: _initialDateValue,
      decoration: InputDecoration(
        labelText: 'Digite a data do empréstimo',
        prefixIcon: Icon(Icons.date_range),
      ),
      validator: (date) => date == null ? 'Data inválida' : null,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
        );
      },
    );
  }

  Widget _buildDateDevoluTextField() {
    return DateTimeField(
      controller: _dateDevolucaoController,
       keyboardType: TextInputType.datetime,
      format: _dateFormat,
      initialValue: _initialDateValue,
      decoration: InputDecoration(
        labelText: 'Digite a data de devolução',
        prefixIcon: Icon(Icons.date_range),
      ),
      validator: (date) => date == null ? 'Data inválida' : null,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
        );
      },
    );
  }
  
Widget _showAllUsers(){
  if (_currentUser == null) return Common.progressContainer();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users').snapshots(),
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
                  message: "Nenhum usuário encontrado!");
            else
              return ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: snapshot.data.documents.map(_buildCard).toList(),
              );
        }
        return null;
      },
    );
}

Widget _buildCard(document) {
    final user = User.fromDocument(document);
    return ListTile(
      title: Text("Nome: " + user.name),
      onTap: _emprestar,
    );
  }

  void _emprestar(){
_recebeEmprestimoUser.userId = _emprestimo.recebeUserId;
_currentUser.saldo = (int.parse(_currentUser.saldo) - int.parse(_emprestimo.valor)) as String;
_recebeEmprestimoUser.saldo = (int.parse(_recebeEmprestimoUser.saldo) + int.parse(_emprestimo.valor)) as String; 
}

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      label: Text('Realizar empréstimo'),
      icon: Icon(Icons.money_off),
      onPressed: _save,
    );
  }

  Future _save()  async {
    if (_formKey.currentState.validate()) {
       _formKey.currentState.save();
       _emprestimo = new Emprestimo(
        description: _descriptionController.text,
        valor: _valorController.text,
        date: _dateController.text,
        dateDevolucao: _dateDevolucaoController.text,
        emprestarUserId: _currentUser.userId,
        recebeUserId: _recebeEmprestimoUser.userId,
        stausPagamento: ("não pago"),
      );

      print('Saving ${_emprestimo.toJson()}');
      await Firestore.instance
          .collection('emprestimo')
          .add(_emprestimo.toMap())
          .then(_onSaveDataSuccess)
          .catchError(_onSaveDataFailure);
    }
  }

  void _onSaveDataSuccess(result) {
    Flushbar(
      title: 'Novo emprestimo',
      message: 'Emprestimo realizado com sucesso!',
      duration: Duration(seconds: 3),
    )..show(context);
    Navigator.pop(context, result);
     Navigator.of(context).pushNamed(VisualizarEmprestimo.routeName);
  }

  void _onSaveDataFailure(error) {
    print('Error ${error.toString()})');
    Flushbar(
      title: 'Erro',
      message: error.toString(),
      duration: Duration(seconds: 3),
    )..show(context);
  }

}