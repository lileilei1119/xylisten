/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
final String tableArticle = 'tb_acticle';

final String tbId = 'tbId';
final String ids = 'ids';
final String title = 'title';
final String content = 'content';
final String userId = 'userId';
final String tagId = 'tagId';
final String url = 'url';
final String count = 'count';
final String flag = 'flag';
final String opt = 'opt';
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
  //1:表示已经人工设置了标题
  int flag;
  //0:默认状态 1：回收站
  int opt;
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
      this.flag = 0,
      this.opt = 0,
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
        flag = json['flag'],
        opt = json['opt'],
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
        'flag': flag,
        'opt': opt,
        'createDate': createDate,
        'tagId': tagId,
      };
}
