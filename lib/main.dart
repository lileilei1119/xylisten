/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/platform/utils/common_utils.dart';
import 'listen/home/article_edit_page.dart';
import 'listen/main/main_page.dart';
import 'platform/xy_index.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isDarkMode = false;

  @override
  void initState() {
    eventBus.on().listen((event) {
      if (event == Constant.eb_dark_mode) {
        setState(() {
          _isDarkMode = Constant.isDarkMode;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      theme: ThemeData(
//        canvasColor: XyColors.app_bg,
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: _isDarkMode? Brightness.dark : Brightness.light,
      ),
      home: MainPage(),
      routes: <String,WidgetBuilder>{
        'article':(_)=>ArticleEditPage(),
      },
    );
  }

  /// Mark: private method
  void updateDarkMode() {
    CommonUtils.getDarkMode().then((value) {
      setState(() {
        Constant.isDarkMode = value;
      });
    });
  }

}
