import 'package:flutter/material.dart';
import 'package:projeto_teste/widget/custom_drawer.dart';

class Termo extends StatefulWidget {
  static const String routeName = '/termo';
  @override
  _TermoState createState() => _TermoState();
}

class _TermoState extends State<Termo> {
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
      title: Text('Termos de uso'),
    );
  }

  Widget _buildBody() {
    return Center(child: Text('Use o Aplicativo Carteira Virtual com responsabilidade.'));
  }
}
