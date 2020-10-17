import 'package:shared_preferences/shared_preferences.dart';
import 'package:xylisten/config/xy_config.dart';

 class CommonUtils{
   static Future<bool> getDarkMode() async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     return prefs.getBool(Constant.dark_mode);
   }

   static changeDarkMode() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setBool(Constant.dark_mode, !prefs.getBool(Constant.dark_mode));
   }

   static sec2Str(int sec){
     if(sec<=0){
       return "";
     }
     int hour = sec~/3600;
     int min = (sec~/60)%60;
     if(hour>0){
       return "$hour".padLeft(2, '0')+":"+"$min".padLeft(2, '0');
     }
     int ss = sec%60;
      return "$min".padLeft(2, '0')+":"+"$ss".padLeft(2, '0');
   }
 }