/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:xylisten/listen/dialog/link_dialog.dart';
import 'package:xylisten/listen/page/article_page.dart';
import 'package:xylisten/listen/page/home_page.dart';
import 'package:xylisten/listen/page/settings_page.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';
import 'package:xylisten/platform/widget/xy_widget.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  _buildPopMenu(BuildContext context){
    return PopupMenuButton<String>(
      icon: Icon(Icons.add),
      itemBuilder: (BuildContext context) =>
      <PopupMenuEntry<String>>[
        XyWidget.buildSelectView(context,Icons.description, '新建文本', 'newTxt'),
        PopupMenuDivider(
          height: 1,
        ),
        XyWidget.buildSelectView(context,Icons.link, '抓取网页', 'newLink'),
        PopupMenuDivider(
          height: 1,
        ),
      ],
      onSelected: (String action) {
        // 点击选项的时候
        switch (action) {
          case 'newTxt':
            NavigatorUtil.pushPage(context, ArticlePage());
            break;
          case 'newLink':
            _showLinkDialog(context);
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('留声'),
        actions: [
          _buildPopMenu(context)
        ],
      ),
      body: HomePage(),
      drawer: SettingsPage(),
    );
  }

  _showLinkDialog(BuildContext context) async{
    await showDialog(context: context,barrierDismissible: true,builder: (context){
          return LinkDialog();
    });
  }

}
