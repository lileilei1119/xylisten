/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
final String tablePlayData = 'tb_playdata';

final String pd_tbId = 'tbId';
final String pd_articleId = 'articleId';
final String pd_tagId = 'tagId';
final String pd_flag = 'flag';
final String pd_seat = 'seat';


class PlayDataModel {
  //关联article id
  int articleId;
  int tbId;
  String tagId;
  //0:未播放 1：已播放
  int flag;
  int seat;

  PlayDataModel(
      {
        this.articleId,
        this.tbId,
        this.tagId,
        this.flag = 0,
        this.seat = 0,
        });

  PlayDataModel.fromJson(Map<String, dynamic> json)
      :tbId = json['tbId'],
        articleId = json['articleId'],
        flag = json['flag'],
        tagId = json['tagId'],
        seat = json['seat'];

  Map<String, dynamic> toJson() => {
    'tbId': tbId,
    'articleId': articleId,
    'flag': flag,
    'tagId': tagId,
    'seat': seat,
  };

}
