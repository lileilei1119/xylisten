import 'package:flutter/material.dart';
import 'package:xylisten/platform/xy_index.dart';

class LinkDialog extends Dialog {

  final _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Stack(children: <Widget>[
        GestureDetector(onTap: () {
          Navigator.pop(context);
        }),
        Center(
          child: new Container(
            width: 300.0,
            height: 180.0,
            decoration: ShapeDecoration(
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('输入URL地址',style: Theme.of(context).textTheme.headline6,),
                  TextField(controller: _linkController,),
                  FlatButton(
                    onPressed: () {
                      eventBus.fire(NotifyEvent(route: Constant.eb_add_link, argList: [_linkController.text]));
                      Navigator.pop(context);
                    },
                    child: Text('提交'),
                    textTheme: ButtonTextTheme.normal,
//                    color: Theme.of(context).primaryColor,
                    shape: ContinuousRectangleBorder(),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
