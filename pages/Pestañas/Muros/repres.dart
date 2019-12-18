import 'package:flutter/material.dart';

import '../../../scoped-models/mains.dart';
// import './repre_edit.dart';

class RepresPage extends StatefulWidget {
  final MainModel model;

  RepresPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _RepresPageState();
  }
}

class _RepresPageState extends State<RepresPage> {
  // @override
  // initState() {
  //   widget.model.fetchRepres(onlyForUser: false);
  //   super.initState();
  // }


  // Widget _buildEditButton(BuildContext context, int index, MainModel model) {
  //   return IconButton(
  //     icon: Icon(Icons.edit),
  //     onPressed: () {
  //       model.selectRepre(model.allRepres[index].id);
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (BuildContext context) {
  //             return RepreEditPage();
  //           },
  //         ),
  //       ).then((_) {
  //         model.selectRepre(null);
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Repre',
          style: TextStyle(
            color: Colors.white,
          ),
          textScaleFactor: 1.0,
        ),
        // actions: <Widget>[
        //   ScopedModelDescendant<MainModel>(
        //     builder: (BuildContext context, Widget child, MainModel model) {
        //       return _buildEditButton(context, index, model);
        //     },
        //   )
        // ],
      ),
      body: Container(child: Center(widthFactor: 10, child: Text('Repres'),),),
    );
  }
}
