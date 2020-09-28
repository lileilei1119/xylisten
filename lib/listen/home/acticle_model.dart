/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:xylisten/platform/xy_index.dart';

final String tableArticle = 'tb_acticle';

final String tbId = 'tbId';
final String ids = 'ids';
final String title = 'title';
final String content = 'content';
final String userId = 'userId';
final String tagId = 'tagId';
final String url = 'url';
final String count = 'count';
final String category = 'category';
final String createDate = 'createDate';

enum EArticleType {
  txt,
  url,
}

class ArticleModel {
  int tbId;
  String ids;
  String title;
  String content;
  String userId;
  String tagId;
  String url;
  int count;
  EArticleType category;
  String createDate;

  ArticleModel(
      {this.tbId,
      this.title,
      this.ids,
      this.content,
      this.tagId,
      this.userId,
      this.count = 0,
      this.category = EArticleType.txt,
      this.url,
      this.createDate});

  String getCategoryStr() {
    String result;
    switch (this.category) {
      case EArticleType.txt:
        result = '文本';
        break;
      case EArticleType.url:
        result = '链接';
        break;

      default:
    }
    return result;
  }

  ArticleModel.fromJson(Map<String, dynamic> json)
      : ids = json['ids'],
        tbId = json['tbId'],
        title = json['title'],
        url = json['url'],
        content = json['content'],
        category = EArticleType.values[json['category']],
        userId = json['userId'],
        count = json['count'],
        createDate = json['createDate'],
        tagId = json['tagId'];

  Map<String, dynamic> toJson() => {
        'ids': ids,
        'tbId': tbId,
        'title': title,
        'url': url,
        'content': content,
        'category': category.index,
        'userId': userId,
        'count': count,
        'createDate': createDate,
        'tagId': tagId,
      };
}

class ArticleModelProvider {
  Database db;

  Future open() async {
    db = await openDatabase(Constant.xy_db_name, version: Constant.xy_db_version,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableArticle ( 
  $tbId integer primary key autoincrement, 
  $ids text,
  $title text not null,
  $url text,
  $content text not null,
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
    List<Map<String, dynamic>> records = await db.rawQuery('SELECT * FROM $tableArticle');
    List<ArticleModel> list;
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
