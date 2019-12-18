import 'package:flutter/material.dart';

class Eventos extends StatelessWidget {
  const Eventos();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Eventos',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: Text('Eventos'),
    );
  }
}

