import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  final int index;
  IntroCard(this.index);

  Widget _introCard(int index, String texto) {
    return Card(
      elevation: 0,
      color: Colors.black,
      child: Text(
        _tituloTexto(index, texto),
        textScaleFactor: 3.0,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _bodyCard(int index, String cuerpo) {
    return Card(
      elevation: 0,
      color: Colors.black,
      child: Text(
        _cuerpoTexto(index, cuerpo),
        textScaleFactor: 1.5,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget build(BuildContext context) {
    String texto = 'Carros';
    String cuerpo = 'de Golf.';
    return Card(
      elevation: 0,
      color: Colors.black,
      child: Column(
        children: <Widget>[
          SizedBox(height: 100.0),
          _introCard(index, texto),
          SizedBox(height: 20.0,),
          _bodyCard(index, cuerpo),
        ],
      ),
    );
  }

  String _tituloTexto(int index, String texto) {
    if (index == 0) {
      texto = 'T∑C';
    } else if (index == 1) {
      texto = 'Emprendimiento';
    } else if (index == 2) {
      texto = 'Haz que tus ideas ocurran.';
    } else {
      texto = '';
    }
    return texto;
  }

  String _cuerpoTexto(int index, String texto) {
    print(index);
    if (index == 0) {
      texto =
          'Esta aplicación es una red social del Tecnologico de Monterrey Campus Ciudad de México.';
    } else if (index == 1) {
      texto =
          'El fin de esta aplicacion es para crear una cultura de emprendedores, aorender de los errores y nunca darse por vencido. Si fracas tomarlo como aprendizaje y seguir adelante.';
    } else if (index == 2) {
      texto =
          'Llevar acabo tus ideas, si necesiatas personas aquí puedes reclutar a los ingenieros, licenciados, doctores, gente con ganas de salir adelante a tu lado.';
    } else {
      texto = '';
    }
    return texto;
  }
}
