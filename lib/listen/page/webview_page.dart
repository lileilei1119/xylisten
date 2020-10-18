import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:xy_tts/xy_tts.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/listen/dialog/title_dialog.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';
import 'package:xylisten/platform/widget/xy_widget.dart';
import 'package:xylisten/platform/xy_index.dart';

import 'article_page.dart';

class WebViewPage extends StatefulWidget {
  final ArticleModel model;

  WebViewPage(this.model);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  String _content;
  // 标记是否是加载中
  bool loading = true;
  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = true;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> onStateChanged;
  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  DbModelProvider _dbModelProvider = DbModelProvider();

  @override
  void initState() {
    super.initState();
    onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state){
      // state.type是一个枚举类型，取值有：WebViewState.shouldStart, WebViewState.startLoad, WebViewState.finishLoad
      switch (state.type) {
        case WebViewState.shouldStart:
          flutterWebViewPlugin.hide();
        // 准备加载
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad:
        // 开始加载
          break;
        case WebViewState.finishLoad:
          flutterWebViewPlugin.show();
        // 加载完成
          setState(() {
            loading = false;
          });
          if (isLoadingCallbackPage) {
            // 当前是回调页面，则调用js方法获取数据
            parseResult();
          }
          break;
      }
    });
  }
  // 解析WebView中的数据
  void parseResult() {
    flutterWebViewPlugin.evalJavascript("document.title").then((result) {
      // result json字符串，包含token信息
      if(widget.model.title.startsWith("http") && result.isNotEmpty){
        widget.model.title = result;
        _dbModelProvider.updateArticle(widget.model).then((value){
          _refreshHomeList();
        });
        setState(() {

        });
      }
    });

    flutterWebViewPlugin.evalJavascript("document.body.innerText").then((result) {
      _content = result;
      setState(() {

      });
    });
//    rootBundle.loadString('assets/js/fetch_data.js').then((fetchJs) {
//      flutterWebViewPlugin.evalJavascript('HtmlDecoder()').then((result) {
//        print("doc =====  $result");
//      });
//    });

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(Expanded(
      child: new Text(
        widget.model.title,
        style: new TextStyle(color: Colors.white),
        overflow: TextOverflow.ellipsis,
      ),
    ));
    if (loading) {
      // 如果还在加载中，就在标题栏上显示一个圆形进度条
      titleContent.add(new CupertinoActivityIndicator());
    }
    titleContent.add(new Container(width: 50.0));
    // WebviewScaffold是插件提供的组件，用于在页面上显示一个WebView并加载URL
    return new WebviewScaffold(
      key: scaffoldKey,
      url:widget.model.url, // 登录的URL
      appBar: new AppBar(
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleContent,
        ),
//        iconTheme: new IconThemeData(color: Colors.white),
        actions: [
          _buildTTSBtn(),
          _buildEditBtn(),
          _buildPopMenu(context),
        ],
      ),
      withZoom: true,  // 允许网页缩放
      withLocalStorage: true, // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
    );
  }

  @override
  void dispose() {
    // 回收相关资源
    // Every listener should be canceled, the same should be done with this stream.
    onStateChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }


  _buildTTSBtn(){
    if(_content!=null && _content.isNotEmpty){
      return IconButton(
        icon: Icon(Icons.headset),
        tooltip: '语音播报',
        onPressed: (){
          PlayerControlView.showPlayer(context,model: widget.model);
          PlayerControlView.show();
        },
      );
    }
    return Container();
  }

  _buildEditBtn(){
    if(_content!=null && _content.isNotEmpty){
      return IconButton(
        icon: Icon(Icons.insert_drive_file),
        tooltip: '转换成文本并编辑',
        onPressed: (){
          flutterWebViewPlugin.hide();

          //深复制一个对象
          ArticleModel model = ArticleModel.fromJson(widget.model.toJson());
          model.category = EArticleType.txt;
          model.content = _content;

          NavigatorUtil.pushReplacement(
              context,
              ArticlePage(
                model: model,
                isPlanText: true,
              ));
        },
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

  _updateTitle(String txt){
    widget.model.title = txt;
    widget.model.flag = 1;
    if(widget.model.tbId==null){
      if(widget.model.title.isNotEmpty){
        _dbModelProvider.insertArticle(widget.model).then((value){
          BotToast.showText(text: '添加成功');
          _refreshHomeList();
          setState(() {

          });
        });
      }else{
        BotToast.showText(text: '您未填写标题');
      }
    }else{
      _dbModelProvider.updateArticle(widget.model).then((value){
        BotToast.showText(text: '更新成功');
        _refreshHomeList();
        setState(() {

        });
      });
    }
  }

  _refreshHomeList(){
    NotifyEvent event = NotifyEvent(route: Constant.eb_home_list_refresh);
    eventBus.fire(event);
  }

}
