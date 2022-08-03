import 'package:chewie/chewie.dart';
import 'package:decideitfinal/CommunityQuestions/CommunityQuestion.dart';
import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';

class DraftQuestionCard extends StatefulWidget {
  var questiontext,
      questionid,
      imageurl,
      fileextension,
      communitynames,
      communityids,
      postedtime;

  DraftQuestionCard(
      this.questiontext,
      this.questionid,
      this.imageurl,
      this.fileextension,
      this.communitynames,
      this.communityids,
      this.postedtime);

  @override
  State<DraftQuestionCard> createState() => _DraftQuestionCardState();
}

class _DraftQuestionCardState extends State<DraftQuestionCard> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  late List<String> providedvideoextensions = [];
  late List<String> providedimageextensions = [];
  ChewieController? chewieController;

  @override
  void initState() {
    // TODO: implement initState
    getuserdata();
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    if (_controller != null) {
      _controller!.dispose();
    }
    if (chewieController != null) {
      chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('questionid', widget.questionid);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => PostQuestion()));
      },
      child: Card(
        color: Colors.white.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('questionid', widget.questionid);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => PostQuestion()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.questiontext,
                  style: TextStyle(
                      color: kBluePrimaryColor,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            widget.imageurl.isEmpty
                ? const SizedBox()
                : providedimageextensions.contains(widget.fileextension)
                    ? InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('questionid', widget.questionid);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => PostQuestion()));
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              '${imageapiurl + '/question/' + widget.questionid}/' +
                                  widget.imageurl,
                              fit: BoxFit.cover,
                              //height: MediaQuery.of(context).size.height * 0.1,
                              //width: MediaQuery.of(context).size.width * 0.9
                            ),
                          ),
                        ),
                      )
                    : chewieController != null
                        ? Container(
                            height: 240,
                            child: Chewie(
                              controller: chewieController!,
                            ),
                          )
                        : Container(),

            //               ),FutureBuilder(
            //   future: _initializeVideoPlayerFuture,
            //   builder: (context, snapshot) {
            //     print(snapshot.connectionState);
            //     if (snapshot.connectionState ==
            //         ConnectionState.done) {
            //       // If the VideoPlayerController has finished initialization, use
            //       // the data it provides to limit the aspect ratio of the video.
            //       return InkWell(
            //         onTap: () async {
            //           SharedPreferences prefs =
            //               await SharedPreferences.getInstance();
            //           prefs.setString(
            //               'questionid', widget.questionid);
            //           Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => PostQuestion()));
            //         },
            //         child: AspectRatio(
            //           aspectRatio: _controller!.value.aspectRatio,
            //           // Use the VideoPlayer widget to display the video.
            //           child: GestureDetector(
            //               child: Stack(
            //             alignment: Alignment.bottomCenter,
            //             children: [
            //               Chewie(
            //                 controller: chewieController,

            //               ),
            //               //VideoPlayer(_controller!),
            //             ],
            //           )),
            //         ),
            //       );
            //     } else {
            //       // If the VideoPlayerController is still initializing, show a
            //       // loading spinner.
            //       return const Center(
            //           child: CircularProgressIndicator());
            //     }
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      widget.communitynames[0] == "Private"
                          ? const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            )
                          : Image.asset(
                              'images/Community.png',
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                      const SizedBox(
                        width: 3,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.02,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.communitynames.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  print(widget.communityids);
                                  print(widget.communitynames);
                                  if (widget.communitynames[index] !=
                                      "Private") {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CommunityQuestion(widget
                                                    .communityids[index])));
                                  } else {
                                    print('Private');
                                  }
                                },
                                child: Text(widget.communitynames[index],
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.039)),
                              );
                            }),
                      )
                    ],
                  ),
                  Wrap(
                    spacing: 5.0,
                    direction: Axis.horizontal,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Saved: ',
                          style: TextStyle(
                              color: kBluePrimaryColor,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035),
                          children: <TextSpan>[
                            TextSpan(
                                text: widget.postedtime,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    providedimageextensions = prefs.getStringList('imageextensions') ?? [];
    providedvideoextensions = prefs.getStringList('videoextensions') ?? [];
    print(widget.questiontext);

    print(widget.fileextension);
    print(providedvideoextensions);
    if (providedvideoextensions.contains(widget.fileextension)) {
      _controller = VideoPlayerController.network(
        '$imageapiurl/question/' + widget.questionid + '/' + widget.imageurl,
      );
      print(widget.questiontext);
      print(widget.questionid);
      print(widget.imageurl);
      print(
          '$imageapiurl/question/' + widget.questionid + '/' + widget.imageurl);

      // Initialize the controller and store the Future for later use.
      // _initializeVideoPlayerFuture = _controller!.initialize();

      await Future.wait([_controller!.initialize()]);
      // Use the controller to loop the video.
      _controller!.setLooping(true);

      chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: false,
        looping: true,
      );
    }
    setState(() {});
  }
}
