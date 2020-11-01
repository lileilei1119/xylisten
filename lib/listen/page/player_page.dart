import 'package:flutter/material.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/page/cell/player_item.dart';
import 'package:xylisten/listen/page/player_add_page.dart';
import 'package:xylisten/listen/page/webview_page.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/res/index.dart';
import 'package:xylisten/platform/utils/common_utils.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';
import 'package:xylisten/platform/xy_index.dart';

import 'article_page.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {

  _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 8,bottom: 16,top: 16,right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PlayData.curModel==null?
            Text('暂未播放内容', style: Theme.of(context).textTheme.subtitle1,):
            Column(
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
                    '字数：${PlayData.curModel.count}个',
                    style: TextStyles.listContent,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            alignment: Alignment(1.0, -4.0),
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  _buildPlayView() {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.timer, size: 30),
                onPressed: ()=>_openModal4Timer(context),
              ),
              Text('${CommonUtils.sec2Str(PlayerControlView.leftSec)}',style: Theme.of(context).textTheme.caption,),
            ]
          ),
          IconButton(
              icon: Icon(Icons.skip_previous, size: 30),
              onPressed: PlayerControlView.hasPre()?()=>PlayerControlView.pre():null,
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(
              PlayerControlView.isPlaying
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
              color: Theme.of(context).accentColor,
              size: 48,
            ),
            onPressed: () {
              PlayerControlView.playOrPause();
              setState(() {
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.skip_next, size: 30),
            onPressed: PlayerControlView.hasNext()?()=>PlayerControlView.next():null,
          ),
          IconButton(
            icon: Icon(Icons.description, size: 30),
            onPressed: (){
              if(PlayData.curModel!=null){
                if (PlayData.curModel.category == EArticleType.txt) {
                  NavigatorUtil.pushPage(
                      context,
                      ArticlePage(
                        model: PlayData.curModel,
                      ));
                } else {
                  NavigatorUtil.pushPage(
                      context,
                      WebViewPage(PlayData.curModel));
                }
              }else{
                BotToast.showText(text: '当前播放内容为空');
              }
            },
          ),
        ],
      ),
    );
  }

  _buildListHeader(){
    return Container(
      height: 40,
      color: Colors.grey,
      child: Padding(
        padding: EdgeInsets.only(left: 8,right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Text('播放列表',style: Theme.of(context).textTheme.button,)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete, size: 24),
                  tooltip: '清空播放列表',
                  onPressed: (){
                    dbModelProvider.clearPlayDataList().then((value) {
                      PlayerControlView.refreshLayerList();
                      PlayData.curModel = null;
                      PlayerControlView.stop();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_box, size: 24),
                  tooltip: '添加内容至播放列表',
                  onPressed: (){
                    NavigatorUtil.pushPage(context, PlayerAddPage());
                  },
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<NotifyEvent>().listen((event) {
      if(mounted){
        if(event.route == Constant.eb_play_status){
          setState(() {});
        }else if(event.route == Constant.eb_timer_countdown){
          setState(() {});
        }else if(event.route == Constant.eb_refresh_player_list){
          setState(() {});
        }
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildPlayView(),
            _buildListHeader(),
            Expanded(
                child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return PlayerItem(PlayData.playList[index]);
              },
              itemExtent: 44.0,
              itemCount: PlayData.playList.length,
            )),
          ]),
    );
  }

  Future _openModal4Timer(BuildContext context) async {

    _buildItem(int value){

      String title = '';
      switch(value){
        case 15:
          title = '15分钟后关闭';
          break;
        case 30:
          title = '半小时后关闭';
          break;
        case 60:
          title = '1小时后关闭';
          break;
        case 120:
          title = '2小时后关闭';
          break;
        case 0:
          title = '关闭';
          break;

      }

      return ListTile(
        title: Text('$title', textAlign: TextAlign.center),
        onTap: (){
          if(value<=0){
            PlayerControlView.stopTimer();
          }else{
            PlayerControlView.startTimer(value*60);
          }
          Navigator.pop(context);
          setState(() {});
        },
      );
    }

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300.0,
            child: Column(
              children: <Widget>[
                _buildItem(15),
                Divider(
                  height: 1,
                ),
                _buildItem(30),
                Divider(
                  height: 1,
                ),
                _buildItem(60),
                Divider(
                  height: 1,
                ),
                _buildItem(120),
                Divider(
                  height: 1,
                ),
                _buildItem(0),
              ],
            ),
          );
        });
  }

}
