/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:xylisten/listen/home/article_edit_page.dart';
import 'package:xylisten/listen/home/article_page.dart';
import 'package:xylisten/listen/home/home_page.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/listen/settings/settings_page.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('留声'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '新建',
            onPressed: () {
              NavigatorUtil.pushPage(context, ArticleEditPage());
            },
          )
        ],
      ),
      body: HomePage(),
      drawer: SettingsPage(),
    );
  }
}
