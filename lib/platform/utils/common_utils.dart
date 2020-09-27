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
 }