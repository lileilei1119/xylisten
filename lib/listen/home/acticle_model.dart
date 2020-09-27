/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
class ArticleModel {
  String createTime;
  String ids;
  String title;
  String content;
  String userId;
  String tagId;
  String url;

  ArticleModel(
      {this.createTime,
        this.title,
        this.ids,
        this.content,
        this.tagId,
        this.userId,
        this.url});

}
