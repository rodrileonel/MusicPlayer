import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/src/helpers/helpers.dart';
import 'package:musicplayer/src/models/playing_model.dart';
import 'package:musicplayer/src/widgets/customappbar.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayingModel(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height*0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(30)),
                gradient:LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.center,
                  colors: [
                    Color(0xff33333E),
                    Color(0xff201E28),
                  ]
                )
              ),
            ),
            Column(
              children:[
                CustomAppBar(),
                _MusicPlayer(),
                _SongTitle(),
                Expanded(child: _Lyrics()),
              ]
            ),
          ],
        )
      ),
    );
  }
}

class _Lyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    child: ListWheelScrollView(
      physics: BouncingScrollPhysics(),
      itemExtent: 42, 
      diameterRatio: 1.5,
      children: getLyrics().map(
        (e) => Text('$e',style: TextStyle(fontSize: 20,color: Colors.white.withOpacity(0.7)),)
      ).toList()
    ),
  );
}

class _SongTitle extends StatefulWidget {

  @override
  __SongTitleState createState() => __SongTitleState();
}

class __SongTitleState extends State<_SongTitle> with SingleTickerProviderStateMixin{

  AnimationController playAnimation;
  final audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds:500),
    );
    super.initState();
  }

  @override
  void dispose() {
    this.playAnimation.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    bool firstTime = true;
    
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Feeling Good',style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 30),),
              Text('-Nina Simone-',style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 20),),
            ],
          ),
          Spacer(),
          FloatingActionButton(
            backgroundColor: Colors.amber, 
            child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: this.playAnimation,
            ), 
            onPressed: (){
              if(firstTime){
                audioPlayer.open(Audio('assets/Nina-Simone-Feeling-Good.mp3'));
                audioPlayer.currentPosition.listen((duration) { //duracion actual
                  Provider.of<PlayingModel>(context,listen: false).currentDuration = duration;
                  //print('${duration.toString().split('.')[0].substring(1)}');
                });
                audioPlayer.current.listen((playing) { //dutracion total
                  Provider.of<PlayingModel>(context,listen: false).songDuration = playing.audio.duration;
                });
                firstTime=false;
              }
              audioPlayer.playOrPause();
              if(Provider.of<PlayingModel>(context,listen: false).playing){
                playAnimation.reverse();
                Provider.of<PlayingModel>(context,listen: false).playing = false;
              }else{
                playAnimation.forward();
                Provider.of<PlayingModel>(context,listen: false).playing =true;
              }
            },
          )
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _Disco(),
      _ProgressBar()
    ],
  );

}

class _ProgressBar extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final music = Provider.of<PlayingModel>(context);
    return Container(
      child: Column(
        children: [
          Text('${music.songDuration.toString().split('.')[0].substring(2)}',style: TextStyle(color: Colors.white.withOpacity(0.4)),),
          SizedBox(height:15),
          Stack(
            children:[
              Container(
                width: 3,
                height: 200,
                color: Color(0xff484750),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: (music.currentDuration == music.songDuration)
                    ?0:(music.currentDuration.inMilliseconds*200)/music.songDuration.inMilliseconds,
                  color: Colors.white,
                ),
              )
            ]
          ),
          SizedBox(height:15),
          Text('${music.currentDuration.toString().split('.')[0].substring(2)}',style: TextStyle(color: Colors.white.withOpacity(0.4)),),
        ],
      ),
    );
  }
}

class _Disco extends StatefulWidget {
  @override
  __DiscoState createState() => __DiscoState();
}

class __DiscoState extends State<_Disco> with SingleTickerProviderStateMixin{

  AnimationController rotateDisk;
  Animation<double> rotate;
  bool playing = false;

  @override
  void initState() {
    rotateDisk = AnimationController(
      vsync: this,
      duration: Duration(seconds:10)
    );
    rotate = Tween(begin: 0.0,end: 2.0 * pi).animate(rotateDisk);
    Provider.of<PlayingModel>(context,listen: false).addListener(() {
      (Provider.of<PlayingModel>(context,listen: false).playing) ? rotateDisk.repeat():rotateDisk.stop();
    });
    super.initState();
  }

  @override
  void dispose() {
    this.rotateDisk.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //(Provider.of<PlayingModel>(context,listen: false).playing==false) ? rotateDisk.repeat():rotateDisk.stop();
    return Container(
      padding: EdgeInsets.all(15),
      width: 250,
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(250),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: rotateDisk,
              child: Image(image: AssetImage('assets/nina-simone.jpg'),),
              builder: (BuildContext context, Widget child) {
                return Transform.rotate(angle: rotate.value,child: child,);
              },
            ),
            Container(
              padding: EdgeInsets.all(4),
              width:25,
              height:25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(color:Colors.black),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff484750),
              ),
            )
          ],
        )
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(250),
        gradient:LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1e1c24)
          ]
        )
      ),
    );
  }
}