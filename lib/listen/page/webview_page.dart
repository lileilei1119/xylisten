import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';

import 'article_page.dart';

class WebViewPage extends StatefulWidget {
  final ArticleModel model;
  //0 拉取类型 1 显示类型
  final int type;

  WebViewPage(this.model,{this.type=0});

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
    flutterWebViewPlugin.evalJavascript("document.body.innerText").then((result) {
      _content = result;
      setState(() {

      });
      if(widget.type==0){
        skipArticlePage();
      }
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
        widget.type==0?
        "正在拉取网页内容，请稍后……":
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

  skipArticlePage(){
    if(_content!=null && _content.isNotEmpty){
      flutterWebViewPlugin.hide();
      //深复制一个对象
      ArticleModel model = ArticleModel.fromJson(widget.model.toJson());
      model.category = EArticleType.txt;
      model.content = _content;

      NavigatorUtil.pushReplacement(
          context,
          ArticlePage(
            model: model,
            isGrabType: true,
          ));
    }
  }

}
