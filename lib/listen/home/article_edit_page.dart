import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:xy_tts/xy_tts.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/home/article_model.dart';
import 'package:xylisten/platform/xy_index.dart';
import 'package:zefyr/zefyr.dart';
import 'images.dart';

class ArticleEditPage extends StatefulWidget {
  final ArticleModel model;

  ArticleEditPage({Key key, this.model}) : super(key: key);

  @override
  _ArticleEditPageState createState() => _ArticleEditPageState();
}

class _ArticleEditPageState extends State<ArticleEditPage> {
  ZefyrController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _editing = false;
  StreamSubscription<NotusChange> _sub;

  ArticleModel _model;

  DbModelProvider _dbModelProvider = DbModelProvider();

  @override
  void initState() {
    super.initState();
    if(widget.model==null){
      _model = ArticleModel(content: r'[{"insert":"\n"}]');
      _editing = true;
    }else{
      _model = widget.model;
    }

    Delta delta = Delta.fromJson(json.decode(_model.content) as List);
    _controller = ZefyrController(NotusDocument.fromDelta(delta));

    _sub = _controller.document.changes.listen((change) {
      print('${change.source}: ${change.change}');
      print(_controller.document.toPlainText());
//      if(change.change.toString().contains("\n")){
//        _controller.document.format(0, 0, NotusAttribute.heading.level3);
//      }
    });

  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _editing
        ? IconButton(onPressed: _stopEditing, icon: Icon(Icons.save))
        : IconButton(onPressed: _startEditing, icon: Icon(Icons.edit));
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(widget.model?.title??'新建文章'),
        actions: [
          _buildTTSBtn(),
          done,
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          controller: _controller,
          focusNode: _focusNode,
          mode: _editing ? ZefyrMode.edit : ZefyrMode.select,
          imageDelegate: CustomImageDelegate(),
          keyboardAppearance: Constant.isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _editing = true;
    });
  }

  void _stopEditing() {
    _model.content = json.encode(_controller.document.toDelta());
    if(_model.tbId==null){
      if(_model.content.isNotEmpty){
        _model.title = "一定成功";
        _dbModelProvider.insert(_model).then((value){
          BotToast.showText(text: '添加成功');
        });
      }else{
        BotToast.showText(text: '您未填写任何内容');
      }
    }else{
      _dbModelProvider.update(_model).then((value){
        BotToast.showText(text: '更新成功');
      });
    }

    setState(() {
      _editing = false;
    });

  }

  _buildTTSBtn(){
    var txt = _controller.document.toPlainText();
    if(txt!=null && txt.isNotEmpty){
      return IconButton(
        icon: Icon(Icons.headset),
        onPressed: ()=>XyTts.startTTS(txt),
      );
    }
    return Container();
  }

}

