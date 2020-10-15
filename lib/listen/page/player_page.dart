import 'package:flutter/material.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/home/article_item.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/res/index.dart';
import 'package:xylisten/platform/xy_index.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  List<ArticleModel> _articleList = [];

  void _refreshList(){
    dbModelProvider.getPlayDataList().then((value) {
      setState(() {
        _articleList = value;
      });
    });
  }

  _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 8,bottom: 16,top: 16,right: 8),
      child: Row(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.timer, size: 30),
          ),
          IconButton(icon: Icon(Icons.skip_previous, size: 30)),
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
          ),
          IconButton(
            icon: Icon(Icons.description, size: 30),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<NotifyEvent>().listen((event) {
      if(mounted){
        if(event.route == Constant.eb_play_status){
          setState(() {

          });
        }
      }
    });

    _refreshList();
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
            Divider(),
            Expanded(
                child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ArticleItem(_articleList[index]);
              },
              itemExtent: 80.0,
              itemCount: _articleList.length,
            )),
          ]),
    );
  }
}
