/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xylisten/listen/page/article_page.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/page/webview_page.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/res/styles.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';
import 'package:xylisten/platform/xy_index.dart';

class ArticleItem extends StatelessWidget {
  final ArticleModel model;

  const ArticleItem(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool isSelStatus = model.tbId == PlayData.curModel?.tbId;
    bool isPlaying = isSelStatus && PlayerControlView.isPlaying;

    return InkWell(
      onTap: () {
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
          NavigatorUtil.pushPage(
              context,
              WebViewPage(model));
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
                      style: isSelStatus?Theme.of(context).textTheme.bodyText1:Theme.of(context).textTheme.bodyText2,
                    ),
                    Gaps.vGap8,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: new Row(
                        children: [
                          Text(
                            "时长：${model.count}秒",
                            style: TextStyles.listContent,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: isPlaying?Icon(Icons.pause_circle_outline):Icon(Icons.play_circle_outline),
                color: Theme.of(context).accentColor,
                tooltip: '播放',
                onPressed: () {
                  if(isPlaying){
                    PlayerControlView.pause();
                  }else{
                    PlayerControlView.showPlayer(context,model: model);
                    PlayerControlView.show();
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
}
