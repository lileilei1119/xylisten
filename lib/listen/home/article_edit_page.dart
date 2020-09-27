import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:xylisten/config/xy_config.dart';
import 'package:zefyr/zefyr.dart';
import 'images.dart';

class ArticleEditPage extends StatefulWidget {
  @override
  _ArticleEditPageState createState() => _ArticleEditPageState();
}

Delta getDelta() {
  return Delta.fromJson(json.decode(doc) as List);
}

final doc =
    r'[{"insert":"Zefyr"},{"insert":"\n\n\n"}]';

class _ArticleEditPageState extends State<ArticleEditPage> {
  final ZefyrController _controller =
  ZefyrController(NotusDocument.fromDelta(getDelta()));
  final FocusNode _focusNode = FocusNode();
  bool _editing = false;
  StreamSubscription<NotusChange> _sub;

  @override
  void initState() {
    super.initState();
    _sub = _controller.document.changes.listen((change) {
      print('${change.source}: ${change.change}');
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = _editing
        ? IconButton(onPressed: _stopEditing, icon: Icon(Icons.save))
        : IconButton(onPressed: _startEditing, icon: Icon(Icons.edit));
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('新建文章'),
        actions: [
          done,
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          controller: _controller,
          focusNode: _focusNode,
          mode: _editing ? ZefyrMode.edit : ZefyrMode.select,
          imageDelegate: CustomImageDelegate(),
          keyboardAppearance: Constant.isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _editing = true;
    });
  }

  void _stopEditing() {
    setState(() {
      _editing = false;
    });
  }
}

