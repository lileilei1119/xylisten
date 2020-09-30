import 'package:flutter/material.dart';

class XyWidget{

  static buildSelectView(BuildContext context,IconData icon, String text, String id,
      {Color color}) {
    return PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Icon(icon, color: color??Theme.of(context).primaryColor),
            new Text(text),
          ],
        ));
  }
}