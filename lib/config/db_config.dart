import 'package:sqflite/sqflite.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:xylisten/listen/home/article_model.dart';

Database db;

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
  $createDate text,
  $tagId text
  )
''');
    });
  }

  Future<ArticleModel> insert(ArticleModel article) async {
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

  Future<List<ArticleModel>> getArticleList() async {
    List<Map<String, dynamic>> records =
        await db.rawQuery('SELECT * FROM $tableArticle order by $tbId desc ');
    List<ArticleModel> list = [];
    if (records.length > 0) {
      list = records.map((value) {
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<int> delete(int id) async {
    return await db.delete(tableArticle, where: '$tbId = ?', whereArgs: [id]);
  }

  Future<int> update(ArticleModel article) async {
    return await db.update(tableArticle, article.toJson(),
        where: '$tbId = ?', whereArgs: [article.tbId]);
  }

  Future close() async => db.close();
}
