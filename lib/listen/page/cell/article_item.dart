/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/listen/model/playdata_model.dart';
import 'package:xylisten/listen/page/article_page.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/page/webview_page.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/res/styles.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';
import 'package:xylisten/platform/xy_index.dart';

class ArticleItem extends StatelessWidget {
  final ArticleModel model;
  //0: 播放 1：添加到播放器 2：回收站
  final int showType;
  final Function refreshCallback;

  const ArticleItem(this.model, {Key key, this.showType = 0,this.refreshCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelStatus = model.tbId == PlayData.curModel?.tbId;
    bool isPlaying = isSelStatus && PlayerControlView.isPlaying;

    _buildBtns() {
      if (showType == 0) {
        return IconButton(
          icon: isPlaying
              ? Icon(Icons.pause_circle_outline)
              : Icon(Icons.play_circle_outline),
          color: Theme.of(context).accentColor,
          tooltip: '播放',
          onPressed: () {
            if (isPlaying) {
              PlayerControlView.stop();
            } else {
              PlayerControlView.showPlayer(model: model);
              PlayerControlView.show();
            }
          },
        );
      } else if (showType == 1) {
        return IconButton(
          icon: Icon(Icons.add),
          color: Theme.of(context).accentColor,
          tooltip: '添加',
          onPressed: () {
            dbModelProvider
                .insertPlayData(PlayDataModel()..articleId = model.tbId)
                .then((value) {
              BotToast.showText(text: '[${model.title}]\n已添加至播放列表');
              PlayerControlView.refreshLayerList();
              if(refreshCallback!=null){
                refreshCallback();
              }
            });
          },
        );
      } else if (showType == 2) {
        return Row(
          children: [
            IconButton(
              icon: Icon(Icons.data_usage),
              color: Theme.of(context).accentColor,
              tooltip: '还原',
              onPressed: () {
                dbModelProvider
                    .trashArticle(model.tbId, 0)
                    .then((value) {
                  BotToast.showText(text: '[${model.title}]\n已回滚');
                  if(refreshCallback!=null){
                    refreshCallback();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_forever),
              color: Theme.of(context).accentColor,
              tooltip: '删除',
              onPressed: () {
                dbModelProvider.deleteArticle(model.tbId);
                if(refreshCallback!=null){
                  refreshCallback();
                }
              }),
          ],
        );
      }
    }

    return InkWell(
      onTap: () {
      if (showType == 0) {
        if (SlidableData.of(context).renderingMode ==
            SlidableRenderingMode.slide) {
          Slidable.of(context).close();
          return;
        }

        if (model.category == EArticleType.txt) {
          NavigatorUtil.pushPage(
              context,
              ArticlePage(
                model: model,
              ));
        } else {
          NavigatorUtil.pushPage(context, WebViewPage(model));
        }
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
                      style: isSelStatus
                          ? TextStyles.curPlayTitle(context)
                          : Theme.of(context).textTheme.bodyText2,
                    ),
                    Gaps.vGap8,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: new Row(
                        children: [
                          Text(
                            "字数：${model.count}个",
                            style: isSelStatus?TextStyles.curPlayContent(context):TextStyles.listContent,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildBtns(),
            ],
          ),
          decoration: new BoxDecoration(
              color: Theme.of(context).canvasColor,
              border: new Border(
                  bottom: new BorderSide(
                      width: 0.33, color: Theme.of(context).dividerColor)))),
    );
  }
}
