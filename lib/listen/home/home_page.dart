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

  void _refreshList(){
    _dbModelProvider.getArticleList().then((value) {
      setState(() {
        _articleList = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _dbModelProvider.openDB().then((value) {
      _refreshList();
    });

    eventBus.on<NotifyEvent>().listen((event) {
      if (event.route == Constant.eb_add_link) {
        String url = event.argList.first;
        if(url.isNotEmpty && url.startsWith("http")){
          String title = RegExp(r"(http|https)://(www.)?(\w+(\.)?)+").stringMatch(url);
          ArticleModel model = ArticleModel(title: title,category: EArticleType.url,url: url);
          _dbModelProvider.insert(model).then((value){
            _articleList.insert(0, model);
            setState(() {

            });
          });
        }else{
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Text('请输入正确的网址（以http或https开头的字符串）'),
            action: SnackBarAction(
              label: '知道了',
              onPressed: (){},
            ),
          ));
        }
      }else if(event.route == Constant.eb_home_list_refresh){
        print('====sssss====');
        _refreshList();
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
        itemCount: _articleList?.length??0,
      ),
    );
  }
}
