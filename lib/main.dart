/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xy_tts/xy_tts.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/utils/common_utils.dart';
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

  void _onEvent(Object event) {
    if(event is Map){
      String route = event["route"];
      if(route == 'onFinish'){
        PlayerControlView.pause();
      }
    }
  }

  void _onError(Object error) {

  }

  @override
  void initState() {

    XyTts.eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

    eventBus.on<NotifyEvent>().listen((event) {
      if (event.route == Constant.eb_dark_mode) {
        setState(() {
          _isDarkMode = Constant.isDarkMode;
        });
      }else if(event.route == Constant.eb_play_status){
        String status = event.argList.first;
        if(status == Constant.play_status_playing){
          XyTts.startTTS(PlayData.curModel.getPlanText());
        }else if(status == Constant.play_status_pause){
          if(Platform.isIOS){
            XyTts.pauseTTS();
          }else{
            XyTts.stopTTS();
          }
        }else if(status == Constant.play_status_continue){
          if(Platform.isIOS){
            XyTts.continueTTS();
          }else{
            XyTts.startTTS(PlayData.curModel.getPlanText());
          }
        }else if(status == Constant.play_status_stop){
          XyTts.stopTTS();
        }
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
