import 'package:flutter/material.dart';
import 'package:xylisten/listen/player/player_page.dart';
import 'package:xylisten/platform/res/styles.dart';

class LitePlayerView extends StatefulWidget {
  @override
  _LitePlayerViewState createState() => _LitePlayerViewState();
}

class _LitePlayerViewState extends State<LitePlayerView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: new Material(
          child: new Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: new Card(
              elevation: 10,
              child: InkWell(
                onTap: (){
                  print('object======');
                  PlayerControlView.showPlayer(context,false);
                },
                child: new Padding(
                  padding: EdgeInsets.only(left: 8,top: 8,right: 8,bottom: 0),
                  child: Container(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '287|微软如何自救',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                Text(
                                  '11:58 邵恒头条',
                                  style: TextStyles.listContent,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              PlayerControlView.isPlaying?Icons.pause_circle_outline:Icons.play_circle_outline,
                                color: Theme.of(context).accentColor,
                                size: 30,
                            ),
                            onPressed: (){
                              setState(() {
                                PlayerControlView.isPlaying = !PlayerControlView.isPlaying;
                              });
                            },
                          ),

                          IconButton(
                            icon: Icon(Icons.close,color: Colors.grey),
                            onPressed: (){
                              PlayerControlView.hide();
                            },
                          )
                        ],
                      ),
                      LinearProgressIndicator(
                        backgroundColor: Theme.of(context).canvasColor,
                        minHeight: 1,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                        value: 0.2,
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}


class PlayerControlView {
  static OverlayEntry overlayEntry;

  static bool isPlaying = false;

  static void hide() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  static void showPlayer(BuildContext context,bool isLiteMode){
    hide();
    if (overlayEntry == null) {
      overlayEntry = new OverlayEntry(builder: (context) {
        return isLiteMode?LitePlayerView():PlayerPage();
      });
      Overlay.of(context).insert(overlayEntry);
    }
  }

}
