/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xy_tts/xy_tts.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/page/home_page.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/utils/common_utils.dart';
import 'platform/xy_index.dart';
import 'package:path_provider/path_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String audioPath;
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  void _onEvent(Object event) {
    if(event is Map){
      String route = event["route"];
      if(route == 'onFinish'){
        PlayerControlView.next();
      }else if(route == 'onRemotePre'){
        PlayerControlView.pre();
      }else if(route == 'onRemoteNext'){
        PlayerControlView.next();
      }else if(route =='onRemotePause'){
        PlayerControlView.pause();
      } else if (route == 'onRemotePlay') {
        PlayerControlView.resumeOrPlay();
      }
    }
  }

  void _onError(Object error) {

  }

  Future _loadAudioFile() async {
    final file = new File('${(await getTemporaryDirectory()).path}/split.mp3');
    await file.writeAsBytes((await rootBundle.load('assets/audio/split.mp3')).buffer.asUint8List());
    audioPath = file.path;
  }

  @override
  void initState() {

    _loadAudioFile();
    
    XyTts.eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

    eventBus.on<NotifyEvent>().listen((event) {
      if (event.route == Constant.eb_dark_mode) {
        setState(() {
        });
        CommonUtils.setDarkMode(Global.isDarkMode);
      }else if(event.route == Constant.eb_play_status){
        String status = event.argList.first;
        if(status == Constant.play_status_playing){
          //如果手动设置了标题，则读标题
          String title = PlayData.curModel.flag==1?PlayData.curModel.title:"";
          XyTts.startTTS(PlayData.curModel.title,title+PlayData.curModel.getPlanText());
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
            //如果手动设置了标题，则读标题
            String title = PlayData.curModel.flag==1?PlayData.curModel.title:"";
            XyTts.startTTS(PlayData.curModel.title,title+PlayData.curModel.getPlanText());
          }
        }else if(status == Constant.play_status_stop){
          XyTts.stopTTS();
        }
      }else if(event.route == Constant.eb_play_split_audio){
        audioPlayer.play(audioPath, isLocal: true);
      }
    });
    super.initState();

    updateDarkMode();
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
        brightness: Global.isDarkMode??false? Brightness.dark : Brightness.light,
      ),
      home: HomePage(),
    );
  }

  /// Mark: private method
  void updateDarkMode() async{
    bool value = await CommonUtils.getDarkMode();
    setState(() {
       Global.isDarkMode = value;
     });
  }

}
