/*
 * @Author: xikan
 * @Email: lileilei1119@foxmail.com
 */
import 'package:flutter/material.dart';
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
              color: Colors.lightBlueAccent,
            ),
            margin: EdgeInsets.only(bottom: 8.0),
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Center(
              child: SizedBox(
                width: 60.0,
                height: 60.0,
                child: CircleAvatar(
                  child: Text('R'),
                ),
              ),
            ),
          ),
          ListTile(
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
                  eventBus.fire(Constant.eb_dark_mode);
                },
              )
          ),
          Divider(), //分割线
          ListTile(
            leading: Icon(Icons.close),
            title: Text('关闭'),
            onTap: () => Navigator.pop(context), // 关闭抽屉
          )
        ],
      ),
    );
  }

}