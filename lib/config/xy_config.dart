import 'package:shared_preferences/shared_preferences.dart';
import 'package:xylisten/listen/model/article_model.dart';

class Constant {
   static const String dark_mode = "dark_mode";
   static const String eb_dark_mode = "eb_dark_mode";
   static const String eb_add_link = "eb_add_link";
   static const String eb_home_list_refresh = "eb_home_list_refresh";
   static const String eb_player_show = "eb_player_show";
//   static const String eb_refresh_player_list = "eb_refresh_player_list";
   static const String eb_timer_countdown = "eb_timer_countdown";

   static const String eb_play_status = "eb_play_status";
   static const String play_status_playing = "play_status_playing";
   static const String play_status_pause = "play_status_pause";
   static const String play_status_continue = "play_status_continue";
   static const String play_status_stop = "play_status_stop";

   static const String sp_play_list = "sp_play_list";

   static bool isDarkMode = false;

   /// database
   static const String xy_db_name = "xyListenDB.db";
   static const int xy_db_version = 1;

}

class PlayData{
   static List<ArticleModel> playList = [];
   static int playIdx = 0;
   static ArticleModel curModel;

}