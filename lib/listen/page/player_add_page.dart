import 'package:flutter/material.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/xy_index.dart';

import 'cell/article_item.dart';

class PlayerAddPage extends StatefulWidget {
  final showType;
  final isFromLitePlayer;

  const PlayerAddPage({Key key, this.showType=1,this.isFromLitePlayer=false}) : super(key: key);

  @override
  _PlayerAddPageState createState() => _PlayerAddPageState();
}

class _PlayerAddPageState extends State<PlayerAddPage> {

  List<ArticleModel> _articleList = [];

  void _refreshList(){
    int optVal = widget.showType==1?0:1;
    if(widget.showType==1){
      dbModelProvider.getArticle4Add().then((value) {
        setState(() {
          _articleList = value;
        });
      });
    }else if(widget.showType==2){
      dbModelProvider.getArticleList(optVal).then((value) {
        setState(() {
          _articleList = value;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        if(widget.showType==1){
          if(PlayData.curModel==null && PlayData.playList.length>0){
            PlayData.curModel = PlayData.playList.first;
            PlayData.playIdx = 0;
            PlayerControlView.refreshLayerList();
          }
          if(widget.isFromLitePlayer){
            PlayerControlView.show();
          }
        }else {
          eventBus.fire(NotifyEvent(route: Constant.eb_home_list_refresh));
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.showType==1?'添加播放源':'回收站'),
          actions: [
            widget.showType==2?FlatButton(
              child: Text('清空',style: TextStyle(color: Colors.white),),
              onPressed: (){
                dbModelProvider.clearTrashArticle().then((value){
                  _refreshList();
                  BotToast.showText(text: '已清空回收站');
                  Future.delayed(Duration(seconds: 1)).then((value) => Navigator.pop(context));
                });
              },
            ):Container()
          ],
        ),
        body:_buildBody(),
      ),
    );
  }

  _buildBody(){
    if( _articleList?.length==0){
      return Align(
          alignment: Alignment(0.0, -0.8),
          child: Text(widget.showType==1?'您尚未有可添加的播放源':'您已清空回收站了')
      );
    }else{
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          ArticleModel model = _articleList[index];
          return ArticleItem(model,showType: widget.showType,refreshCallback: ()=>_refreshList(),);
        },
        itemExtent: 80.0,
        itemCount: _articleList?.length??0,
      );
    }
  }
}
