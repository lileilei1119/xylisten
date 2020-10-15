/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
import 'package:xy_tts/xy_tts.dart';
import 'package:xylisten/platform/res/index.dart';
import 'package:xylisten/platform/xy_index.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool _isDarkMode = false;
  @override
  void initState() {
    _isDarkMode = Constant.isDarkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
            ),
            margin: EdgeInsets.only(bottom: 8.0),
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Container(
            ),
          ),
          ListTile(
          dense:true,
            leading: Icon(Icons.av_timer),
            title: Text('播报语速'),
            trailing: Container(
                width: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${XyTts.rate}',
                      style: TextStyles.listContent2,
                    ),
                    Icon(
                      Icons.navigate_next,
                    ),
                  ],
                )),
            onTap: (){
              _openModal4TTS(context).whenComplete((){
                setState(() {

                });
              });
            },
          ),
          Divider(),
          ListTile(
              dense:true,
            leading: Icon(Icons.brightness_6),
            title: Text('暗黑模式'),
              trailing:Switch(
                value: _isDarkMode,
                activeColor: Theme.of(context).primaryColor,     // 激活时原点颜色
                onChanged: (bool val) {
                  this.setState(() {
                    _isDarkMode = val;
                  });
                  Constant.isDarkMode = _isDarkMode;
                  eventBus.fire(NotifyEvent(route: Constant.eb_dark_mode));
                },
              )
          ),
          Divider(), //分割线
        ],
      ),
    );
  }

  Future _openModal4TTS(BuildContext context) async {

    _buildItem(double value){
      return ListTile(
        title: Text('$value倍速'+(value==1?"(默认)":""), textAlign: TextAlign.center),
        onTap: (){
          XyTts.rate = value;
          Navigator.pop(context);
        },
      );
    }

    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300.0,
            child: Column(
              children: <Widget>[
                _buildItem(0.5),
                Divider(
                  height: 1,
                ),
                _buildItem(1),
                Divider(
                  height: 1,
                ),
                _buildItem(2),
                Divider(
                  height: 1,
                ),
                _buildItem(3),
              ],
            ),
          );
        });
  }

}