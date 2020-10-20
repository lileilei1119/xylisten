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
    playData.tbId = await db.insert(tablePlayData, playData.toJson());
    return playData;
  }

  Future<int> deletePlayDataByArticleId(int id) async {
    return await db.delete(tablePlayData, where: '$pd_articleId = ?', whereArgs: [id]);
  }

  Future<List<ArticleModel>> getPlayDataList({int flag = 0}) async {
    List<Map<String, dynamic>> records = await db.rawQuery(
        'SELECT * FROM $tableArticle where $opt!=1 and $tbId in (SELECT $pd_articleId FROM $tablePlayData where $pd_flag=? order by $pd_seat desc)',
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
