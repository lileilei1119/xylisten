/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
 export 'package:event_bus/event_bus.dart';
 export 'package:bot_toast/bot_toast.dart';
 export  'package:bot_toast/bot_toast.dart';
 export 'package:xylisten/platform/res/colors.dart';
 export 'package:xylisten/config/xy_config.dart';
 export 'package:sqflite/sqflite.dart';

 import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';

 EventBus eventBus = EventBus();

 class NotifyEvent{
   String route;
   List argList;

   NotifyEvent({@required this.route, this.argList});

 }