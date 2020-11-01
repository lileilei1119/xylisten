import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/model/playdata_model.dart';
import 'package:xylisten/listen/page/player_add_page.dart';
import 'package:xylisten/listen/page/player_page.dart';
import 'package:xylisten/platform/res/styles.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';
import 'package:xylisten/platform/xy_index.dart';

class LitePlayerView extends StatefulWidget {

  @override
  _LitePlayerViewState createState() => _LitePlayerViewState();

}

class _LitePlayerViewState extends State<LitePlayerView> {

  double _bottom = 0;

  @override
  void initState() {
    super.initState();

    eventBus.on<NotifyEvent>().listen((event) {
      if (event.route == Constant.eb_player_show) {
        bool isShow = event.argList.first;
        if(isShow){
          setState(() {
            _bottom = 0;
          });
        }else{
          setState(() {
            _bottom = -100;
          });
        }
      }else if(event.route == Constant.eb_play_status){
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: _bottom,
        child: new Material(
          child: new Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: new Card(
              elevation: 10,
              child: InkWell(
                onTap: (){
                  if(PlayData.curModel==null){
                    _openModal4Player(context);
                    NavigatorUtil.pushPage(context, PlayerAddPage());
                  }else{
                    _openModal4Player(context);
                  }
                },
                child: new Padding(
                  padding: EdgeInsets.only(left: 8,top: 8,right: 8,bottom: 0),
                  child: PlayData.curModel==null?_buildNonePlayView():_buildLitePlayView(),
                ),
              ),
            ),
          ),
        ));
  }

  _buildNonePlayView(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.add_box),
          Gaps.hGap8,
          Expanded(child: Text('点击添加播放列表')),
          IconButton(
            icon: Icon(Icons.close,color: Colors.grey),
            onPressed: (){
              PlayerControlView.shutdown();
            },
          )
        ],
      ),
    );
  }

  _buildLitePlayView(){
    return Container(
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "【${PlayData.curModel.getCategoryStr()}】" + PlayData.curModel.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '字数：${PlayData.curModel.count}个',
                      style: TextStyles.listContent,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                PlayerControlView.isPlaying?Icons.pause_circle_outline:Icons.play_circle_outline,
                color: Theme.of(context).accentColor,
                size: 30,
              ),
              onPressed: (){
                setState(() {
                  PlayerControlView.playOrPause();
                });
              },
            ),

            IconButton(
              icon: Icon(Icons.close,color: Colors.grey),
              onPressed: (){
                PlayerControlView.shutdown();
              },
            )
          ],
        ),
//                      LinearProgressIndicator(
//                        backgroundColor: Theme.of(context).canvasColor,
//                        minHeight: 1,
//                        valueColor: new AlwaysStoppedAnimation<Color>(
//                            Theme.of(context).primaryColor),
//                        value: 0.2,
//                      )
      ]),
    );
  }

  Future _openModal4Player(BuildContext context) async {

    PlayerControlView.hide();

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return PlayerPage();
        }).then((value){
          PlayerControlView.show();
    });
  }

}


class PlayerControlView {
  static OverlayEntry overlayEntry;

  static bool isPlaying = false;

  static Timer _countdownTimer;
  static int leftSec = 0;

  static void startTimer(int sec){
    stopTimer();
    leftSec = sec;
    const timeout = const Duration(seconds: 1);
    _countdownTimer = Timer.periodic(timeout, (timer) {
      leftSec --;
      eventBus.fire(NotifyEvent(route: Constant.eb_timer_countdown));
      if(leftSec > 0 ){

      }else{
        timer.cancel();  // 取消定时器
        PlayerControlView.stop();
      }
    });

  }

  static void stopTimer(){
    //小于0时刷新界面
    leftSec = 0;
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  static void playOrPause(){
    if(!isPlaying){
      resume();
    }else{
      pause();
    }
  }

  static void play(){
    isPlaying = true;
    eventBus.fire(NotifyEvent(route:Constant.eb_play_status,argList: [Constant.play_status_playing]));
  }

  static void pause(){
    isPlaying = false;
    eventBus.fire(NotifyEvent(route:Constant.eb_play_status,argList: [Constant.play_status_pause]));
  }

  static void resume(){
    isPlaying = true;
    eventBus.fire(NotifyEvent(route:Constant.eb_play_status,argList: [Constant.play_status_continue]));
  }

  static void stop(){
    isPlaying = false;
    eventBus.fire(NotifyEvent(route:Constant.eb_play_status,argList: [Constant.play_status_stop]));
  }

  static void show(){
    eventBus.fire(NotifyEvent(route:Constant.eb_player_show,argList: [true]));
  }

  static void hide(){
    eventBus.fire(NotifyEvent(route:Constant.eb_player_show,argList: [false]));
  }

  static void playSplitAudio(){
    eventBus.fire(NotifyEvent(route:Constant.eb_play_split_audio));
  }

  static void shutdown() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
    PlayData.playIdx = 0;
    PlayData.curModel = null;
    stop();
  }

  static void showPlayer(BuildContext context,{ArticleModel model}){
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (context) {
        return LitePlayerView();
      });
      Overlay.of(context).insert(overlayEntry);
    }

    if(model!=null){
      PlayData.curModel = model;
      dbModelProvider.insertPlayData(PlayDataModel()..articleId=model.tbId).then((value){
        play();
        PlayData.playIdx = 0;
        refreshLayerList();
      });
    }else{
      resume();
    }
  }

  static void refreshLayerList(){
    dbModelProvider.getPlayDataList().then((value) {
      PlayData.playList = value;
      eventBus.fire(NotifyEvent(route: Constant.eb_refresh_player_list));
    });
  }

  static void next(){
    if(hasNext()){
      PlayData.playIdx++;
      PlayData.curModel = PlayData.playList[PlayData.playIdx];
      playSplitAudio();
      Future.delayed(Duration(seconds: 1)).then((value) => play());
    }else{
      stop();
    }
  }

  static void pre(){
    if(hasPre()){
      PlayData.playIdx--;
      PlayData.curModel = PlayData.playList[PlayData.playIdx];
      play();
    }
  }

  static void skip(ArticleModel model){
    int idx = 0;
    PlayData.playList.forEach((element) {
      if(model.tbId==element.tbId){
        PlayData.curModel = model;
        PlayData.playIdx = idx;
        play();
        return;
      }
      idx ++;
    });
  }

  static void deleteById(int tbId){
    ArticleModel model = getDelModelById(tbId);
    if(model!=null){
      PlayData.playList.remove(model);
    }
  }

  static ArticleModel getDelModelById(int tbId){
    int idx = 0;
    PlayData.playList.forEach((element) {
      idx ++;
      if(tbId==element.tbId){
        if(idx<PlayData.playIdx){
          PlayData.playIdx--;
        }else if(idx == PlayData.playIdx){
          play();
        }else{
          //不需要处理
        }
        return element;
      }
    });
    return null;
  }

  static bool hasNext(){
    if(PlayData.playIdx<PlayData.playList.length-1){
      return true;
    }
    return false;
  }

  static bool hasPre(){
    if(PlayData.playIdx==0){
      return false;
    }
    return true;
  }

}
