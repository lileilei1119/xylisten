/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:xylisten/listen/home/article_item.dart';
import 'package:xylisten/listen/home/acticle_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<ArticleModel> _acticleList = [];

  ArticleModelProvider _articleModelProvider = ArticleModelProvider();

  @override
  void initState() {
    _articleModelProvider.open().then((value){
//      _articleModelProvider.insert(ArticleModel(title: '好好学习',content: '天天向上'));
//      _articleModelProvider.insert(ArticleModel(title: '好好学习',content: c2));
      _articleModelProvider.getArticleList().then((value){
        setState(() {
          _acticleList = value;
        });
      });
    });

//    _acticleList = [
//      ArticleModel(title: '好好学习',content: '天天向上'),
//      ArticleModel(title: '好好学习',content: c2),
//    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(itemBuilder: (BuildContext context,int index){
        return ArticleItem(_acticleList[index]);
      },
      itemExtent: 80.0,
      itemCount: _acticleList.length,
      ),
    );
  }
}