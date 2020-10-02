import 'package:flutter/cupertino.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NavigatorUtil {
  static void pushPage(
    BuildContext context,
    Widget page, {
    String pageName,
    bool needLogin = false,
  }) {
    if (context == null || page == null) return;
    // if (needLogin && !Util.isLogin()) {
    //   pushPage(context, LoginPage());
    //   return;
    // }
    Navigator.push(
        context, new CupertinoPageRoute<void>(builder: (ctx) => page));
  }

  static void pushReplacement(
      BuildContext context,
      Widget page,
      {
        String pageName,
        bool needLogin = false,
      }) {
    if (context == null || page == null) return;
    // if (needLogin && !Util.isLogin()) {
    //   pushPage(context, LoginPage());
    //   return;
    // }
    Navigator.pushReplacement(context, new CupertinoPageRoute<void>(builder: (ctx) => page));
  }

   static void pushWeb(BuildContext context,
       {String title, String titleId, String url, bool isHome: false}) {
     if (context == null || url.isEmpty) return;
     if (url.endsWith(".apk")) {
//       launchInBrowser(url, title: title ?? titleId);
     } else {
       Navigator.push(
           context,
           new CupertinoPageRoute<void>(
               builder: (ctx) =>
               new WebviewScaffold(url: url)));
     }
   }

//   static Future<Null> launchInBrowser(String url, {String title}) async {
//     if (await canLaunch(url)) {
//       await launch(url, forceSafariVC: false, forceWebView: false);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
}
