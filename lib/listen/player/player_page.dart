import 'package:flutter/material.dart';
import 'package:xylisten/listen/home/acticle_model.dart';
import 'package:xylisten/listen/home/article_item.dart';
import 'package:xylisten/listen/player/player_control_view.dart';

class PlayerPage extends StatefulWidget {
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {

  List<ArticleModel> _acticleList = [
  ArticleModel(title: '好好学习',content: '天天向上'),
  ArticleModel(title: '好好学习',content: 'c2'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('287|微软如何自救'),
        elevation: 0,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              PlayerControlView.showPlayer(context,true);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(icon: Icon(Icons.timer,size: 30),),
                  IconButton(icon: Icon(Icons.skip_previous,size: 30)),
                  IconButton(
                    padding:EdgeInsets.zero,
                    icon: Icon(
                      PlayerControlView.isPlaying?Icons.pause_circle_outline:Icons.play_circle_outline,
                      color: Theme.of(context).primaryColor,
                      size: 48,
                    ),
                    onPressed: (){
                      setState(() {
                        PlayerControlView.isPlaying = !PlayerControlView.isPlaying;
                      });
                    },
                  ),
                  IconButton(icon: Icon(Icons.skip_next,size: 30),),
                  IconButton(icon: Icon(Icons.description,size: 30),),
                ],
              ),
            ),
            Divider(),
            Expanded(child: ListView.builder(itemBuilder: (BuildContext context,int index){
              return ArticleItem(_acticleList[index]);
            },
              itemExtent: 80.0,
              itemCount: _acticleList.length,
            ))
          ],
        ),
      ),
    );
  }
}
