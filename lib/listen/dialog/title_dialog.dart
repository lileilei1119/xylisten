import 'package:flutter/material.dart';
import 'package:xylisten/platform/xy_index.dart';

typedef TxtUpdateCallBack = Function(String txt);

class TitleDialog extends Dialog {

  final TxtUpdateCallBack confirmCallBack;
  final _titleController = TextEditingController();

  TitleDialog({@required this.confirmCallBack});

  static showTitleDialog(BuildContext context,{@required TxtUpdateCallBack confirmCallBack}) async{
    await showDialog(context: context,barrierDismissible: true,builder: (context){
      return TitleDialog(confirmCallBack: confirmCallBack,);
    });
  }

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
                  Text('输入标题',style: Theme.of(context).textTheme.headline6,),
                  TextField(controller: _titleController,),
                  FlatButton(
                    onPressed: () {
                      if(_titleController.text.isNotEmpty){
                        if(confirmCallBack!=null){
                          confirmCallBack(_titleController.text);
                        }
                        Navigator.pop(context);
                      }else{
                        BotToast.showText(text: '请输入标题');
                      }
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
