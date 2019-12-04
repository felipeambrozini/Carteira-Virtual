import 'package:flutter/material.dart';
import 'package:projeto_teste/models/user.dart';
import 'package:projeto_teste/services/auth.dart';
import 'package:projeto_teste/views/emprestimoCadastro.dart';
import 'package:projeto_teste/views/login.dart';
import 'package:projeto_teste/views/pagamento.dart';
import 'package:projeto_teste/views/perfil.dart';
import 'package:projeto_teste/views/sobre.dart';
import 'package:projeto_teste/views/termo.dart';
import 'package:projeto_teste/views/visualizarEmprestimo.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User _user = new User();

  @override
  void initState() {
   Auth.getUserLocal().then(_onGetUserLocalSuccess);
    super.initState();
  }

  void _onGetUserLocalSuccess(User user) {
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _showHeader(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(Perfil.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.money_off),
            title: Text('Emprestar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(EmprestimoCadastro.routeName);
            },
          ),
           ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pagar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(Pagamento.routeName);
            },
          ),
           ListTile(
            leading: Icon(Icons.description),
            title: Text('Visualizar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(VisualizarEmprestimo.routeName);
            },
          ),
           Divider(),
           ListTile(
            leading: Icon(Icons.title),
            title: Text('Termos de uso'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(Termo.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Sobre o aplicativo'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(Sobre.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(Login.routeName);
            },
          ),
        ],
      ),
    );
  }

  Widget _showHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(_user?.name ?? ""),
      accountEmail: Text(_user?.email ?? ""),
      currentAccountPicture:
          CircleAvatar(child: Text(_user?.getInitials() ?? '')),
    );
  }
}
