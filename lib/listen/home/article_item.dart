/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:xylisten/listen/home/acticle_model.dart';
import 'package:xylisten/listen/home/article_page.dart';
import 'package:xylisten/listen/player/player_control_view.dart';
import 'package:xylisten/platform/res/colors.dart';
import 'package:xylisten/platform/res/styles.dart';
import 'package:xylisten/platform/utils/navigator_util.dart';

class ArticleItem extends StatelessWidget {
  final ArticleModel model;

  const ArticleItem(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorUtil.pushPage(
            context,
            ArticlePage(
              model: model,
            ));
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "【文本】",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          TextSpan(
                            text: model.title ?? "",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ])),
                    Gaps.vGap8,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: new Row(
                        children: [
                          Text(
                            "时长：60分钟",
                            style: TextStyles.listContent,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.play_circle_outline),
                  color: Theme.of(context).accentColor,
                tooltip: '播放',
                onPressed: () {
                  PlayerControlView.showPlayer(context,true);
                },
              )
            ],
          ),
          decoration: new BoxDecoration(
              color: Theme.of(context).canvasColor,
              border: new Border(
                  bottom:
                      new BorderSide(width: 0.33, color: Theme.of(context).dividerColor)))),
    );
  }
}
