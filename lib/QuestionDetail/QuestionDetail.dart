import 'dart:convert';

import 'dart:io';
import 'dart:ui';
import 'package:chewie/chewie.dart';
import 'package:decideitfinal/Community/CommunityListApiResponse.dart';
import 'package:decideitfinal/CommunityQuestions/CommunityQuestion.dart';
import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/GlobalSearch/globalsearch.dart';
import 'package:decideitfinal/Home/QuestionCard.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/Plans/PlanDataAPI.dart';
import 'package:decideitfinal/PostQuestion/ContactDetails.dart';
import 'package:decideitfinal/QuestionDetail/FunnelChartDataApi.dart';
import 'package:decideitfinal/QuestionDetail/MoreInvitationAPI.dart';
import 'package:decideitfinal/QuestionDetail/PieChartDataAPI.dart';
import 'package:decideitfinal/QuestionDetail/QuestionComments.dart';
import 'package:decideitfinal/QuestionDetail/QuestionDetailAPI.dart';
import 'package:decideitfinal/QuestionDetail/SendOptionQuestionDetail.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:video_player/video_player.dart';
import '../PublicProfile/DIStarProfile.dart';
import '../alertDialog.dart';
import 'BarChartModel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class QuestionDetail extends StatefulWidget {
  var id;

  QuestionDetail(id) {
    this.id = id;
  }
  @override
  _QuestionDetailState createState() => _QuestionDetailState(id);
}

class _QuestionDetailState extends State<QuestionDetail>
    with TickerProviderStateMixin {
  var answerusername, header, userid, questionid, sourceoption, searchword;

  _QuestionDetailState(id) {
    questionid = id;
  }

  late String questionText,
      questionTypeId,
      imageVideoUrl,
      fileExtention,
      userName,
      profileImageUrlexpireTime,
      expireTime,
      expireTitle,
      postedTime,
      community,
      questioncreatedby,
      questionuserid,
      owneruserid,
      reportedname;
  late int views, commentsCount;
  var planid;
  List<String> communitylist = [],
      communityidlist = [],
      answerid = [],
      answeroptions = [],
      tempansweroptions = [],
      answeroptionsid = [],
      chartoptionname = [];
  List<int> chartoptionvisit = [];
  late int responselimit;
  bool _enabled = true;
  final _formKey = GlobalKey<FormState>();
  FocusNode questiontextfield = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController questioncontroller = TextEditingController();
  var question;
  bool isVisible = true;
  final List<String> errors = [];
  String showhidetext = "Show";
  bool showhideflag = false;
  IconData showarrow = Icons.arrow_drop_down;
  var flag = "question_detail";
  List<Widget> postanswerlist = [];
  List<Widget> displayanswerlist = [];
  int _groupValue = 0;
  int _newValue = 0;
  TextEditingController reportcommentcontroller = TextEditingController();
  var commentvalue = "";
  List<int> rank1chart = [];
  List<int> rank2chart = [];
  List<int> rank3chart = [];
  List<int> rank4chart = [];
  List<int> rank5chart = [];
  List<int> rank6chart = [];
  List<String> commentsusernamelist = [];
  List<String> commentsuserisliked = [];
  List<String> commentsuserlikescount = [];
  List<String> commentsuserprofileimage = [];
  List<String> commentsuseranswer = [];
  List<String> commentsuserpostedtime = [];
  List<String> commentsuserid = [];
  List<String> storedanswerlist = [];
  bool isansweravailable = false;

  List<bool> answercheckboxvalue = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  final List<BarChartModel> data = [];
  bool displayoptions = false;
  bool showoptions = false;
  bool editoptions = false;
  bool _isInAsyncCall = false;

  String tempcommlist = "";
  late String isliked, likescount;
  bool postanonymously = false;
  int isprofileprivate = 0;
  late String sendoptionid;
  var storedanswer;
  late File file;
  var isreported;
  List<String> barchartcolorcode = [
    "#85c5e3",
    "#858de3",
    "#b585e3",
    "#d285e3",
    "#e385d8",
    "#e385a0"
  ];
  AppBar appbar = AppBar();
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  List<String> providedvideoextensions = [],
      providedimageextensions = [],
      inviteeslist = [],
      inviteesdisplayname = [];
  bool showinvitemorepeople = false, checkvalue = false;
  late String inviteecaninviteothers, inviteesonlytome;
  final _inviteeformKey = GlobalKey<FormState>();
  TextEditingController inviteecontroller = TextEditingController();
  late int errorflagcontacts,
      errorflagsform = 0,
      numberofprivateinvitation = 0,
      numberofcommunityinvitation = 0,
      numberofinvitation = 0;
  FocusNode contactstextfield = FocusNode();
  List<String> inviteduserid = [],
      contactdetails = [],
      sourcelist = [],
      searchlist = [];
  ChewieController? chewieController;

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
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
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: SizedBox(
            height: appbar.preferredSize.height * 0.8,
            child: Image.asset('logos/DI_Logo.png')),
        centerTitle: true,
        backgroundColor: kBluePrimaryColor,
        leading: GestureDetector(
            onTap: () async {
              sourceoption = sourcelist[sourcelist.length - 1];
              if (sourcelist.length != 1) {
                print(searchlist);
                searchword = searchlist[searchlist.length - 2];
                sourcelist.removeLast();
                searchlist.removeLast();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setStringList('communitysource', sourcelist);
                prefs.setStringList('searchword', searchlist);
              } else {
                searchword = searchlist[searchlist.length - 1];
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('communitysource');
                prefs.remove('searchword');
              }
              print(sourcelist);
              print(sourceoption);
              if (sourceoption == '1') {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              } else if (sourceoption == '2') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => GlobalSearch(searchword)));
              } else if (sourceoption == '3') {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Dashboard()));
              } else if (sourceoption == '4') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CommunityQuestion(searchword)));
              } else if (sourceoption == '5') {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => DIStarProfile(searchword,6)));
              }
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(children: <Widget>[
                Center(child: Image.asset('images/BG.jpg')),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Center(
                      child: Text(
                    "Post your response",
                    style: TextStyle(
                        color: kBackgroundColor,
                        fontSize: MediaQuery.of(context).size.width * 0.063,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
                ),
              ]),
              /*Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset('images/BG.png'),
              ),*/
              Padding(
                padding: const EdgeInsets.all(8),
                child: _enabled
                    ? Shimmer.fromColors(
                        baseColor: Colors.black12,
                        highlightColor: Colors.white10,
                        enabled: _enabled,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: QuestionCard(
                              '',
                              '',
                              '',
                              'Private',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              '',
                              5,
                              ''),
                        ))
                    : Card(
                        color: Colors.white.withOpacity(0.8),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                  spacing: 5.0,
                                  direction: Axis.horizontal,
                                  children: [
                                    Wrap(children: [
                                      RichText(
                                        text: TextSpan(
                                          text: 'Posted by: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kBluePrimaryColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0335),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: userName == null
                                                    ? 'username'
                                                    : '$userName $postedTime',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black,
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.034)),
                                          ],
                                        ),
                                      )
                                    ]),
                                    RichText(
                                      text: TextSpan(
                                        text: userName == null
                                            ? 'username'
                                            : expireTitle.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.034),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: userName == null
                                                  ? 'username'
                                                  : ' $expireTime',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.034)),
                                        ],
                                      ),
                                    )
                                  ]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Text(
                                userName == null ? 'username' : questionText,
                                style: TextStyle(
                                  color: kBluePrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                              ),
                            ),
                            imageVideoUrl.isEmpty
                                ? const SizedBox()
                                : imagextensions.contains(fileExtention)
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.network(
                                            '$imageapiurl/question/$questionid/$imageVideoUrl',
                                            fit: BoxFit.cover,
                                            //height: MediaQuery.of(context).size.height * 0.1,
                                            //width: MediaQuery.of(context).size.width * 0.9
                                          ),
                                        ),
                                      )
                                    : chewieController != null
                                        ? SizedBox(
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
                            //         return AspectRatio(
                            //           aspectRatio: _controller!
                            //               .value.aspectRatio,
                            //           // Use the VideoPlayer widget to display the video.
                            //           child: GestureDetector(
                            //               child: Stack(
                            //             alignment:
                            //                 Alignment.bottomCenter,
                            //             children: [
                            //               VideoPlayer(_controller!),
                            //               const ClosedCaption(
                            //                   text: null),
                            //               GestureDetector(
                            //                 onTap: () {
                            //                   setState(() {
                            //                     // If the video is playing, pause it.
                            //                     if (_controller!
                            //                         .value.isPlaying) {
                            //                       _controller!.pause();
                            //                     } else {
                            //                       // If the video is paused, play it.
                            //                       _controller!.play();
                            //                     }
                            //                   });
                            //                 },
                            //                 child: Icon(
                            //                   _controller!
                            //                           .value.isPlaying
                            //                       ? Icons.pause
                            //                       : Icons.play_arrow,
                            //                 ),
                            //               ),
                            //               const SizedBox(
                            //                 height: 2,
                            //               ),
                            //               VideoProgressIndicator(
                            //                 _controller!,
                            //                 allowScrubbing: true,
                            //                 padding:
                            //                     const EdgeInsets.all(3),
                            //                 colors: VideoProgressColors(
                            //                     playedColor:
                            //                         Theme.of(context)
                            //                             .primaryColor),
                            //               ),
                            //             ],
                            //           )),
                            //         );
                            //       } else {
                            //         // If the VideoPlayerController is still initializing, show a
                            //         // loading spinner.
                            //         return const Center(
                            //             child:
                            //                 CircularProgressIndicator());
                            //       }
                            //     },
                            //   ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: displaycommunities(),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          var body;
                                          if (isliked.isEmpty) {
                                            body = {
                                              "question_id": questionid,
                                              "is_like": 1
                                            };
                                          } else {
                                            body = {
                                              "question_id": questionid,
                                              "is_like": 0
                                            };
                                          }
                                          print(body);

                                          var response = await http.post(
                                              Uri.parse(
                                                  '$apiurl/questionDetail/likeQuestion'),
                                              body: json.encode(body),
                                              headers: {
                                                "Content-Type":
                                                    "application/json",
                                                "Authorization": header
                                              },
                                              encoding:
                                                  Encoding.getByName("utf-8"));

                                          if (response.statusCode == 200) {
                                            print(response.body);
                                            setState(() {
                                              if (isliked.isEmpty) {
                                                int temp =
                                                    int.parse(likescount) + 1;
                                                likescount = temp.toString();
                                                isliked = "temp";
                                              } else {
                                                int temp =
                                                    int.parse(likescount) - 1;
                                                likescount = temp.toString();
                                                isliked = "";
                                              }
                                            });
                                          } else {
                                            print(response.statusCode);
                                            print(response.body);
                                          }
                                        },
                                        child: Icon(
                                          isliked.isEmpty
                                              ? Icons.thumb_up_alt_outlined
                                              : Icons.thumb_up,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          //height: MediaQuery.of(context).size.height * 0.04,
                                          //width: MediaQuery.of(context).size.width * 0.04,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(likescount,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.037)),
                                    ],
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/view.png',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                          userName.isEmpty
                                              ? 'username'
                                              : views.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.037)),
                                    ],
                                  ),
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/comment.png',
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                          userName.isEmpty
                                              ? 'username'
                                              : commentsCount.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.037)),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      print('Reported');
                                      if (isreported == null) {
                                        print('in if');
                                        if (userid == null) {
                                          SharedPreferences userprefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          userprefs.setString(
                                              'ReportQuestion', 'Please login');
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()));
                                        } else {
                                          showreportquestion(context, 0, 0);
                                        }
                                      }
                                    },
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Image.asset(
                                          'images/report.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.038,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.038,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                            isreported == null
                                                ? 'Report'
                                                : 'Reported',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.037)),
                                      ],
                                    ),
                                  ),
                                  _enabled
                                      ? const SizedBox()
                                      : communitylist.isEmpty
                                          ? const SizedBox()
                                          : communitylist[0] != ""
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    final RenderBox box = context
                                                            .findRenderObject()
                                                        as RenderBox;
                                                    String url =
                                                        'https://decideit.uatbyopeneyes.com/questionDetails/$questionid';
                                                    final quote = questionText;
                                                    await FlutterShare.share(
                                                        linkUrl:
                                                            'Check this out $url',
                                                        text: quote,
                                                        title:
                                                            "DecideIt Community");
                                                  },
                                                  child: Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        'images/share.png',
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.038,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.038,
                                                      ),
                                                      const SizedBox(
                                                        width: 3,
                                                      ),
                                                      Text('Share',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.037)),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
              ),
              _enabled
                  ? const SizedBox()
                  : userid == null
                      ? const SizedBox()
                      : showinvitees(),
              showoptions
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Answer as: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035),
                          children: <TextSpan>[
                            TextSpan(
                                text: answerusername == null
                                    ? 'Anonymous'
                                    : answerusername,
                                style: TextStyle(
                                    color: kBluePrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035)),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              showoptions
                  ? Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildenterquestionfield(),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: displaypostanonymouslyoption(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: RaisedButton(
                                  onPressed: () {
                                    print('Post Answer');
                                    postanswer();
                                  },
                                  color: kBluePrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: kBluePrimaryColor)),
                                  child: const Text(
                                    'Post Answer',
                                    style: TextStyle(color: kBackgroundColor),
                                  )),
                            ),
                          )
                        ],
                      ),
                    )
                  : const SizedBox(),
              isansweravailable
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: showhidetext,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.035),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ' answers by other users ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035)),
                              ],
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  displayanswerlist.clear();
                                  postanswerlist.clear();
                                  if (showhideflag) {
                                    showhideflag = false;
                                    showhidetext = "Show";
                                    showarrow = Icons.arrow_drop_down;
                                  } else {
                                    showhideflag = true;
                                    showhidetext = "Hide";
                                    showarrow = Icons.arrow_drop_up;
                                  }
                                  // _isInAsyncCall = true;
                                  // getanswers();
                                });
                              },
                              child: Icon(showarrow))
                        ],
                      ),
                    )
                  : _enabled
                      ? const SizedBox()
                      : const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'There are no answers for this question',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: kOrangePrimaryColor),
                          )),
              showhideflag ? displayanswers() : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  displaypostanonymouslyoption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Theme(
          data: ThemeData(),
          child: Checkbox(
            value: postanonymously,
            checkColor: kBluePrimaryColor,
            activeColor: kBackgroundColor,
            onChanged: (value) {
              setState(() {
                if (isprofileprivate == 1) {
                  if (!value!) {
                    BlurryDialog alert = BlurryDialog('Error',
                        'Make your profile public if you do not want to post questions anonymously');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        var height = MediaQuery.of(context).size.height;
                        var width = MediaQuery.of(context).size.width;
                        return alert;
                      },
                    );
                  }
                } else {
                  postanonymously = value!;
                }
              });
            },
          ),
        ),
        const Text(
          'Post Anonymously',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'OpenSans',
          ),
        ),
      ],
    );
  }

  buildenterquestionfield() {
    print('In type id');
    print(questionTypeId);
    if (questionTypeId == "176c9480-1a9b-11eb-b17b-c85b767b9463") {
      postanswerlist.add(Wrap(
        direction: Axis.horizontal,
        children: [
          for (var item in answeroptions)
            Row(
              children: [
                Radio(
                    value: answeroptions.indexOf(item),
                    groupValue: _groupValue,
                    onChanged: (newValue) => setState(() {
                          displayanswerlist.clear();
                          postanswerlist.clear();
                          _groupValue = int.parse(newValue.toString());
                          print(answeroptions[_groupValue]);
                          print(answeroptionsid);
                        })),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        displayanswerlist.clear();
                        postanswerlist.clear();
                        _groupValue = answeroptions.indexOf(item);
                        print(answeroptions[_groupValue]);
                        print(answeroptionsid);
                      });
                    },
                    child: Text(item)),
              ],
            ),
        ],
      ));
    } else if (questionTypeId == "218a1492-1a9b-11eb-b17b-c85b767b9463") {
      postanswerlist.add(Row(
        children: [
          Radio(
              value: 0,
              groupValue: _groupValue,
              onChanged: (newValue) => setState(() {
                    displayanswerlist.clear();
                    postanswerlist.clear();
                    _groupValue = int.parse(newValue.toString());

                    _newValue = int.parse(newValue.toString());
                  })),
          GestureDetector(
              onTap: () {
                setState(() {
                  displayanswerlist.clear();
                  postanswerlist.clear();
                  _groupValue = 0;
                  _newValue = 0;
                });
              },
              child: const Text('Yes')),
          const SizedBox(
            width: 4,
          ),
          Radio(
              value: 1,
              groupValue: _groupValue,
              onChanged: (newValue) => setState(() {
                    displayanswerlist.clear();
                    postanswerlist.clear();
                    _groupValue = int.parse(newValue.toString());

                    _newValue = int.parse(newValue.toString());
                  })),
          GestureDetector(
              onTap: () {
                setState(() {
                  displayanswerlist.clear();
                  postanswerlist.clear();
                  _groupValue = 1;
                  _newValue = 1;
                });
              },
              child: const Text('No')),
        ],
      ));
    } else if (questionTypeId == "1d5a0fb1-1a9b-11eb-b17b-c85b767b9463") {
      postanswerlist.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Wrap(
          children: [
            for (var item in answeroptions)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Theme(
                    data: ThemeData(),
                    child: Checkbox(
                      value: answercheckboxvalue[answeroptions.indexOf(item)],
                      checkColor: kBluePrimaryColor,
                      activeColor: kBackgroundColor,
                      onChanged: (value) {
                        setState(() {
                          displayanswerlist.clear();
                          postanswerlist.clear();
                          answercheckboxvalue[answeroptions.indexOf(item)] =
                              value!;
                        });
                      },
                    ),
                  ),
                  Text(
                    item,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ],
              ),
          ],
        ),
      ));
    } else if (questionTypeId == "295122ee-1a9b-11eb-b17b-c85b767b9463") {
      postanswerlist.add(
        Container(
          //height: 211,
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            //primary: false,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => buildRow(index),
            itemCount: answeroptions.length,
          ),
        ),
      );
    } else if (questionTypeId == "3a536800-1a9b-11eb-b17b-c85b767b9463") {
      postanswerlist.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width * 0.95,
        child: TextFormField(
            focusNode: questiontextfield,
            controller: questioncontroller,
            onSaved: (newValue) => question = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: 'Please enter the answer');
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                questiontextfield.requestFocus();
                return 'Please enter the answer';
                //addError(error: kNamelNullError);
              }
            },
            maxLength: 255,
            maxLines: 5,
            minLines: 1,
            decoration: InputDecoration(
                //labelText: "Name",
                hintText: 'Enter your Answer',
                hintStyle: const TextStyle(color: Colors.black),
                prefixIcon: Visibility(
                  visible: isVisible,
                  child: const Icon(
                    Icons.create_outlined,
                    color: Colors.grey,
                  ),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ))
            // If  you are using latest version of flutter then lable text and hint text shown like this
            // if you r using flutter less then 1.20.* then maybe this is not working properly
            ),
      ));
    }

    if (postanswerlist.length > 1) {
      postanswerlist.removeAt(0);
    }
    return Column(mainAxisSize: MainAxisSize.min, children: postanswerlist);
  }

  void reorderData(int oldindex, int newindex) {
    setState(() {
      displayanswerlist.clear();
      postanswerlist.clear();
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = answeroptions.removeAt(oldindex);
      answeroptions.insert(newindex, items);
    });
  }

  Widget buildRow(int index) {
    String optionname = answeroptions[index];
    ListTile tile = ListTile(
      title: Text(optionname),
    );
    Draggable draggable = LongPressDraggable<String>(
      data: optionname,
      axis: Axis.vertical,
      maxSimultaneousDrags: 1,
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: tile,
      ),
      feedback: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: tile,
        ),
      ),
      child: tile,
    );

    return DragTarget<String>(
      onWillAccept: (optionname) {
        return answeroptions.indexOf(optionname!) != index;
      },
      onAccept: (optionname) {
        setState(() {
          int currentIndex = answeroptions.indexOf(optionname);
          answeroptions.remove(optionname);
          answeroptions.insert(
              currentIndex > index ? index : index - 1, optionname);
        });
      },
      builder: (BuildContext context, List<String?> candidateData,
          List<dynamic> rejectedData) {
        return Column(
          children: <Widget>[
            AnimatedSize(
              duration: const Duration(milliseconds: 100),
              vsync: this,
              child: candidateData.isEmpty
                  ? Container()
                  : Opacity(
                      opacity: 0.0,
                      child: tile,
                    ),
            ),
            Card(
              child: candidateData.isEmpty ? draggable : tile,
            )
          ],
        );
      },
    );
  }

  displayanswers() {
    print(commentsuseranswer);
    print(commentsuserid);
    displayanswerlist.clear();
    print(commentsuseranswer.length);

    if (commentsuserid.isNotEmpty) {
      userid == commentsuserid[0]
          ? displayanswerlist.add(ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: commentsuseranswer.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
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
                                padding: const EdgeInsets.all(8.0),
                                child: DecoratedBox(
                                  decoration: ShapeDecoration(
                                      shape: const CircleBorder(),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: showImage(index),
                                      )),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    commentsusernamelist[index],
                                    style: TextStyle(
                                      color: kBluePrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(commentsuseranswer[index],
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.039)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var body;
                                      if (userid == null) {
                                        SharedPreferences userprefs =
                                            await SharedPreferences
                                                .getInstance();
                                        userprefs.setString(
                                            'ReportQuestion', 'Please login');
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()));
                                      } else {
                                        if (commentsuserisliked[index]
                                            .isEmpty) {
                                          body = {
                                            "question_id": questionid,
                                            "is_like": 1
                                          };
                                        } else {
                                          body = {
                                            "question_id": questionid,
                                            "is_like": 0
                                          };
                                        }

                                        var response = await http.post(
                                            Uri.parse(
                                                '$apiurl/questionDetail/likeQuestion'),
                                            body: json.encode(body),
                                            headers: {
                                              "Content-Type":
                                                  "application/json",
                                              "Authorization": header
                                            },
                                            encoding:
                                                Encoding.getByName("utf-8"));

                                        if (response.statusCode == 200) {
                                          print(response.body);
                                          setState(() {
                                            if (commentsuserisliked[index]
                                                .isEmpty) {
                                              int temp = int.parse(
                                                      commentsuserlikescount[
                                                          index]) +
                                                  1;
                                              commentsuserlikescount[index] =
                                                  temp.toString();
                                              commentsuserisliked[index] =
                                                  "temp";
                                            } else {
                                              int temp = int.parse(
                                                      commentsuserlikescount[
                                                          index]) -
                                                  1;
                                              commentsuserlikescount[index] =
                                                  temp.toString();
                                              commentsuserisliked[index] = "";
                                            }
                                          });
                                        } else {
                                          print(response.statusCode);
                                          print(response.body);
                                        }
                                      }
                                    },
                                    child: Icon(
                                      commentsuserisliked[index].isEmpty
                                          ? Icons.thumb_up_alt_outlined
                                          : Icons.thumb_up,
                                      size: 14,
                                      //height: MediaQuery.of(context).size.height * 0.04,
                                      //width: MediaQuery.of(context).size.width * 0.04,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(commentsuserlikescount[index],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.037)),
                                ],
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Image.asset(
                                'images/clock.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(commentsuserpostedtime[index],
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.039)),
                              const SizedBox(
                                width: 8,
                              ),
                              expireTitle != "Expired:" &&
                                      commentsuserid[index] == userid
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          //showoptions = true;
                                          print(commentsuseranswer[index]);
                                          displayanswerlist.clear();
                                          postanswerlist.clear();
                                          if (questionTypeId ==
                                              "176c9480-1a9b-11eb-b17b-c85b767b9463") {
                                            _groupValue = answeroptions
                                                .indexOf(commentsuseranswer[0]);
                                            print(answeroptions);
                                            print(commentsuseranswer[0]);
                                            print(
                                                'Group Value is $_groupValue');
                                          } else if (questionTypeId ==
                                              "218a1492-1a9b-11eb-b17b-c85b767b9463") {
                                            print(commentsuseranswer[index]);
                                            if (commentsuseranswer[index] ==
                                                'No') {
                                              print('HII');
                                              _groupValue = 1;
                                            } else {
                                              print('Holla');
                                              _groupValue = 0;
                                            }
                                          } else if (questionTypeId ==
                                              "1d5a0fb1-1a9b-11eb-b17b-c85b767b9463") {
                                            final split = commentsuseranswer[0]
                                                .split(',');
                                            final Map<int, String> values = {
                                              for (int i = 0;
                                                  i < split.length;
                                                  i++)
                                                i: split[i]
                                            };
                                            print('Lenght');
                                            print(values.length);
                                            for (int i = 0;
                                                i < values.length;
                                                i++) {
                                              answercheckboxvalue[answeroptions
                                                  .indexOf(values[i]!)] = true;
                                            }
                                          } else if (questionTypeId ==
                                              "3a536800-1a9b-11eb-b17b-c85b767b9463") {
                                            questioncontroller.text =
                                                commentsuseranswer[0];
                                          }

                                          editoptions = true;
                                        });
                                      },
                                      child: editoptions
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  //showoptions = true;
                                                  displayanswerlist.clear();
                                                  postanswerlist.clear();
                                                  editoptions = false;
                                                });
                                              },
                                              child: const Text('Cancel'))
                                          : Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment
                                                      .center, //The change
                                              direction: Axis.horizontal,
                                              spacing: 5,
                                              children: const [
                                                Icon(Icons.create),
                                                Text('Edit'),
                                              ],
                                            ),
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  print('Reported');
                                  if (isreported == null) {
                                    print('in if');
                                    showreportquestion(context, 1, index);
                                  }
                                },
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/report.png',
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.038,
                                      width: MediaQuery.of(context).size.width *
                                          0.038,
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                        isreported == null
                                            ? 'Report'
                                            : 'Reported',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.037)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        commentsuserid[index] == userid && editoptions
                            ? Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: buildenterquestionfield(),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              print('Edit Answer');
                                              editanswer();
                                            },
                                            style: buttonStyle(),
                                            child: const Text(
                                              'Edit Answer',
                                              style: TextStyle(
                                                  color: kBackgroundColor),
                                            )),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              }))
          : const SizedBox();
    }

    if (chartoptionname.isNotEmpty) {
      if (questionTypeId == "176c9480-1a9b-11eb-b17b-c85b767b9463" ||
          questionTypeId == "1d5a0fb1-1a9b-11eb-b17b-c85b767b9463" ||
          questionTypeId == "295122ee-1a9b-11eb-b17b-c85b767b9463") {
        displayanswerlist.add(showcharts());
        displayanswerlist.add(const SizedBox(
          height: 20,
        ));
      } else if (questionTypeId == "218a1492-1a9b-11eb-b17b-c85b767b9463") {
        displayanswerlist.add(showpiecharts());
        displayanswerlist.add(const SizedBox(
          height: 20,
        ));
      }
    }

    return Column(mainAxisSize: MainAxisSize.min, children: displayanswerlist);
  }

  void showreportquestion(BuildContext context, int source, int index) {
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
              child: Text('Report Question',
                  style: TextStyle(
                    color: kBluePrimaryColor,
                  )),
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
                          if (source == 0) {
                            reportquestion(context);
                            Navigator.of(context).pop();
                          } else {
                            reportanswer(context, index);
                            Navigator.of(context).pop();
                          }
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
                    child: ElevatedButton(
                      style: buttonStyle(),
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

  void reportquestion(BuildContext context) async {
    var body = {
      "question_id": questionid,
      "postedBy": reportedname,
      "comment": reportcommentcontroller.text
    };

    setState(() {
      displayanswerlist.clear();
      postanswerlist.clear();
      _enabled = true;
    });
    var response = await http.post(
        Uri.parse('$apiurl/questionDetail/reportQuestion'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      displayanswerlist.clear();
      postanswerlist.clear();

      _enabled = false;
    });
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      setState(() {
        cleardata();
        getuserdata();
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
      BlurryDialogSingle alert =
          BlurryDialogSingle("Error", 'Something went wrong!');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
    }
  }

  void reportanswer(BuildContext context, int index) async {
    var body = {
      "question_id": questionid,
      "postedBy": userName,
      "comment": reportcommentcontroller.text,
      "invitee_answer_id": answerid[index]
    };

    setState(() {
      displayanswerlist.clear();
      postanswerlist.clear();
      _enabled = true;
    });
    var response = await http.post(
        Uri.parse('$apiurl/questionDetail/reportAnswer'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      displayanswerlist.clear();
      postanswerlist.clear();
      _enabled = false;
    });
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
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
      BlurryDialogSingle alert =
          BlurryDialogSingle("Error", 'Something went wrong!');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
      print(response.statusCode);
      print(response.body);
    }
  }

  void getquestiondetail() async {
    var body;
    body = {"flag": flag, "id": questionid};
    print(body);

    var body1 = {"flag": "answer_send_options", "id": questionid};

    var annonymousresponse = await http.post(
        Uri.parse('$apiurl/questionDetail'),
        body: json.encode(body1),
        headers: {"Content-Type": "application/json"},
        encoding: Encoding.getByName("utf-8"));

    if (annonymousresponse.statusCode == 200) {
      SendOptionQuestionDetail sendOptionQuestionDetail =
          sendOptionQuestionDetailFromJson(annonymousresponse.body);

      Data data = sendOptionQuestionDetail.data;
      sendoptionid = data.id;
    } else {
      print(annonymousresponse.statusCode);
      print(annonymousresponse.body);
    }
    var viewbody = {"flag": "question_view", "id": questionid, "limit": ""};
    var viewresponse = await http.post(Uri.parse('$apiurl/questionDetail'),
        body: json.encode(viewbody),
        headers: {"Content-Type": "application/json"},
        encoding: Encoding.getByName("utf-8"));

    print('The view response is');
    print(viewresponse.body);
    print(viewresponse.statusCode);

    var response = await http.post(Uri.parse('$apiurl/questionDetail'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(response.body);
      QuestionDetailApi questionDetailApi =
          questionDetailApiFromJson(response.body);

      print('Is it liked: ');
      print(questionDetailApi.isLike);

      List<Option> options = questionDetailApi.options;
      for (int i = 0; i < options.length; i++) {
        answeroptions.add(options[i].value);
        tempansweroptions.add(options[i].value);
        answeroptionsid.add(options[i].id);
      }

      print('Option LIstsss are: ');
      print(answeroptions);
      print(questionDetailApi.isLike);
      //isreported = questionDetailApi.isAbused;
      isliked = questionDetailApi.isLike ?? "";
      likescount = questionDetailApi.likesCount.toString();
      questionuserid = questionDetailApi.userId;
      fileExtention = questionDetailApi.fileExtention;
      UserId? isabused = questionDetailApi.questionDetailApiUserId;
      if (isabused != null) {
        isreported = questionDetailApi.questionDetailApiUserId!.userId;
      } else {
        isreported = null;
      }
      questionText = questionDetailApi.questionText;
      questionTypeId = questionDetailApi.questionTypeId;
      userName = questionDetailApi.displayName;
      reportedname = questionDetailApi.userName;
      expireTitle = questionDetailApi.expireTitle;
      expireTime = questionDetailApi.expireTime;
      imageVideoUrl = questionDetailApi.imageVideoUrl ?? "";
      Plan plan = questionDetailApi.plan;
      responselimit = plan.numberOfResponses;
      inviteecaninviteothers = questionDetailApi.inviteeCanInviteOthers;
      inviteesonlytome = questionDetailApi.inviteesOnlyToMe;
      List<Community> communities = questionDetailApi.community;
      tempcommlist = "";
      var tempcommidlist = "";
      for (int j = 0; j < communities.length; j++) {
        if (j + 1 == communities.length) {
          tempcommlist = tempcommlist + communities[j].name;
          tempcommidlist = tempcommidlist + communities[j].id;
        } else {
          tempcommlist = "$tempcommlist${communities[j].name}, ";
          tempcommidlist = "$tempcommidlist${communities[j].id}, ";
        }
      }
      communitylist.add(tempcommlist);
      communityidlist.add(tempcommidlist);
      print(communities.length);
      for (int j = 0; j < communities.length; j++) {
        print(communities[j].name);
        if (j + 1 == communities.length) {
          tempcommlist = tempcommlist + communities[j].name;
        } else {
          tempcommlist = "$tempcommlist${communities[j].name}, ";
        }
      }
      community = tempcommlist;
      views = questionDetailApi.views;
      commentsCount = questionDetailApi.commentsCount;
      postedTime = questionDetailApi.postedTime;
      questioncreatedby = questionDetailApi.createdBy;
      owneruserid = questionDetailApi.ownerUserId;
      postanswerlist.clear();
      displayanswerlist.clear();
      print('Options id are:');
      print(answeroptionsid);
      if (storedanswer != null) {
        if (questionTypeId == "295122ee-1a9b-11eb-b17b-c85b767b9463") {
          for (int i = 0; i < storedanswerlist.length; i++) {
            for (int j = 0; j < answeroptionsid.length; j++) {
              if (storedanswerlist[i] == answeroptionsid[j]) {
                String temp = answeroptions[i];
                String tempid = answeroptionsid[i];
                answeroptions[i] = answeroptions[j];
                answeroptions[j] = temp;
                tempansweroptions[i] = tempansweroptions[j];
                tempansweroptions[j] = temp;
                answeroptionsid[i] = answeroptionsid[j];
                answeroptionsid[j] = tempid;
              }
            }
          }
        } else {
          print('In comparison');
          print(storedanswerlist[0]);
          if (storedanswerlist[0] == answeroptionsid[0]) {
            print('It is same');
          }
          print(answeroptionsid);
          print(storedanswerlist);
          for (int i = 0; i < storedanswerlist.length; i++) {
            for (int j = 0; j < answeroptionsid.length; j++) {
              if (storedanswerlist[i] == answeroptionsid[j]) {
                print('Both are same');
                answercheckboxvalue[j] = true;
              }
            }
          }
        }

        storedanswer = null;
        storedanswerlist = [];
      }
      print('File extension is:');
      print(fileExtention);
      if (fileExtention == "MOV") {
        print('Working');
        print(imageapiurl);
        print(questionid);
        print(imageVideoUrl);
        _controller = VideoPlayerController.network(
          '${'$imageapiurl/question/$questionid'}/$imageVideoUrl',
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
      } else {
        print('Not working in Question Detail');
      }
      print('Options are:');
      print(answeroptions);
      print('Options id are:');
      print(answeroptionsid);
      print('Temp Answer options are:');
      print(tempansweroptions);
      print('Checkboxes are');
      print(answercheckboxvalue);
      print('Is Liked: $isliked');
      List<InviteesTemp> list = questionDetailApi.inviteesTemp;
      for (int i = 0; i < list.length; i++) {
        Address? address = list[i].address;
        if (address != null) {
          if (list[i].address!.contactEmail != null) {
            inviteeslist.add(list[i].address!.contactEmail!);
          } else {
            inviteeslist.add(list[i].address!.contactPhone ?? "");
          }
        }

        inviteduserid.add(list[i].user!.id);
        if (list[i].user!.firstName != null) {
          inviteesdisplayname
              .add("${list[i].user!.firstName} ${list[i].user!.lastName}");
        } else {
          inviteesdisplayname.add(list[i].user!.email);
        }
      }

      if (userid != null) {
        getplandata();
      }
      getanswers();
      setState(() {});
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedplanid = prefs.getString('planid');
    var sharedisprivate = prefs.getInt('isprofileprivate');
    var sharedquestionid = prefs.getString('QuestionID');
    var sharedsourcelist = prefs.getStringList('communitysource');
    var sharedsearchlist = prefs.getStringList('searchword');
    print('Search list in shared preference');
    print(sharedsearchlist);

    if (sharedsourcelist != null) {
      sourcelist = sharedsourcelist;
      searchlist = sharedsearchlist ?? [];
    }

    setState(() {
      displayanswerlist.clear();
      postanswerlist.clear();
      userid = shareduserid;
      header = sharedtoken;
      answerusername = sharedname;
      isprofileprivate = sharedisprivate ?? 0;
      planid = sharedplanid;
      //providedimageextensions = prefs.getStringList('imageextensions');
      //providedvideoextensions = prefs.getStringList('videoextensions');
      if (isprofileprivate == 1) {
        postanonymously = true;
      }
      if (sharedquestionid != null) {
        print('In shared detail');
        var sharedquestiontypeid = prefs.getString('QuestionTypeID');
        if (sharedquestiontypeid == "176c9480-1a9b-11eb-b17b-c85b767b9463") {
          //picklist
          _groupValue = int.parse(prefs.getString('AnswerValue') ?? '0');
        } else if (sharedquestiontypeid ==
            "218a1492-1a9b-11eb-b17b-c85b767b9463") {
          //yesno
          _groupValue = int.parse(prefs.getString('AnswerValue') ?? '0');
        } else if (sharedquestiontypeid ==
            "1d5a0fb1-1a9b-11eb-b17b-c85b767b9463") {
          //multiselect
          storedanswer = prefs.getString('AnswerValue');
          final split = storedanswer.split(',');
          final Map<int, String> values = {
            for (int i = 0; i < split.length; i++) i: split[i]
          };
          for (int i = 0; i < values.length; i++) {
            String trimmedvalue = values[i]!.trim();
            if (i == 0) {
              trimmedvalue = trimmedvalue.substring(1);
            }
            if (i + 1 == values.length) {
              trimmedvalue = trimmedvalue.substring(0, trimmedvalue.length - 1);
            }
            print('Trimeed value is$trimmedvalue');
            storedanswerlist.add(trimmedvalue);
          }
          print(prefs.getString('AnswerValue'));
        } else if (sharedquestiontypeid ==
            "3a536800-1a9b-11eb-b17b-c85b767b9463") {
          //expressyourself
          questioncontroller.text = prefs.getString('AnswerValue') ?? "";
        } else if (sharedquestiontypeid ==
            "295122ee-1a9b-11eb-b17b-c85b767b9463") {
          //rankedlist
          storedanswer = prefs.getString('AnswerValue');
          final split = storedanswer.split(',');
          final Map<int, String> values = {
            for (int i = 0; i < split.length; i++) i: split[i]
          };
          for (int i = 0; i < values.length; i++) {
            String trimmedvalue = values[i]!.trim();
            if (i == 0) {
              trimmedvalue = trimmedvalue.substring(1);
            }
            if (i + 1 == values.length) {
              trimmedvalue = trimmedvalue.substring(0, trimmedvalue.length - 1);
            }
            print('Trimeed value is$trimmedvalue');
            storedanswerlist.add(trimmedvalue);
          }
          print(prefs.getString('AnswerValue'));
        }
      }
      prefs.remove('AnswerValue');
      prefs.remove('QuestionTypeID');
      prefs.remove('QuestionID');
      print('Usserid');
      print(userid);
      getquestiondetail();
    });
  }

  void getanswers() async {
    var body;
    body = {
      "flag": "question_comments",
      "id": questionid,
      "limit": responselimit.toString()
    };
    print(body);
    var response = await http.post(Uri.parse('$apiurl/questionDetail'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      _enabled = false;
      _isInAsyncCall = false;
    });

    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (questionTypeId == "218a1492-1a9b-11eb-b17b-c85b767b9463") {
        PieChartData pieChartData = pieChartDataFromJson(response.body);
        List<QuestionCommentss> questioncommentss =
            pieChartData.questionComments;

        print(questioncommentss.length);
        //checking if there are answers for this question or not?
        if (questioncommentss.isEmpty) {
          setState(() {
            displayanswerlist.clear();
            postanswerlist.clear();
            isansweravailable = false;
          });
        } else {
          setState(() {
            displayanswerlist.clear();
            postanswerlist.clear();
            isansweravailable = true;
          });
        }

        for (int i = 0; i < questioncommentss.length; i++) {
          answerid.add(questioncommentss[i].id);
          commentsuserid.add(questioncommentss[i].user.id);
          commentsusernamelist.add(questioncommentss[i].displayName);
          commentsuserpostedtime.add(questioncommentss[i].postedTime);
          commentsuserprofileimage
              .add(questioncommentss[i].user.profileImageUrl);
          commentsuserisliked.add(questioncommentss[i].isLike ?? "");
          commentsuserlikescount
              .add(questioncommentss[i].likesCount.toString());

          List<ChartData> chartdatas = questioncommentss[i].chartData;
          setState(() {
            print('In set state');
            if (commentsuserid.contains(userid) != true &&
                expireTitle != "Expired:") {
              print(commentsusernamelist);
              displayanswerlist.clear();
              postanswerlist.clear();
              showoptions = true;
              print('In condition if');
            } else {
              showoptions = false;
            }
            for (int j = 0; j < chartdatas.length; j++) {
              chartoptionname.add(chartdatas[j].country);
              chartoptionvisit.add(int.parse(chartdatas[j].litres));
            }
            print(chartoptionname);
            if (questioncommentss[i].isTrue == 0) {
              commentsuseranswer.add('No');
            } else {
              commentsuseranswer.add('Yes');
            }
            for (int i = 0; i < chartoptionname.length; i++) {
              print('In data');
              print('Char toption data $chartoptionvisit');
              data.add(
                BarChartModel(
                    answeroptions: chartoptionname[i],
                    visits: chartoptionvisit[i],
                    color: charts.Color.fromHex(code: barchartcolorcode[i])),
              );
            }
          });
        }

        if (commentsuserid.contains(userid) == false &&
            expireTitle != "Expired:") {
          setState(() {
            print('Answer is false');
            displayanswerlist.clear();
            postanswerlist.clear();
            showoptions = true;
          });
        } else {
          setState(() {
            print('Answer is true');
            displayanswerlist.clear();
            postanswerlist.clear();
            showoptions = false;
          });
        }
      } else if (questionTypeId == "3a536800-1a9b-11eb-b17b-c85b767b9463") {
        QuestionComments questionComments =
            questionCommentsFromJson(response.body);

        List<QuestionComment> answerlistdetails =
            questionComments.questionComments;

        if (answerlistdetails.isEmpty) {
          setState(() {
            displayanswerlist.clear();
            postanswerlist.clear();
            isansweravailable = false;
          });
        } else {
          setState(() {
            displayanswerlist.clear();
            postanswerlist.clear();
            isansweravailable = true;
          });
        }
        setState(() {
          for (int i = 0; i < answerlistdetails.length; i++) {
            answerid.add(answerlistdetails[i].id);
            commentsuseranswer.add(answerlistdetails[i].answerText);
            commentsuserid.add(answerlistdetails[i].user.id);
            commentsusernamelist.add(answerlistdetails[i].displayName);
            commentsuserpostedtime.add(answerlistdetails[i].postedTime);
            commentsuserprofileimage
                .add(answerlistdetails[i].user.profileImageUrl ?? "");
            commentsuserisliked.add(answerlistdetails[i].isLike ?? "");
            commentsuserlikescount
                .add(answerlistdetails[i].likesCount.toString());
          }
          if (commentsuserid.contains(userid) == false &&
              expireTitle != "Expired:") {
            setState(() {
              print('Answer is false');
              displayanswerlist.clear();
              postanswerlist.clear();
              showoptions = true;
            });
          } else {
            setState(() {
              print('Answer is true');
              displayanswerlist.clear();
              postanswerlist.clear();
              showoptions = false;
            });
          }
        });
      } else if (questionTypeId == "295122ee-1a9b-11eb-b17b-c85b767b9463") {
        FunnelChartData funnelChartData =
            funnelChartDataFromJson(response.body);
        List<QuestionCommentFunnel> questioncommentfunnel =
            funnelChartData.questionComments;

        if (questioncommentfunnel.isEmpty) {
          setState(() {
            displayanswerlist.clear();
            postanswerlist.clear();
            isansweravailable = false;
          });
        } else {
          setState(() {
            displayanswerlist.clear();
            postanswerlist.clear();
            isansweravailable = true;
          });
        }

        String str = "";
        List<UserOptionFunnel> optionlist = funnelChartData.userOptions;
        print(funnelChartData.userOptions.length);
        for (int i = 0; i < optionlist.length; i++) {
          if (i + 1 == optionlist.length) {
            str = str + optionlist[i].value.toString();
          } else {
            str = '$str${optionlist[i].value},';
          }
        }
        print(optionlist.length);
        commentsuseranswer.add(str);

        for (int i = 0; i < questioncommentfunnel.length; i++) {
          List<ChartDataFunnel> chartdatafunnel =
              questioncommentfunnel[i].chartData;
          answerid.add(questioncommentfunnel[i].id);

          commentsuserisliked.add(questioncommentfunnel[i].isLike ?? "");
          commentsuserlikescount
              .add(questioncommentfunnel[i].likesCount.toString());
          commentsuserid.add(questioncommentfunnel[i].user.id);
          commentsusernamelist.add(questioncommentfunnel[i].displayName);
          commentsuserpostedtime.add(questioncommentfunnel[i].postedTime);
          commentsuserprofileimage
              .add(questioncommentfunnel[i].user.profileImageUrl);
          for (int j = 0; j < chartdatafunnel.length; j++) {
            chartoptionname.add(chartdatafunnel[j].country.toString());
            chartoptionvisit
                .add(int.parse(chartdatafunnel[j].visits.toString()));
          }
          for (int i = 0; i < chartoptionname.length; i++) {
            print('In data');
            print('Char toption data $chartoptionvisit');
            data.add(
              BarChartModel(
                  answeroptions: chartoptionname[i],
                  visits: chartoptionvisit[i],
                  color: charts.Color.fromHex(code: barchartcolorcode[i])),
            );
          }
        }
        if (commentsuserid.contains(userid) == false &&
            expireTitle != "Expired:") {
          setState(() {
            print('Answer is false');
            displayanswerlist.clear();
            postanswerlist.clear();
            showoptions = true;
          });
        } else {
          setState(() {
            print('Answer is true');
            displayanswerlist.clear();
            postanswerlist.clear();
            showoptions = false;
          });
        }
      } else {
        QuestionComments questionComments =
            questionCommentsFromJson(response.body);

        List<QuestionComment> answerlistdetails =
            questionComments.questionComments;

        if (answerlistdetails.isEmpty) {
          setState(() {
            displayanswerlist.clear();
            postanswerlist.clear();
            isansweravailable = false;
          });
        } else {
          setState(() {
            displayanswerlist.clear();
            postanswerlist.clear();
            isansweravailable = true;
          });
        }

        var flag = 0;

        setState(() {
          String str = "";
          List<UserOption>? optionlist = questionComments.userOptions;
          print('Option list is');
          print(optionlist);
          if (optionlist == null) {
            flag = 1;
          } else {
            for (int i = 0; i < optionlist.length; i++) {
              if (i + 1 == optionlist.length) {
                str = str + optionlist[i].value.toString();
              } else {
                str = '$str${optionlist[i].value},';
              }
            }
            commentsuseranswer.add(str);
          }

          for (int i = 0; i < answerlistdetails.length; i++) {
            if (flag == 1) {
              commentsuseranswer.add(answerlistdetails[i].userOptions);
            }
            answerid.add(answerlistdetails[i].id);
            commentsuserisliked.add(answerlistdetails[i].isLike ?? "");
            commentsuserlikescount
                .add(answerlistdetails[i].likesCount.toString());
            commentsuserid.add(answerlistdetails[i].user.id);
            commentsusernamelist.add(answerlistdetails[i].displayName);
            commentsuserpostedtime.add(answerlistdetails[i].postedTime);
            commentsuserprofileimage
                .add(answerlistdetails[i].user.profileImageUrl ?? "");
            List<ChartDatum>? chartdatum = answerlistdetails[i].chartData;
            print('Helllloooo');
            if (commentsuserid.contains(userid) != true &&
                expireTitle != "Expired:") {
              print(commentsusernamelist);
              displayanswerlist.clear();
              postanswerlist.clear();
              showoptions = true;
              print('In condition if');
            } else {
              showoptions = false;
            }
            for (int j = 0; j < chartdatum!.length; j++) {
              chartoptionname.add(chartdatum[j].country);
              chartoptionvisit.add(chartdatum[j].visits);
            }
            if (chartoptionname.isNotEmpty) {
              print(chartoptionname);

              for (int i = 0; i < chartoptionname.length; i++) {
                print('In data');
                print('Char toption data $chartoptionvisit');
                data.add(
                  BarChartModel(
                    answeroptions: chartoptionname[i],
                    visits: chartoptionvisit[i],
                    color: charts.Color.fromHex(code: barchartcolorcode[i]),
                  ),
                );
              }
            }
          }
          if (commentsuserid.contains(userid) == false &&
              expireTitle != "Expired:") {
            setState(() {
              print('Answer is false');
              displayanswerlist.clear();
              postanswerlist.clear();
              showoptions = true;
            });
          } else {
            setState(() {
              print('Answer is true');
              displayanswerlist.clear();
              postanswerlist.clear();
              showoptions = false;
            });
          }
        });
      }
    }
  }

  showcharts() {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "",
          data: data,
          domainFn: (BarChartModel series, _) => series.answeroptions,
          measureFn: (BarChartModel series, _) => series.visits,
          colorFn: (BarChartModel series, _) => series.color)
    ];
    final List<DataItem> _myData = [];
    final List<String> label = [];
    for (int i = 0; i < data.length; i++) {
      _myData.add(
          DataItem(x: (i + 1), y: data[i].visits, item: data[i].answeroptions));
      label.add(data[i].answeroptions);
    }
    // final List<DataItem> _myData = List.generate(
    //     30,
    //     (index) => DataItem(
    //           x: index,
    //           y1: Random().nextInt(20) + Random().nextDouble(),
    //           y2: Random().nextInt(20) + Random().nextDouble(),
    //           y3: Random().nextInt(20) + Random().nextDouble(),
    //         ));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 1.2,
        child: fl.BarChart(fl.BarChartData(
            titlesData: fl.FlTitlesData(
                topTitles: fl.AxisTitles(
                  sideTitles: fl.SideTitles(showTitles: false),
                ),
                bottomTitles: fl.AxisTitles(
                  sideTitles: fl.SideTitles(
                    showTitles: true,
                    reservedSize: MediaQuery.of(context).size.width * 0.8,
                    getTitlesWidget: (value, meta) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.width * 0.23,
                        width: MediaQuery.of(context).size.width * 0.18,
                        child: Text(
                          _myData
                              .firstWhere(
                                  (element) => element.x == value.toInt())
                              .item,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                // bottomTitles: fl.AxisTitles(sideTitles: fl.SideTitles(
                //           showTitles: true,

                //           interval: 1,
                //           getTitlesWidget: (value) {
                //             ...
                //           },
                //         )),
                rightTitles: fl.AxisTitles(
                  sideTitles: fl.SideTitles(showTitles: false),
                )),
            borderData: fl.FlBorderData(
                border: const Border(
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide(width: 1),
              bottom: BorderSide(width: 1),
            )),
            groupsSpace: 10,
            gridData: fl.FlGridData(show: false),
            barGroups: _myData
                .map(
                    (dataItem) => fl.BarChartGroupData(x: dataItem.x, barRods: [
                          fl.BarChartRodData(
                              toY: double.parse(dataItem.y.toString()),
                              width: 15,
                              color: kBluePrimaryColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              )),
                        ]))
                .toList())),
      ),
    );
    // return Container(
    //   color: Colors.white,
    //   height: 450,
    //   width: MediaQuery.of(context).size.width * 0.9,
    //   child: SizedBox(
    //     height: 100,
    //     child: SfCartesianChart(
    //       series: <ChartSeries>[
    //         BarSeries<BarChartModel, String>(
    //             dataSource: data,
    //             xValueMapper: (BarChartModel modelData, _) =>
    //                 modelData.answeroptions,
    //             yValueMapper: (BarChartModel modelData, _) => modelData.visits)
    //       ],
    //       primaryXAxis: CategoryAxis(),
    //       // series,
    //       //   animate: true,
    //       //   //behaviors: [charts.SeriesLegend(desiredMaxColumns: 2)],
    //       //   domainAxis: charts.OrdinalAxisSpec(
    //       //     showAxisLine: true,
    //       //     renderSpec: const charts.SmallTickRendererSpec(labelRotation: 60),
    //       //     viewport: charts.OrdinalViewport('AePS', 3),
    //       //   )
    //     ),
    //   ),
    // );
  }

  void editanswer() async {
    var answer;
    var body;
    print(questionTypeId);
    var sendannonymously;
    if (postanonymously) {
      sendannonymously = sendoptionid;
    } else {
      sendannonymously = 0;
    }
    if (questionTypeId == "176c9480-1a9b-11eb-b17b-c85b767b9463") {
      print('Pick List');
      print(_groupValue);
      print('IDS');
      print(answeroptionsid);
      answer = answeroptionsid[_groupValue];
      print(answer);
      body = {
        "id": answerid[0],
        "question_id": questionid,
        "question_type_id": questionTypeId,
        "user_option_id": answer,
        "owner_role_id": questioncreatedby,
        "question_invitee_id": userid,
        "send_anonymously": sendannonymously,
        "owner_user_id": owneruserid
      };
      print(body);
    } else if (questionTypeId == "218a1492-1a9b-11eb-b17b-c85b767b9463") {
      print('Yes or No');
      if (_newValue == 0) {
        answer = true;
      } else {
        answer = false;
      }
      print(answer);
      body = {
        "id": answerid[0],
        "question_id": questionid,
        "question_type_id": questionTypeId,
        "is_true": answer,
        "owner_role_id": questioncreatedby,
        "question_invitee_id": userid,
        "send_anonymously": sendannonymously,
        "owner_user_id": owneruserid
      };

      print(body);
    } else if (questionTypeId == "1d5a0fb1-1a9b-11eb-b17b-c85b767b9463") {
      print('Multiselect');
      var answer = [];
      for (int i = 0; i < answeroptions.length; i++) {
        if (answercheckboxvalue[i]) {
          answer.add(answeroptionsid[i]);
        }
      }
      print(answer);
      body = {
        "id": answerid[0],
        "question_id": questionid,
        "question_type_id": questionTypeId,
        "user_option_id": answer,
        "owner_role_id": questioncreatedby,
        "question_invitee_id": userid,
        "send_anonymously": sendannonymously,
        "owner_user_id": owneruserid
      };
      print(body);
    } else if (questionTypeId == "3a536800-1a9b-11eb-b17b-c85b767b9463") {
      print('Express Yourself');
      answer = questioncontroller.text;
      print(answer);
      body = {
        "id": answerid[0],
        "question_id": questionid,
        "question_type_id": questionTypeId,
        "answer_text": answer.toString(),
        "owner_role_id": questioncreatedby,
        "question_invitee_id": userid,
        "send_anonymously": sendannonymously,
        "owner_user_id": owneruserid
      };
      print(body);
    } else if (questionTypeId == "295122ee-1a9b-11eb-b17b-c85b767b9463") {
      print('Ranked list');
      var answer = [];
      print(answeroptions);
      for (int i = 0; i < answeroptions.length; i++) {
        int index = tempansweroptions.indexOf(answeroptions[i]);
        print(index);
        answer.add(answeroptionsid[index]);
      }
      print(answer);
      body = {
        "id": answerid[0],
        "question_id": questionid,
        "question_type_id": questionTypeId,
        "user_option_id": answer,
        "owner_role_id": questioncreatedby,
        "question_invitee_id": userid,
        "send_anonymously": sendannonymously,
        "owner_user_id": owneruserid
      };
      print(body);
    }

    setState(() {
      displayanswerlist.clear();
      postanswerlist.clear();
      _enabled = true;
    });
    var response = await http.post(
        Uri.parse('$apiurl/questionDetail/editAnswer'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      displayanswerlist.clear();
      postanswerlist.clear();
      showoptions = false;
      showhideflag = false;
      showhidetext = "Show";
      _enabled = false;
      editoptions = false;
      _isInAsyncCall = true;
      cleardata();
      getuserdata();
    });

    if (response.statusCode == 200) {
      print('Answer Edited');
      print(response.body);
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  void postanswer() async {
    var answer;
    var body;
    var sendannonymously;

    if (userid == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('AnswerwithoutLogin',
          'Please login to post answer. Your answer will be saved.');
      prefs.setString('QuestionID', questionid);
      prefs.setString('QuestionTypeID', questionTypeId);
      if (questionTypeId == "176c9480-1a9b-11eb-b17b-c85b767b9463") {
        //PickList
        prefs.setString('AnswerValue', _groupValue.toString());
        print('In PickList');
      } else if (questionTypeId == "218a1492-1a9b-11eb-b17b-c85b767b9463") {
        //yesno
        prefs.setString('AnswerValue', _groupValue.toString());
        print('In YESno');
      } else if (questionTypeId == "1d5a0fb1-1a9b-11eb-b17b-c85b767b9463") {
        //multiselect
        var answer = [];
        for (int i = 0; i < answeroptions.length; i++) {
          if (answercheckboxvalue[i]) {
            answer.add(answeroptionsid[i]);
          }
        }
        prefs.setString('AnswerValue', answer.toString());
        print(prefs.getString('AnswerValue'));
        print('In Multiselect');
      } else if (questionTypeId == "3a536800-1a9b-11eb-b17b-c85b767b9463") {
        //expressyourself
        prefs.setString('AnswerValue', questioncontroller.text);
        print(questioncontroller.text);
        print('In Express');
        print(prefs.getString('AnswerValue'));
      } else if (questionTypeId == "295122ee-1a9b-11eb-b17b-c85b767b9463") {
        //rankedlist
        var answer = [];
        for (int i = 0; i < answeroptions.length; i++) {
          int index = tempansweroptions.indexOf(answeroptions[i]);
          print(index);
          answer.add(answeroptionsid[index]);
        }
        prefs.setString('AnswerValue', answer.toString());
        print('In RankedList');
      }
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      if (postanonymously) {
        sendannonymously = sendoptionid;
      } else {
        sendannonymously = 0;
      }
      if (questionTypeId == "176c9480-1a9b-11eb-b17b-c85b767b9463") {
        print('Pick List');
        answer = answeroptionsid[_groupValue];
        print(answer);
        body = {
          "question_id": questionid,
          "question_type_id": questionTypeId,
          "user_option_id": answer,
          "owner_role_id": questioncreatedby,
          "question_invitee_id": userid,
          "send_anonymously": sendannonymously,
          "owner_user_id": owneruserid
        };
        print(body);
      } else if (questionTypeId == "218a1492-1a9b-11eb-b17b-c85b767b9463") {
        print('Yes or No');
        if (_groupValue == 0) {
          answer = true;
        } else {
          answer = false;
        }
        print(answer);
        body = {
          "question_id": questionid,
          "question_type_id": questionTypeId,
          "is_true": answer,
          "owner_role_id": questioncreatedby,
          "question_invitee_id": userid,
          "send_anonymously": sendannonymously,
          "owner_user_id": owneruserid
        };

        print(body);
      } else if (questionTypeId == "1d5a0fb1-1a9b-11eb-b17b-c85b767b9463") {
        print('Multiselect');
        var answer = [];
        for (int i = 0; i < answeroptions.length; i++) {
          if (answercheckboxvalue[i]) {
            answer.add(answeroptionsid[i]);
          }
        }
        print(answer);
        body = {
          "question_id": questionid,
          "question_type_id": questionTypeId,
          "user_option_id": answer,
          "owner_role_id": questioncreatedby,
          "question_invitee_id": userid,
          "send_anonymously": sendannonymously,
          "owner_user_id": owneruserid
        };
        print(body);
      } else if (questionTypeId == "3a536800-1a9b-11eb-b17b-c85b767b9463") {
        print('Express Yourself');
        answer = questioncontroller.text;
        print(answer);
        print(userid);
        body = {
          "question_id": questionid,
          "question_type_id": questionTypeId,
          "answer_text": answer,
          "owner_role_id": questioncreatedby,
          "question_invitee_id": userid,
          "send_anonymously": sendannonymously,
          "owner_user_id": owneruserid
        };
        print(body);
      } else if (questionTypeId == "295122ee-1a9b-11eb-b17b-c85b767b9463") {
        print('Ranked list');
        var answer = [];
        print(answeroptions);
        for (int i = 0; i < answeroptions.length; i++) {
          int index = tempansweroptions.indexOf(answeroptions[i]);
          print(index);
          answer.add(answeroptionsid[index]);
        }
        print(answer);
        body = {
          "question_id": questionid,
          "question_type_id": questionTypeId,
          "user_option_id": answer,
          "owner_role_id": questioncreatedby,
          "question_invitee_id": userid,
          "send_anonymously": sendannonymously,
          "owner_user_id": owneruserid
        };
        print(body);
      }

      setState(() {
        displayanswerlist.clear();
        postanswerlist.clear();
        _enabled = true;
        _isInAsyncCall = true;
      });
      var response = await http.post(
          Uri.parse('$apiurl/questionDetail/addAnswer'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Authorization": header
          },
          encoding: Encoding.getByName("utf-8"));

      setState(() {
        displayanswerlist.clear();
        postanswerlist.clear();
        showoptions = false;
        showhideflag = false;
        _enabled = false;
        editoptions = false;
        _isInAsyncCall = true;
        cleardata();
        getuserdata();
      });

      if (response.statusCode == 200) {
        print('Answer Posted');
        print(response.body);
      } else {
        print(response.statusCode);
        print(response.body);
      }
    }
  }

  Widget showpiecharts() {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "Answer Options",
          data: data,
          domainFn: (BarChartModel series, _) => series.answeroptions,
          measureFn: (BarChartModel series, _) => series.visits),

      //labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
    ];

    print(data.length);
    print(series.length);
    print(series[0].data[0].answeroptions);
    print(series[0].data[1].answeroptions);
    print(series[0].data[0].visits);
    //print(series[0].data[1].visits);

    return SizedBox(
      height: 250,
      child: charts.PieChart<String>(series,
          animate: true,
          defaultRenderer:
              charts.ArcRendererConfig(arcWidth: 120, arcRendererDecorators: [
            // <-- add this to the code
            charts.ArcLabelDecorator() // <-- and this of course
          ])),
    );
  }

  Widget showfunnelchart() {
    return SfFunnelChart();
  }

  void cleardata() {
    answerid.clear();
    answeroptions.clear();
    tempansweroptions.clear();
    answeroptionsid.clear();
    chartoptionname.clear();
    chartoptionvisit.clear();
    postanswerlist.clear();
    displayanswerlist.clear();
    commentsusernamelist = [];
    commentsuserprofileimage.clear();
    commentsuseranswer.clear();
    commentsuserpostedtime.clear();
    commentsuserid.clear();
    community = "";
    communityidlist.clear();
    communitylist.clear();
    inviteecontroller.clear();
    inviteeslist.clear();
    inviteesdisplayname.clear();
    data.clear();
  }

  displaycommunities() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _enabled
            ? const SizedBox()
            : communitylist.isEmpty
                ? const SizedBox()
                : communitylist[0] == ""
                    ? const Icon(Icons.lock)
                    : Image.asset(
                        'images/Community.png',
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
        const SizedBox(
          width: 3,
        ),
        communitylist.isEmpty
            ? const SizedBox()
            : communitylist[0] == ""
                ? Text('Private',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.039))
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.06,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: communitylist.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
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
                              print(communityidlist[index]);
                              if (sharedsourcelist != null) {
                                sourcelist = sharedsourcelist;
                                searchlist = sharedsearchlist ?? [];
                              }
                              searchlist.add(communityidlist[index]);
                              sourcelist.add(6.toString());
                              prefs.setStringList(
                                  'communitysource', sourcelist);
                              prefs.setStringList('searchword', searchlist);
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => CommunityQuestion(
                                          communityidlist[index])));
                            },
                            child: Text(communitylist[index],
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.039)),
                          );
                        }),
                  )
      ],
    );
  }

  Future<File> _fileFromImageUrl() async {
    print('in funtion');
    final response = await http.get(Uri.parse(
        '$imageapiurl/question/92e879ba-d429-4fe4-8315-ff1e6bcc034f/1615271722440_1560351722.jpg'));

    Directory documentDirectory = await getApplicationDocumentsDirectory();

    //file = new File(join(documentDirectory.path, 'imagetest.png'));

    file.writeAsBytesSync(response.bodyBytes);
    print(response.statusCode);
    //file = File("https://api.decideit.devbyopeneyes.com/public/question/92e879ba-d429-4fe4-8315-ff1e6bcc034f/1615271722440_1560351722.jpg");
    print(file.path);
    return file;
  }

  showinvitees() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Image.asset(
            'images/new-user.png',
            height: MediaQuery.of(context).size.width * 0.05,
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              showinviteesdialog();
            },
            child: RichText(
              text: TextSpan(
                text: 'Show',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
                children: <TextSpan>[
                  TextSpan(
                      text: ' invitees ',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.05)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  validateemailphone() {
    errorflagsform = 0;
    if (inviteecontroller.text.isNotEmpty) {
      final split = inviteecontroller.text.split(',');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };

      print(values.length);
      print(numberofinvitation);
      if (values.length > numberofinvitation) {
        BlurryDialogSingle alert = BlurryDialogSingle(
            "Error", 'You can only invite $numberofinvitation');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return alert;
          },
        );
      } else {
        print('In else');
        for (int i = 0; i < values.length; i++) {
          String trimmedvalue = values[i]!.trim();
          if (_isNumeric(trimmedvalue) == true) {
            if (trimmedvalue.length < 10) {
              setState(() {
                print('Enter a valid number');
                errorflagcontacts = 2;
                errorflagsform = 1;
              });
            } else {
              print('Accepted');
              contactdetails.add(trimmedvalue);
              if (errorflagsform != 1) {
                errorflagsform = 0;
              }
            }
          } else {
            if (emailValidatorRegExp.hasMatch(trimmedvalue)) {
              print('Accepted');
              contactdetails.add(trimmedvalue);
              if (inviteeslist.contains(trimmedvalue)) {
                errorflagsform = 1;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'You have already invited some of these people. Please remove them from list'),
                ));
                break;
              }
              if (errorflagsform != 1) {
                errorflagsform = 0;
              }
            } else {
              setState(() {
                print('Not valid email');
                errorflagcontacts = 3;
                errorflagsform = 1;
                //contactstextfield.requestFocus();
              });
            }
          }
        }
        if (errorflagsform == 0) {
          print('here');
          setState(() {
            checkvalue = true;
          });
        } else {
          setState(() {
            checkvalue = false;
          });
        }
      }
    }
  }

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  void getplandata() async {
    var body;
    body = {
      "limit": 15,
      "offset": 1,
      "searchData": {"status": "", "searchQuery": ""},
      "searchQuery": "",
      "status": "",
      "sortOrder":
          "[{field: 'amount', dir: 'asc'}] 0: {field: 'amount', dir: 'asc'}",
      "dir": "asc",
      "field": "amount"
    };
    var response = await http.post(Uri.parse('$apiurl/plan/getAll'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      PlanData planData = planDataFromJson(response.body);
      List<Datum> data = planData.data;
      setState(() {
        for (int i = 0; i < data.length; i++) {
          if (planid == data[i].id) {
            print('Number of communities');
            print(data[i].numberOfCommunities);
            numberofprivateinvitation = data[i].numberOfInvitations;
            numberofcommunityinvitation =
                data[i].communityQuestionNumberOfInvitations;
          }
        }
        print(numberofprivateinvitation);
        print(numberofcommunityinvitation);
      });
    }
  }

  displayinvitename() {
    if (inviteeslist.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Invited People',
                style: TextStyle(
                    fontSize: 16,
                    color: kBluePrimaryColor,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            for (var i in inviteeslist)
              Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 8.0,
                          width: 8.0,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 4),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              i.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    inviteduserid[inviteeslist.indexOf(i.toString())] != userid
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                                '(Invited by ${inviteesdisplayname[inviteeslist.indexOf(i.toString())]})',
                                style: const TextStyle(fontSize: 16)),
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                  ])
            /*Container(
              height: 20,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: inviteeslist.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(inviteeslist[index]),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            owneruserid != userid
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                          'Invited by ' +
                                              inviteesdisplayname[index],
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                  )
                                : new SizedBox()
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  }),
            ),*/
          ],
        ),
      );
    } else {
      return const Text('No invitations sent.');
    }
  }

  void addcontacts() async {
    print('In API call');
    String contacttojson = contactdeatilsToJson(contactdetails);
    var contactbody = {
      "question_text": questionText,
      "is_private": communitylist[0] == "" ? "1" : "0",
      "question_id": questionid,
      "owner_id": owneruserid,
      "name": userName,
      "question_status_id": "07e20fda-233a-11eb-b17b-c85b767b9463",
      "contact_details": contacttojson
    };

    setState(() {
      Navigator.pop(context);
      _enabled = true;
    });
    var contactresponse = await http.post(
        Uri.parse('$apiurl/question/addMoreInvitees'),
        body: json.encode(contactbody),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (contactresponse.statusCode == 200) {
      print(contactresponse.body);
      MoreInvitationsApi moreInvitationsApi =
          moreInvitationsApiFromJson(contactresponse.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(moreInvitationsApi.message),
      ));
      setState(() {
        cleardata();
        getuserdata();
      });
    } else {
      print(contactresponse.statusCode);
      print(contactresponse.body);
      MoreInvitationsApi moreInvitationsApi =
          moreInvitationsApiFromJson(contactresponse.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(moreInvitationsApi.message),
      ));
    }
  }

  displayaddinvitees() {
    return Form(
      key: _inviteeformKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Invite More People',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                focusNode: contactstextfield,
                controller: inviteecontroller,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(error: 'Please enter contacts');
                  } else if (errorflagcontacts != 3) {
                    removeError(error: 'Please enter a valid email address');
                  } else if (errorflagcontacts != 2) {
                    removeError(error: 'Please enter a valid phone number');
                  }
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    contactstextfield.requestFocus();
                    return 'Please enter contacts';
                    //addError(error: kNamelNullError);
                  } else if (errorflagcontacts == 3) {
                    print('In here');
                    return 'Please enter a valid email address';
                  } else if (errorflagcontacts == 2) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                maxLines: 5,
                minLines: 1,
                decoration: const InputDecoration(
                    hintText:
                        'Enter email addresses or telephone numbers separated by commas (Example : bestfriend@url.com, 123-321-4565, sister@xyz.com)',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ))),
          ),
          Center(
            child: RaisedButton(
              color: kBluePrimaryColor,
              onPressed: () {
                if (_inviteeformKey.currentState!.validate()) {
                  _inviteeformKey.currentState!.save();
                  // if all are valid then go to success screen
                  validateemailphone();
                  if (checkvalue) {
                    addcontacts();
                  }
                }
              },
              child: const Text(
                'ADD',
                style: TextStyle(color: kBackgroundColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showinviteesdialog() {
    numberofcommunityinvitation -= inviteeslist.length;
    numberofprivateinvitation -= inviteeslist.length;
    if (communitylist[0] == "") {
      numberofinvitation = numberofprivateinvitation;
    } else {
      numberofinvitation = numberofcommunityinvitation;
    }
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close)),
              ),
              const Text(
                'INVITATIONS',
                style: TextStyle(
                    color: kBluePrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                expireTitle != "Expired:" && numberofinvitation != 0
                    ? owneruserid == userid
                        ? displayaddinvitees()
                        : inviteecaninviteothers != "0"
                            ? displayaddinvitees()
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'You can not send more invitations for this question.',
                                  style: TextStyle(fontSize: 14),
                                ),
                              )
                    : const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'You can not send more invitations for this question.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                inviteesonlytome != "0"
                    ? owneruserid == userid
                        ? displayinvitename()
                        : const SizedBox()
                    : displayinvitename(),
                /*Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i in inviteeslist)
                      Text('This is listview' + i.toString())
                  ],
                ),*/
              ],
            ),
          ),
        ));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return alert;
      },
    );
  }

  showImage(int index) {
    return commentsuserprofileimage[index].isEmpty
        ? const AssetImage('images/user.jpg')
        : NetworkImage('$imageapiurl/${commentsuserprofileimage[index]}');
  }
}

class DataItem {
  int x;
  int y;
  String item;

  DataItem({required this.x, required this.y, required this.item});
}
