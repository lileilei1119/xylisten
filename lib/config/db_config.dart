import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/model/article_model.dart';
import 'package:xylisten/listen/model/playdata_model.dart';

Database db;

DbModelProvider dbModelProvider = DbModelProvider();

class DbModelProvider {
  Future openDB() async {
    db =
        await openDatabase(Constant.xy_db_name, version: Constant.xy_db_version,
            onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableArticle ( 
  $tbId integer primary key autoincrement, 
  $ids text,
  $title text not null,
  $url text,
  $content text,
  $category integer not null,
  $userId text,
  $count integer not null default 0,
  $flag integer not null default 0,
  $opt integer not null default 0,
  $createDate text,
  $tagId text
  );
''');
      await db.execute('''
    create table $tablePlayData ( 
  $pd_tbId integer primary key autoincrement, 
  $pd_articleId integer, 
  $pd_flag integer not null default 0,
  $pd_tagId text,
  $pd_seat integer not null default 0
  );
    ''');

  //插入 app使用说明
//  ArticleModel model = ArticleModel(flag:1,count: 843,title: '留声App使用说明书',content: '''[{"insert":"留声是一款使用TTS语音播报您个人笔记的APP，内置了简洁实用的富文本编辑器。当您在吃饭时、散步时，开车时，使用留声播报您的笔记心得，做到真正的一心多用，开启多线程高效人生。亦或者，当你睡前使用留声播报一天的总结，以及次日的安排，以充满希望的声音伴您入眠。\n\n留声的功能介绍如下：\n一、新建笔记\n目前您有两种方式添加笔记，一是直接使用我们内置的富文本编辑器；二是使用抓取网站链接的方式。\n在富文本编辑器中，您可以添加数字序号、点序号、引用、图片等多种常见的操作。"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"使用抓取网页功能时，您可以将其他网站的链接输入到留声抓取对话框中，直接拉取内容，转换成您自己的笔记。在大部分知名文本信息类的APP都有系统分享或者复制链接功能，您可以将它复制到黏贴板，打开留声APP，点击”抓取网页“功能，留声会自动识别黏贴板中的网址，一键拉取。"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"\n二、播放器\n留声内置播放器，可以以TTS方式播报您的笔记。播放器有迷你板和半屏板两种形式。迷你板不会阻塞您当前任何操作，可以在任何界面下方显示。当您需要查看、添加或删除播放列表时，点击迷你板会切换到半屏板。\n在半屏板，您还可以进行定时操作，这个特别适合您睡前操作哦，以复习知识点的方式入眠非常nice。当您听到不确定不明白的知识点时。还可以点击上面的文稿按钮，查看当前播放文本。\n此外留声播放器支持后台模式、支持远程事件。在锁机状态时，您也可以切换或者暂停。\n\n三、其他功能\n 考虑到您录入笔记不易。留声内置了回收站功能，可以最大程度上排除误删。"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"设置了暗黑模式，暗黑模式很酷的，而且保护眼睛，可以试试哦"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"播报语速设置：您可以挑一个您喜欢的速度，建议使用默认倍速（1倍速）哦！"},{"insert":"\n","attributes":{"block":"ol"}},{"insert":"\n留声App，还在完善之中，我们一直在路上，如果您有更好建议或反馈，请在我们的APPStore上评论留言或者给我们发邮件，我们的邮箱地址lileilei1119@163.com 谢谢！\n\n最后，如果您已经阅读了该说明书并清楚了使用方法。您可以把这篇文档删除，给您一个更澄净，完全属于您自己的空间。\n\n再见！留声会安静地守护您！\n"}]''');
  String jsonStr = await rootBundle.loadString('assets/data/init_article.json');
  Map<String, dynamic> map = json.decode(jsonStr);
  await db.insert(tableArticle, map);

    });
  }

  /// Article部分
  Future<ArticleModel> insertArticle(ArticleModel article) async {
    article.tbId = await db.insert(tableArticle, article.toJson());
    return article;
  }

  Future<ArticleModel> getArticle(int id) async {
    List<Map> maps = await db.query(tableArticle,
        columns: [tbId, title, content, count],
        where: '$tbId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return ArticleModel.fromJson(maps.first);
    }
    return null;
  }

  Future<List<ArticleModel>> getArticleList(int optVal) async {
    List<Map<String, dynamic>> records =
        await db.rawQuery('SELECT * FROM $tableArticle where $opt=? order by $tbId desc',[optVal]);
    List<ArticleModel> list = [];
    if (records.length > 0) {
      list = records.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ArticleModel>> getArticle4Add() async {
    List<Map<String, dynamic>> records =
    await db.rawQuery('SELECT * FROM $tableArticle where $opt=0 and $tbId not in ( SELECT $pd_articleId FROM $tablePlayData ) order by $tbId desc');
    List<ArticleModel> list = [];
    if (records.length > 0) {
      list = records.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<int> getArticleListCount(int optVal) async {
    List<Map<String, dynamic>> records =
    await db.rawQuery('SELECT count(*) as num FROM $tableArticle where $opt=? order by $tbId desc',[optVal]);
    return records.first['num'];
  }

  Future<int> deleteArticle(int id) async {
    return await db.delete(tableArticle, where: '$tbId = ?', whereArgs: [id]);
  }

  //丢进垃圾桶
  Future<int> trashArticle(int id,int val) async {
    return await db.update(tableArticle, {opt:val},where: '$tbId=$id');
  }

  Future<int> clearTrashArticle() async {
    return await db.delete(tableArticle, where: '$opt=1');
  }

  Future<int> updateArticle(ArticleModel article) async {
    return await db.update(tableArticle, article.toJson(),
        where: '$tbId = ?', whereArgs: [article.tbId]);
  }

  /// playData部分
  Future<PlayDataModel> insertPlayData(PlayDataModel playData) async {
    await deletePlayDataByArticleId(playData.articleId);
    playData.tbId = await db.insert(tablePlayData, playData.toJson());
    return playData;
  }

  Future<int> deletePlayDataByArticleId(int id) async {
    return await db.delete(tablePlayData, where: '$pd_articleId = ?', whereArgs: [id]);
  }

  Future<List<ArticleModel>> getPlayDataList({int flag = 0}) async {
//    List<Map<String, dynamic>> records = await db.rawQuery(
//        'SELECT * FROM $tableArticle where $opt!=1 and $tbId in (SELECT $pd_articleId FROM $tablePlayData where $pd_flag=? order by $pd_seat desc,$pd_tbId desc)',
//        [flag]);
    List<Map<String, dynamic>> records = await db.rawQuery(
        'SELECT a.* FROM tb_playdata b left join tb_acticle a on b.articleId=a.tbId and b.flag=? order by b.seat desc,b.tbId desc;)',
        [flag]);
    List<ArticleModel> list = [];
    if (records.length > 0) {
      list = records.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<int> clearPlayDataList() async {
    return await db.delete(tablePlayData, where: '1=1');
  }

  Future close() async => db.close();
}
