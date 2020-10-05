import 'package:flutter/material.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/home/article_model.dart';
import 'package:xylisten/listen/player/player_page.dart';
import 'package:xylisten/platform/res/styles.dart';
import 'package:xylisten/platform/xy_index.dart';

class LitePlayerView extends StatefulWidget {
  @override
  _LitePlayerViewState createState() => _LitePlayerViewState();
}

class _LitePlayerViewState extends State<LitePlayerView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: new Material(
          child: new Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: new Card(
              elevation: 10,
              child: InkWell(
                onTap: (){
                  print('object======');
//                  PlayerControlView.showPlayer(context,false);
                  _openModal4Player(context);
                },
                child: new Padding(
                  padding: EdgeInsets.only(left: 8,top: 8,right: 8,bottom: 0),
                  child: Container(
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
                                RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: "【${PlayData.curModel.getCategoryStr()}】",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                      TextSpan(
                                        text: PlayData.curModel.title ?? "",
                                        style: Theme.of(context).textTheme.subtitle1,
                                      ),
                                    ])),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '时长：${PlayData.curModel.count}秒',
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
                              PlayerControlView.hide();
                            },
                          )
                        ],
                      ),
                      LinearProgressIndicator(
                        backgroundColor: Theme.of(context).canvasColor,
                        minHeight: 1,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                        value: 0.2,
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Future _openModal4Player(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return PlayerPage();
        });
  }

}


class PlayerControlView {
  static OverlayEntry overlayEntry;

  static bool isPlaying = false;

  static void playOrPause(){
    isPlaying = !isPlaying;
    if(isPlaying){
      resume();
    }else{
      pause();
    }
  }

  static void play(){
    eventBus.fire(NotifyEvent(route:Constant.eb_play_status,argList: [Constant.play_status_playing]));
  }

  static void pause(){
    eventBus.fire(NotifyEvent(route:Constant.eb_play_status,argList: [Constant.play_status_pause]));
  }

  static void resume(){
    eventBus.fire(NotifyEvent(route:Constant.eb_play_status,argList: [Constant.play_status_continue]));
  }

  static void stop(){
    eventBus.fire(NotifyEvent(route:Constant.eb_play_status,argList: [Constant.play_status_stop]));
  }

  static void hide() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
    stop();
  }

  static void showPlayer(BuildContext context,bool isLiteMode,{ArticleModel model}){
    hide();
    if (overlayEntry == null) {
      if(model!=null){
        PlayData.curModel = model;
        play();
      }else{
        resume();
      }
      isPlaying = true;
      overlayEntry = new OverlayEntry(builder: (context) {
        return isLiteMode?LitePlayerView():PlayerPage();
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

}
