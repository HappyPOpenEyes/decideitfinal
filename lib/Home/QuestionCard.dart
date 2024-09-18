// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/QuestionDetail/QuestionDetail.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

import '../Community/CommunityListApiResponse.dart';
import '../CommunityQuestions/CommunityQuestion.dart';
import '../ProfileScreens/PersonalProfile.dart';
import '../PublicProfile/DIStarProfile.dart';

class QuestionCard extends StatefulWidget {
  var questiontext,
      imageurl,
      username,
      communityname,
      postedtime,
      expiredtitle,
      expiredtime,
      views,
      comment,
      questionimageurl,
      fileextension,
      id,
      communityid,
      likescount,
      isreported,
      reportedname,
      header,
      name,
      questionuserid,
      isliked,
      sourceoption,
      searchword;

  QuestionCard(
      this.questiontext,
      this.imageurl,
      this.username,
      this.communityname,
      this.postedtime,
      this.expiredtitle,
      this.expiredtime,
      this.views,
      this.comment,
      this.questionimageurl,
      this.fileextension,
      this.id,
      this.communityid,
      this.likescount,
      this.isliked,
      this.isreported,
      this.reportedname,
      this.header,
      this.name,
      this.questionuserid,
      this.sourceoption,
      this.searchword);

  @override
  _QuestionCardState createState() => _QuestionCardState(
      questiontext,
      imageurl,
      username,
      communityname,
      postedtime,
      expiredtitle,
      expiredtime,
      views,
      comment,
      questionimageurl,
      fileextension,
      id,
      communityid,
      likescount,
      isliked,
      isreported,
      reportedname,
      header,
      name,
      questionuserid,
      sourceoption,
      searchword);
}

class _QuestionCardState extends State<QuestionCard> {
  late var questiontext,
      imageurl,
      username,
      communityname,
      postedtime,
      expiredtitle,
      expiredtime,
      views,
      comment,
      questionimageurl,
      fileextension,
      id,
      communityid,
      likescount,
      header,
      name,
      userid,
      questionuserid,
      isliked,
      isreported,
      reportedname,
      sourceoption,
      searchword;
  TextEditingController reportcommentcontroller = TextEditingController();
  var commentvalue = "";
  bool _isInAsyncCall = false;
  late File file;
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  late List<String> providedvideoextensions = [];
  late List<String> providedimageextensions = [];
  static const platform = MethodChannel("com.openeyes.decideitfinal");
  ChewieController? chewieController;

  _QuestionCardState(
      this.questiontext,
      this.imageurl,
      this.username,
      this.communityname,
      this.postedtime,
      this.expiredtitle,
      this.expiredtime,
      this.views,
      this.comment,
      this.questionimageurl,
      this.fileextension,
      this.id,
      this.communityid,
      this.likescount,
      this.isliked,
      this.isreported,
      this.reportedname,
      this.header,
      this.name,
      this.questionuserid,
      this.sourceoption,
      this.searchword);

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
    return ModalProgressHUD(
      inAsyncCall: _isInAsyncCall,
      // demo of some additional parameters
      opacity: 0.5,
      progressIndicator: const CircularProgressIndicator(),
      child: InkWell(
        onTap: naviagte,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: naviagte,
                  child: Text(
                    questiontext,
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
              questionimageurl == null
                  ? const SizedBox(
                      height: 0,
                    )
                  : providedimageextensions.contains(fileextension)
                      ? InkWell(
                          onTap: naviagte,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                '${imageapiurl + '/question/' + id}/' +
                                    questionimageurl,
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
              // FutureBuilder(
              //     future: _initializeVideoPlayerFuture,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState ==
              //           ConnectionState.done) {
              //         // If the VideoPlayerController has finished initialization, use
              //         // the data it provides to limit the aspect ratio of the video.
              //         return InkWell(
              //           onTap: naviagte,
              //           child: AspectRatio(
              //             aspectRatio: _controller!.value.aspectRatio,
              //             // Use the VideoPlayer widget to display the video.
              //             child: GestureDetector(
              //                 child: Stack(
              //               alignment: Alignment.bottomCenter,
              //               children: [
              //                 VideoPlayer(_controller!),
              //                 const SizedBox(
              //                   height: 40,
              //                 ),
              //                 VideoProgressIndicator(
              //                   _controller!,
              //                   allowScrubbing: true,
              //                   padding: const EdgeInsets.all(3),
              //                   colors: VideoProgressColors(
              //                       playedColor:
              //                           Theme.of(context).primaryColor),
              //                 ),
              //                 GestureDetector(
              //                   onTap: () {
              //                     setState(() {
              //                       // If the video is playing, pause it.
              //                       if (_controller!.value.isPlaying) {
              //                         _controller!.pause();
              //                       } else {
              //                         // If the video is paused, play it.
              //                         _controller!.play();
              //                       }
              //                     });
              //                   },
              //                   child: Padding(
              //                     padding:
              //                         const EdgeInsets.only(bottom: 40),
              //                     child: SizedBox(
              //                       height: 40,
              //                       child: Icon(
              //                         _controller!.value.isPlaying
              //                             ? Icons.pause
              //                             : Icons.play_arrow,
              //                         size: 40,
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ],
              //             )),
              //           ),
              //         );
              //       } else {
              //         // If the VideoPlayerController is still initializing, show a
              //         // loading spinner.
              //         return const Center(
              //             child: CircularProgressIndicator());
              //       }
              //     },
              //   ),
              Wrap(
                //crossAxisAlignment: WrapCrossAlignment.center,
                //direction: Axis.horizontal,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.12,
                    width: MediaQuery.of(context).size.width * 0.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 25,
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                            shape: const CircleBorder(),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: showProfileImage(),
                              //
                            )),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (userid == questionuserid) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => PersonalProfile()));
                            } else {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              List<String> searchlist = [];
                              List<String> sourcelist = [];
                              var sharedsearchlist =
                                  prefs.getStringList('searchword');
                              var sharedsourcelist =
                                  prefs.getStringList('communitysource');
                              print('Coming from question card');
                              print(searchlist);
                              print(questionuserid);
                              if (sharedsourcelist != null) {
                                sourcelist = sharedsourcelist;
                                searchlist = sharedsearchlist!;
                              }
                              searchlist.add(questionuserid);
                              sourcelist.add(sourceoption.toString());

                              prefs.setStringList(
                                  'communitysource', sourcelist);
                              prefs.setStringList('searchword', searchlist);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      DIStarProfile(questionuserid,1)));
                            }
                          },
                          child: Text(
                            username,
                            style: TextStyle(
                              color: kBluePrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                            ),
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            communityname[0] == "Private"
                                ? const Icon(Icons.lock)
                                : Image.asset(
                                    'images/Community.png',
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                            const SizedBox(
                              width: 3,
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.68,
                                  height: MediaQuery.of(context).size.height *
                                      0.026,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: communityname.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            if (communityname[index] !=
                                                "Private") {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              List<String> searchlist = [];

                                              List<String> sourcelist = [];
                                              var sharedsearchlist = prefs
                                                  .getStringList('searchword');
                                              var sharedsourcelist =
                                                  prefs.getStringList(
                                                      'communitysource');
                                              print(
                                                  'Coming from question card');
                                              print(searchlist);
                                              print(communityid[index]);
                                              if (sharedsourcelist != null) {
                                                sourcelist = sharedsourcelist;
                                                searchlist = sharedsearchlist!;
                                              }
                                              searchlist
                                                  .add(communityid[index]);
                                              sourcelist
                                                  .add(sourceoption.toString());
                                              print('Source List items');
                                              print(sourcelist);
                                              prefs.setStringList(
                                                  'communitysource',
                                                  sourcelist);
                                              prefs.setStringList(
                                                  'searchword', searchlist);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommunityQuestion(
                                                              communityid[
                                                                  index])));
                                            } else {
                                              print('Private');
                                            }
                                          },
                                          child: Wrap(
                                            children: [
                                              Text(communityname[index],
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.039)),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                spacing: 5.0,
                direction: Axis.horizontal,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Posted: ',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.035),
                      children: <TextSpan>[
                        TextSpan(
                            text: postedtime,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: expiredtitle,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: MediaQuery.of(context).size.width * 0.035),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' ' + expiredtime,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        var body;
                        if (userid == null) {
                          SharedPreferences userprefs =
                              await SharedPreferences.getInstance();
                          userprefs.setString('ReportQuestion', 'Please login');
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        } else {
                          if (isliked.isEmpty) {
                            body = {"question_id": id, "is_like": 1};
                          } else {
                            body = {"question_id": id, "is_like": 0};
                          }
                        }

                        print(body);

                        var response = await http.post(
                            Uri.parse('$apiurl/questionDetail/likeQuestion'),
                            body: json.encode(body),
                            headers: {
                              "Content-Type": "application/json",
                              "Authorization": header
                            },
                            encoding: Encoding.getByName("utf-8"));

                        if (response.statusCode == 200) {
                          print(response.body);
                          setState(() {
                            if (isliked.isEmpty) {
                              int temp = int.parse(likescount) + 1;
                              likescount = temp.toString();
                              isliked = "temp";
                            } else {
                              int temp = int.parse(likescount) - 1;
                              likescount = temp.toString();
                              isliked = "";
                            }
                          });
                        } else {
                          print(response.statusCode);
                          print(response.body);
                        }
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            isliked.isEmpty
                                ? Icons.thumb_up_alt_outlined
                                : Icons.thumb_up,
                            size: MediaQuery.of(context).size.width * 0.038,
                            //height: MediaQuery.of(context).size.height * 0.04,
                            //width: MediaQuery.of(context).size.width * 0.04,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(likescount,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.037)),
                        ],
                      ),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          'images/view.png',
                          height: MediaQuery.of(context).size.height * 0.038,
                          width: MediaQuery.of(context).size.width * 0.038,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(views,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.037)),
                      ],
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          'images/comment.png',
                          height: MediaQuery.of(context).size.height * 0.038,
                          width: MediaQuery.of(context).size.width * 0.038,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(comment,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.037)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () async {
                        print('Reported');
                        if (isreported.isEmpty) {
                          print('in if');
                          if (userid == null) {
                            SharedPreferences userprefs =
                                await SharedPreferences.getInstance();
                            userprefs.setString(
                                'ReportQuestion', 'Please login');
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          } else {
                            showreportquestion(context);
                          }
                        }
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset(
                            'images/report.png',
                            height: MediaQuery.of(context).size.height * 0.038,
                            width: MediaQuery.of(context).size.width * 0.038,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(isreported.isEmpty ? 'Report' : 'Reported',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.037)),
                        ],
                      ),
                    ),
                    communityname[0] != "Private"
                        ? GestureDetector(
                            onTap: () async {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              String url =
                                  'https://decideit.com/questionDetails/$id';
                              final quote = questiontext;
                              await FlutterShare.share(
                                  linkUrl: 'Check this out $url',
                                  text: quote,
                                  title: "DecideIt Community");
                            },
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Image.asset(
                                  'images/share.png',
                                  height: MediaQuery.of(context).size.height *
                                      0.038,
                                  width:
                                      MediaQuery.of(context).size.width * 0.038,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text('Share',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.037)),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    GestureDetector(
                      onTap: () async {
                        print(username);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        List<String> searchlist = [];

                        List<String> sourcelist = [];
                        var sharedsearchlist =
                            prefs.getStringList('searchword');
                        var sharedsourcelist =
                            prefs.getStringList('communitysource');
                        print('Coming from question card');
                        print(searchlist);
                        print(id);
                        if (sharedsourcelist != null) {
                          sourcelist = sharedsourcelist;
                          searchlist = sharedsearchlist!;
                        }
                        searchlist.add(id);
                        sourcelist.add(sourceoption.toString());
                        print('Source List items');
                        print(sourcelist);
                        prefs.setStringList('communitysource', sourcelist);
                        prefs.setStringList('searchword', searchlist);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => QuestionDetail(id)));
                      },
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset(
                            'images/reply.png',
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.04,
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text('Reply',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.037)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(Function onTap, String logo) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
          padding: const EdgeInsets.all(8.0),
          height: 60.0,
          width: 60.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: kBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.asset(logo),
          )),
    );
  }

  void reportquestion(BuildContext context) async {
    var body = {
      "question_id": id,
      "postedBy": reportedname,
      "comment": reportcommentcontroller.text
    };
    print(body);

    var response = await http.post(
        Uri.parse('$apiurl/questionDetail/reportQuestion'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      setState(() {
        isreported = true;
      });
      CommunityListResponse communityListResponse =
          communityListResponseFromJson(response.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle("Success", communityListResponse.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  void showreportquestion(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 10.0),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Report Question',
                style: TextStyle(color: kBluePrimaryColor),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                      //focusNode: questiontextfield,
                      controller: reportcommentcontroller,
                      onSaved: (newValue) => commentvalue = newValue!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the comment';
                          //addError(error: kNamelNullError);
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          //labelText: "Name",
                          hintText: 'Enter your Comment',
                          hintStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ))
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      ),
                ),
              ],
            ),
            actions: <Widget>[
              Row(
                children: [
                  Container(
                    color: kBackgroundColor,
                    //width: double.maxFinite,
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: kBluePrimaryColor,
                      child: const Text(
                        "ADD",
                        style: TextStyle(color: kBackgroundColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // if all are valid then go to success screen
                          reportquestion(context);
                          Navigator.of(context).pop();
                          //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: kBackgroundColor,
                    //width: double.maxFinite,
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: kOrangePrimaryColor,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: kBackgroundColor),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        ));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height * 0.5;
        var width = MediaQuery.of(context).size.width;
        return alert;
      },
    );
  }

  Future<File> _fileFromImageUrl() async {
    print('in funtion');
    final response = await http.get(Uri.parse(
        '$imageapiurl/question/92e879ba-d429-4fe4-8315-ff1e6bcc034f/1615271722440_1560351722.jpg'));

    Directory documentDirectory = await getApplicationDocumentsDirectory();

    //file =  File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);
    print(response.statusCode);
    //file = File("https://api.decideit.devbyopeneyes.com/public/question/92e879ba-d429-4fe4-8315-ff1e6bcc034f/1615271722440_1560351722.jpg");
    print(file.path);
    return file;
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var shareduserid = prefs.getString('userid');

    userid = shareduserid;
    providedimageextensions = prefs.getStringList('imageextensions') ?? [];
    providedvideoextensions = prefs.getStringList('videoextensions') ?? [];
    if (providedvideoextensions.contains(fileextension)) {
      _controller = VideoPlayerController.network(
        '${'$imageapiurl/question/$id'}/$questionimageurl',
      );

      // Initialize the controller and store the Future for later use.
      //_initializeVideoPlayerFuture = _controller!.initialize();
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

  showProfileImage() {
    return imageurl == null || imageurl == ''
        ? const AssetImage('images/user.jpg')
        : NetworkImage('$imageapiurl/$imageurl');
  }

  naviagte() async {
    print(username);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchlist = [];

    List<String> sourcelist = [];
    var sharedsearchlist = prefs.getStringList('searchword');
    var sharedsourcelist = prefs.getStringList('communitysource');
    print('Coming from question card');
    print(searchlist);
    print(id);
    if (sharedsourcelist != null) {
      sourcelist = sharedsourcelist;
      searchlist = sharedsearchlist!;
    }
    searchlist.add(id);
    sourcelist.add(sourceoption.toString());
    print('Source List items');
    print(sourcelist);
    prefs.setStringList('communitysource', sourcelist);
    prefs.setStringList('searchword', searchlist);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => QuestionDetail(id)));
  }
}
