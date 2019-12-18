import 'package:flutter/material.dart';

class Talleres extends StatelessWidget{

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) =>
            EntryItem(data[index]),
          itemCount: data.length,
        ),
      )
      );
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);
  
  final String title;
  final List <Entry> children;

}

final List <Entry> data = <Entry>[
  Entry('Mecatronica', <Entry> [
    Entry ('Visita', <Entry> [
      Entry ('Ford'), Entry('Mecanico'),Entry('Toyota')]),
    Entry('Talleres', <Entry> [
      Entry('Reparacion'), Entry('Bienvenida')
    ]),]
      ),
  Entry ('Telecomunicaciones', <Entry> [
    Entry('Visita', <Entry> [
      Entry('Section B.1.1'),Entry('Section B.1.2')
    ])
  ]),
  Entry ('Chapter C', <Entry> [
    Entry('Section C.1', <Entry> [
      Entry('Section C.1.1'),Entry('Section C.1.2')
    ])
  ]),
  Entry ('Chapter C', <Entry> [
    Entry('Section C.1', <Entry> [
      Entry('Section C.1.1'),Entry('Section C.1.2')
    ])
  ])
      
];

class EntryItem extends StatelessWidget{
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children:root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context){
    return _buildTiles(entry);
  }
}