import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_teste/services/auth.dart';
import 'package:projeto_teste/models/user.dart';
import 'package:projeto_teste/views/login.dart';

class Cadastro extends StatefulWidget {
  static const String routeName = '/cadastro';
  
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _nameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _confirmPasswordController = new TextEditingController();
  final _phoneController = new TextEditingController();
  final _cpfController = new TextEditingController(); 
  final _saldoController = new TextEditingController();
  final _dateController = new TextEditingController();
  final _dateFormat = DateFormat("dd/MM/yyyy");
  final _initialDateValue = DateTime.now();

  final _nameFocusNode = new FocusNode();
  final _dateFocusNode = new FocusNode();
  final _emailFocusNode = new FocusNode();
  final _passwordFocusNode = new FocusNode();
  final _confirmPasswordFocusNode = new FocusNode();
  final _phoneFocusNode = new FocusNode();
  final _cpfFocusNode = new FocusNode();
  final _saldoFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _showNameTextField(),
              _showDateTextField(),
              _showEmailTextField(),
              _showPasswordTextField(),
              _showConfirmPasswordTextField(),
              _showPhoneTextField(),
              _showCPFTextField(),
              _showSaldoTextField(),
              _showSignUpButton(),
            ],
          ),
        ),
      ),
    );
  }

Widget _showNameTextField() {
    return TextField(
       controller: _nameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Digite seu nome',
        prefixIcon: Icon(Icons.person),
      ),
      textInputAction: TextInputAction.next,
      autofocus: true,
      focusNode: _nameFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_dateFocusNode),
    );
  }
  Widget _showDateTextField() {
    return DateTimeField(
      controller: _dateController,
      format: _dateFormat,
      initialValue: _initialDateValue,
      decoration: InputDecoration(
        labelText: 'Selicione a data do seu nascimento',
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
       textInputAction: TextInputAction.next,
      focusNode: _dateFocusNode,
      onEditingComplete: () =>
      FocusScope.of(context).requestFocus(_emailFocusNode),
    );
  }

  Widget _showEmailTextField() {
     return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Digite seu email',
        prefixIcon: Icon(Icons.email),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
    );
  }

  Widget _showPasswordTextField() {
    return TextFormField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Digite uma senha',
        prefixIcon: Icon(Icons.vpn_key),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _passwordFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
    );
  }

   Widget _showConfirmPasswordTextField() {
     return TextFormField(
      controller: _confirmPasswordController,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Confirmar sua senha',
        prefixIcon: Icon(Icons.vpn_key),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _confirmPasswordFocusNode,
       onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_phoneFocusNode)
    );
  }

Widget _showPhoneTextField() {
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.number,
      maxLength: 11,
      decoration: InputDecoration(
        hintText: 'Digite o numero do seu celular',
        prefixIcon: Icon(Icons.phone),
      ),
       textInputAction: TextInputAction.next,
      focusNode: _phoneFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_cpfFocusNode)
    );
  }

Widget _showCPFTextField() {
    return TextField(
      controller: _cpfController,
      keyboardType: TextInputType.number,
      maxLength: 11,
      decoration: InputDecoration(
        hintText: 'Digite seu CPF',
        prefixIcon: Icon(Icons.description),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _cpfFocusNode,
       onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_saldoFocusNode)
    );
  }

Widget _showSaldoTextField() {
    return TextField(
      controller: _saldoController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Digite o saldo',
        prefixIcon: Icon(Icons.attach_money),
      ),
      textInputAction: TextInputAction.next,
      focusNode: _saldoFocusNode,
    );
  }

 Future _signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    await Auth.signUp(email, password)
        .then(_onResultSignUpSuccess)
        .catchError((error) {
      Flushbar(
        title: 'Erro',
        message: error.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    });
  }
  
  void _onResultSignUpSuccess(String userId) {
    final email = _emailController.text;
    final name = _nameController.text;
    final phone = _phoneController.text;
    final cpf = _cpfController.text;
    final saldo = _saldoController.text;
    final user = User(userId: userId, name: name, email: email, phone: phone, cpf: cpf, saldo: saldo);
    Auth.addUser(user).then(_onResultAddUser);
  }

   void _onResultAddUser(result) {
    Flushbar(
      title: 'Novo usuário',
      message: 'Usuário registrado com sucesso!',
      duration: Duration(seconds: 2),
    )..show(context);
    Navigator.of(context).pushReplacementNamed(Login.routeName);
  }

  Widget _showSignUpButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: RaisedButton(child: Text('Cadastrar'), onPressed: _signUp),
    );
  }
}
