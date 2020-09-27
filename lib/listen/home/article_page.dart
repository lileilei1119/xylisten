import 'package:flutter/material.dart';
import 'package:xy_tts/xy_tts.dart';
import 'package:xylisten/listen/home/acticle_model.dart';
import 'package:xylisten/platform/res/styles.dart';

class ArticlePage extends StatefulWidget {
  final ArticleModel model;

  const ArticlePage({Key key, this.model}) : super(key: key);
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.title),
        actions: [
          IconButton(
            icon: Icon(Icons.headset),
            onPressed: ()=>XyTts.startTTS(widget.model.content),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(8),
              child:
                  Text(widget.model.content, style: TextStyles.listContent))),
    );
  }
}
