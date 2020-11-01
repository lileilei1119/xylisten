/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/listen/page/article_page.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/page/webview_page.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/res/styles.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';
import 'package:xylisten/platform/xy_index.dart';

class PlayerItem extends StatelessWidget {
  final ArticleModel model;

  const PlayerItem(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelStatus = model.tbId == PlayData.curModel?.tbId;
    bool isPlaying = isSelStatus && PlayerControlView.isPlaying;

    return InkWell(
      onTap: () {
        if (isPlaying) {
          PlayerControlView.pause();
        } else {
          PlayerControlView.skip(model);
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "【${model.getCategoryStr()}】" + model.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: isSelStatus?TextStyles.curPlayTitle(context):Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey,
                  size: 18,
                ),
                tooltip: '移除播放列表',
                onPressed: () {
                  if (model.tbId == PlayData.curModel.tbId) {
                    showAlertDialog4Del(context);
                  } else {
                    _delItem();
                  }
                },
              )
            ],
          ),
          decoration: new BoxDecoration(
              color: Theme.of(context).canvasColor,
              border: new Border(
                  bottom: new BorderSide(
                      width: 0.33, color: Theme.of(context).dividerColor)))),
    );
  }

  _delItem() {
    dbModelProvider.deletePlayDataByArticleId(model.tbId).then((value) {
//      PlayerControlView.deleteById(model.tbId);
      PlayerControlView.refreshLayerList();
    });
  }

  showAlertDialog4Del(BuildContext context) {
    //设置按钮
    Widget cancelButton = FlatButton(
      child: Text("取消"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("删除"),
      onPressed: () {
        PlayerControlView.stop();
        _delItem();
        Navigator.of(context).pop();
      },
    );

    //设置对话框
    AlertDialog alert = AlertDialog(
      title: Text("确认提示"),
      content: Text("该项正在播放，是否确定删除？"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    //显示对话框
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
