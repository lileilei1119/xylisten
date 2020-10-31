import 'package:flutter/material.dart';
import 'package:xylisten/platform/res/index.dart';

typedef LinkDialogCallback = void Function(String txt);

class LinkDialog extends Dialog {
  final String clipboardTxt;
  final LinkDialogCallback onOKPressed;

  LinkDialog({this.clipboardTxt,this.onOKPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: SingleChildScrollView(
            child: LinkDialogContent(
              clipboardTxt: clipboardTxt,
              onOKPressed: this.onOKPressed,
            ),
          )),
    );
  }
}

class LinkDialogContent extends StatefulWidget {
  final String clipboardTxt;
  final LinkDialogCallback onOKPressed;
  const LinkDialogContent({Key key, this.clipboardTxt,this.onOKPressed}) : super(key: key);

  @override
  _LinkDialogContentState createState() => _LinkDialogContentState();
}

class _LinkDialogContentState extends State<LinkDialogContent> {
  final _linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      if (widget.clipboardTxt != null) {
        _linkController.text = RegExp(
                r"((https?)://|)[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]")
            .stringMatch(widget.clipboardTxt);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.clipboardTxt == null
        ? _buildView(context)
        : _buildView4Clip(context);
  }

  _buildView4Clip(BuildContext context) {
    return Container(
      width: 320.0,
      height: 400.0,
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '黏贴板内容：',
              style: Theme.of(context).textTheme.caption,
            ),
            Gaps.vGap8,
            Expanded(child: Text(widget.clipboardTxt ?? "")),
            Gaps.vGap16,
            Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                   TextField(
                    decoration: InputDecoration(
                      hintText: '输入您要抓取的网址',
                      labelText: '智能捕获网址：',
                    ),
                     controller: _linkController,
                     onChanged: (txt){
                       _linkController.text = txt;
                     },
                  ),
                  Offstage(
                      offstage: _linkController.text.isEmpty?true:false,
                      child: GestureDetector(
                        onTap: (){
                          _linkController.clear();
                        },
                        child: Container(
//                          color: Colors.red,
                          alignment: Alignment(1.0, 0.5),
                          width: 45,
                          height: 45,
                          child: Icon(Icons.cancel,color: Colors.grey,size: 17,),
                        ),
                      ),
                  ),
                ]
            ),
            Gaps.vGap8,
            _buildBtns()
          ],
        ),
      ),
    );
  }

  _buildView(BuildContext context) {
    return Container(
      width: 320.0,
      height: 200.0,
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
            Text(
              '输入URL地址',
              style: Theme.of(context).textTheme.headline6,
            ),
            Stack(
                alignment: Alignment.centerRight,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: '输入您要抓取的网址',
                    ),
                    controller: _linkController,
                    onChanged: (txt){
                      _linkController.text = txt;
                    },
                  ),
                  Offstage(
                    offstage: _linkController.text.isEmpty?true:false,
                    child: GestureDetector(
                      onTap: (){
                        _linkController.clear();
                      },
                      child: Container(
//                          color: Colors.red,
                        alignment: Alignment(1.0, 0.5),
                        width: 45,
                        height: 45,
                        child: Icon(Icons.cancel,color: Colors.grey,size: 17,),
                      ),
                    ),
                  ),
                ]
            ),
            _buildBtns(),
          ],
        ),
      ),
    );
  }

  _buildBtns(){
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          OutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('取消'),
            textTheme: ButtonTextTheme.normal,
            color: Theme.of(context).buttonColor,
            shape: ContinuousRectangleBorder(),
          ),
          FlatButton(
            onPressed: () {
              if(widget.onOKPressed!=null){
                widget.onOKPressed(_linkController.text);
              }
              Navigator.pop(context);
            },
            child: Text('开始拉取'),
            textTheme: ButtonTextTheme.primary,
            color: Theme.of(context).buttonColor,
            shape: ContinuousRectangleBorder(),
          ),
        ]
    );
  }
}
