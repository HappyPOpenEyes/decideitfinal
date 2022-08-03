import 'dart:async';

// // import 'package:decideitfinal/Registration/constants.dart';
// import 'package:decideitfinal/SplashScreens/splashscreen.dart';
import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'VideoItems.dart';

class VideoPlayerApp extends StatefulWidget {
  @override
  _VideoPlayerAppState createState() => _VideoPlayerAppState();
}

class _VideoPlayerAppState extends State<VideoPlayerApp> {
  //YoutubePlayerController _controller;
  AppBar appbar = AppBar();
  @override
  void initState() {
    // _controller = YoutubePlayerController(
    //   initialVideoId: YoutubePlayer.convertUrlToId(
    //       "https://www.youtube.com/embed/htgn_nKiQFE"),
    //   flags: YoutubePlayerFlags(
    //     autoPlay: false,
    //     mute: false,
    //     disableDragSeek: false,
    //     loop: false,
    //     isLive: false,
    //     forceHD: false,
    //   ),
    // );
    super.initState();
    // Transparent status bar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: SizedBox(
            height: appbar.preferredSize.height * 0.8,
            child: Image.asset('logos/DI_Logo.png')),
        centerTitle: true,
        backgroundColor: Colors.blue,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: RichText(
                text: TextSpan(
                  text: 'About ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.066,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Decide',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.066,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: 'It',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.066,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  'DecideIt is a free, fast, and easy “decision engine” that provides quick feedback to your questions and comments.  Our approach is fresh, and DecideIt delivers Q&A for private groups (now) and public forums (Winter 2021).  DecideIt allows you to quickly launch any question and view the results graphically without cramming your inbox with emails or sifting through a ton of IM’s.  DecideIt simplifies your life by removing the clutter and getting you clear feedback.'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Container(
                  decoration: new BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(15.0), child: Container()
                      // YoutubePlayer(
                      //   controller: _controller,
                      //   showVideoProgressIndicator: true,
                      // ),
                      ),
                ),
              ),
            ),

            /*ChewieListItem(
              videoPlayerController: VideoPlayerController.network(
                'https://www.youtube.com/embed/htgn_nKiQFE',
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
