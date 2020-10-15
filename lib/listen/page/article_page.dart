import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:xy_tts/xy_tts.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/dialog/title_dialog.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/platform/widget/xy_widget.dart';
import 'package:xylisten/platform/xy_index.dart';
import 'package:zefyr/zefyr.dart';

import '../home/images.dart';

class ArticlePage extends StatefulWidget {
  final ArticleModel model;
  final bool isPlanText;

  ArticlePage({Key key, this.model,this.isPlanText = false}) : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  ZefyrController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _editing = false;
//  StreamSubscription<NotusChange> _sub;

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

    Delta delta;
    if(widget.isPlanText){
      delta = Delta()..insert(_model.content+"\n");
    }else{
      delta = Delta.fromJson(json.decode(_model.content) as List);
    }
    
    _controller = ZefyrController(NotusDocument.fromDelta(delta));

//    _sub = _controller.document.changes.listen((change) {
//      print('${change.source}: ${change.change}');
//      print(_controller.document.toPlainText());
//    });

  }

  @override
  void dispose() {
//    _sub.cancel();
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
          _buildPopMenu(context),
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
    String txt = _controller.document.toPlainText();
    if(_model.flag==0){
      if(txt!=null && txt.isNotEmpty){
        var firstLine = RegExp(r"[^\s]+").stringMatch(txt);
        _model.title = firstLine;
      }
    }
    _model.count = txt.replaceAll(RegExp(r"\s"), "").length;
    print('count==${_model.count}');
    if(_model.tbId==null){
      if(_model.content.isNotEmpty){
        _dbModelProvider.insertArticle(_model).then((value){
          BotToast.showText(text: '添加成功');
          _refreshHomeList();
        });
      }else{
        BotToast.showText(text: '您未填写任何内容');
      }
    }else{
      _dbModelProvider.updateArticle(_model).then((value){
        BotToast.showText(text: '更新成功');
        _refreshHomeList();
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
        tooltip: '语音播报',
        onPressed: ()=>XyTts.startTTS(txt),
      );
    }
    return Container();
  }

  _buildPopMenu(BuildContext context){
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) =>
      <PopupMenuEntry<String>>[
        XyWidget.buildSelectView(context,Icons.title, '设置标题', 'setTilte'),
        PopupMenuDivider(
          height: 1,
        ),
        XyWidget.buildSelectView(context,Icons.delete, '删除', 'delete'),
        PopupMenuDivider(
          height: 1,
        ),
      ],
      onSelected: (String action) {
        switch (action) {
          case 'setTilte':
            TitleDialog.showTitleDialog(context, confirmCallBack:(title){
              _updateTitle(title);
            });
            break;
          case 'delete':
            break;
        }
      },
    );
  }

  _refreshHomeList(){
    NotifyEvent event = NotifyEvent(route: Constant.eb_home_list_refresh);
    eventBus.fire(event);
  }

  _updateTitle(String txt){
    _model.title = txt;
    _model.flag = 1;
    if(_model.tbId==null){
      if(_model.title.isNotEmpty){
        _dbModelProvider.insertArticle(_model).then((value){
          BotToast.showText(text: '添加成功');
          _refreshHomeList();
          setState(() {

          });
        });
      }else{
        BotToast.showText(text: '您未填写标题');
      }
    }else{
      _dbModelProvider.updateArticle(_model).then((value){
        BotToast.showText(text: '更新成功');
        _refreshHomeList();
        setState(() {

        });
      });
    }
  }

}

