/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xylisten/config/db_config.dart';
import 'package:xylisten/listen/home/article_item.dart';
import 'package:xylisten/listen/home/article_model.dart';
import 'package:xylisten/platform/xy_index.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ArticleModel> _articleList = [];

  DbModelProvider _dbModelProvider = DbModelProvider();

  void _delItem(ArticleModel model){
    _dbModelProvider.delete(model.tbId).then((value){
      _articleList.remove(model);
      setState(() {

      });
    });
  }

  @override
  void initState() {
    super.initState();

    _dbModelProvider.openDB().then((value) {
      _dbModelProvider.getArticleList().then((value) {
        setState(() {
          _articleList = value;
        });
      });
    });

    eventBus.on<NotifyEvent>().listen((event) {
      if (event.route == Constant.eb_add_link) {
        ArticleModel model = ArticleModel(title: 'linklink',category: EArticleType.url,content: event.argList.first);
        _dbModelProvider.insert(model).then((value){
          _articleList.insert(0, model);
          setState(() {

          });
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          ArticleModel model = _articleList[index];
          return Slidable(
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.25,
              secondaryActions: <Widget>[
                //右侧按钮列表
                IconSlideAction(
                  caption: '编辑',
                  color: Colors.black45,
                  icon: Icons.description,
                  onTap: () {},
                ),
                IconSlideAction(
                  caption: '删除',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    _delItem(model);
                  },
                ),
              ],
              child: ArticleItem(model));
        },
        itemExtent: 80.0,
        itemCount: _articleList.length,
      ),
    );
  }
}
