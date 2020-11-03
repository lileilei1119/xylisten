/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/listen/dialog/link_dialog.dart';
import 'package:xylisten/listen/page/cell/article_item.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/page/settings_page.dart';
import 'package:xylisten/listen/page/webview_page.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';
import 'package:xylisten/platform/widget/xy_widget.dart';
import 'package:xylisten/platform/xy_index.dart';

import 'article_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ArticleModel> _articleList = [];
  bool _isListEmpty = false;

  ScrollController _scrollController = ScrollController();

  void _delItem(ArticleModel model) {
    dbModelProvider.trashArticle(model.tbId, 1).then((value) {
      _articleList.remove(model);
      setState(() {
        _isListEmpty = (_articleList?.length == 0);
      });
    });
  }

  void _refreshList() {
    dbModelProvider.getArticleList(0).then((value) {
      setState(() {
        _articleList = value;
        _isListEmpty = (_articleList?.length == 0);
      });
    });
  }

  _scrapHtml(String url) {
    if (url.isNotEmpty && url.startsWith("http")) {
      String title =
          RegExp(r"(http|https)://(www.)?(\w+(\.)?)+").stringMatch(url);
      String content = '该链接尚未拉取，请进入拉取哦';
      ArticleModel model = ArticleModel(
          title: title, category: EArticleType.url, content: content, url: url);
      dbModelProvider.insertArticle(model).then((value) {
        _articleList.insert(0, model);
        setState(() {});
        NavigatorUtil.pushPage(context, WebViewPage(model));
      });
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text('请输入正确的网址（以http或https开头的字符串）'),
        action: SnackBarAction(
          label: '知道了',
          onPressed: () {},
        ),
      ));
    }
  }

  _initPlayView() async{
    Future.delayed(Duration(seconds: 1)).then((value) => PlayerControlView.init(context));
  }

  @override
  void initState() {
    super.initState();

    dbModelProvider.openDB().then((value) {
      _refreshList();
    });

    eventBus.on<NotifyEvent>().listen((event) {
     if (event.route == Constant.eb_home_list_refresh) {
        _refreshList();
      } else if (event.route == Constant.eb_play_status) {
        setState(() {});
      }
    });

    _initPlayView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('留声'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.note_add),
            tooltip: "新建文本",
            onPressed: () => NavigatorUtil.pushPage(context, ArticlePage()),
          ),
          _buildPopMenu(context),
        ],
      ),
      body: _isListEmpty
          ? Align(alignment: Alignment(0.0, -0.8), child: Text('您尚未创建任何内容，请点击右上角添加吧~'))
          : _buildBody(context),
      drawer: SettingsPage(),
    );
  }

  _showLinkDialog(BuildContext context) async {
    var clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain); //获取粘贴板中的文本
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return LinkDialog(
            clipboardTxt: clipboardData?.text,
            onOKPressed: (String txt) {
              if (txt.isNotEmpty) {
                _scrapHtml(txt);
              } else {
                BotToast.showText(text: '请输入url网址');
              }
            },
          );
        });
  }

  _buildPopMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        XyWidget.buildSelectView(context, Icons.link, '抓取网页', 'newLink'),
//        PopupMenuDivider(
//          height: 1,
//        ),
//        XyWidget.buildSelectView(context, Icons.description, '二维码', 'newTxt'),
//        PopupMenuDivider(
//          height: 1,
//        ),
      ],
      onSelected: (String action) {
        // 点击选项的时候
        switch (action) {
          case 'newLink':
            _showLinkDialog(context);
            break;
        }
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          //do something
          if (notification is ScrollEndNotification) {
            print('停止滚动');
            if (_scrollController.position.extentAfter == 0) {
              print('滚动到底部');
              if(PlayerControlView.isShow){
                PlayerControlView.hide();
              }
            }else{
              if(!PlayerControlView.isShow){
                PlayerControlView.show();
              }
            }
          }
          return true;
        },
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            ArticleModel model = _articleList[index];
            return Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '删除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      _delItem(model);
                    },
                  ),
                ],
                child: ArticleItem(model));
          },
          controller: _scrollController,
          itemExtent: 80.0,
          itemCount: _articleList?.length ?? 0,
        ),
      ),
    );
  }
}
