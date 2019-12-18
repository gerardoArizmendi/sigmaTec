import 'package:flutter/material.dart';

class PerfilInfoTag extends StatelessWidget {
  final String semestre;
  final String carrera;
  final String campus;

  PerfilInfoTag(this.semestre, this.carrera, this.campus);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: 20.0,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          carrera,
          style: TextStyle(color: Colors.white),
        ),
      ),
      SizedBox(width: 10.0),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          semestre + ' semestre',
          style: TextStyle(color: Colors.white),
        ),
      ),
      SizedBox(width: 10.0),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          campus,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ]);
  }
}
