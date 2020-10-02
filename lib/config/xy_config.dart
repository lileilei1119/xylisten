import 'package:xylisten/listen/home/article_model.dart';

class Constant {
   static const String dark_mode = "dark_mode";
   static const String eb_dark_mode = "eb_dark_mode";
   static const String eb_add_link = "eb_add_link";
   static const String eb_home_list_refresh = "eb_home_list_refresh";

   static const String eb_play_status = "eb_play_status";
   static const String play_status_playing = "play_status_playing";
   static const String play_status_pause = "play_status_pause";
   static const String play_status_continue = "play_status_continue";
   static const String play_status_stop = "play_status_stop";

   static bool isDarkMode = false;

   /// database
   static const String xy_db_name = "xyListenDB.db";
   static const int xy_db_version = 1;

}

class PlayData{
   static List<ArticleModel> playList = [];
   static int playIdx;
   static ArticleModel curModel;
}