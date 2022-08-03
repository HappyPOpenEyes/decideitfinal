import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:chewie/chewie.dart';
import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/Home/Drawer.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/Plans/PlanDataAPI.dart';
import 'package:decideitfinal/PostQuestion/AnswerFormatJSON.dart';
import 'package:decideitfinal/PostQuestion/DraftQuestionAPI.dart';
import 'package:decideitfinal/PostQuestion/PostOptions.dart';
import 'package:decideitfinal/PostQuestion/PostQuestionImageResponse.dart';
import 'package:decideitfinal/ProfileScreens/PersonalProfile.dart';
import 'package:decideitfinal/SearchTextProvider.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/logindialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import '../DropdownBloc.dart';
import '../DropdownContainer.dart';
import '../ExpandedAnimation.dart';
import '../IssuingAuthorityErrorBloc.dart';
import '../Scrollbar.dart';
import '../TextBoxLabel.dart';
import '../constants.dart';
import 'ContactDetails.dart';
import 'Groupdata.dart';
import 'InvalidGroupNameAPI.dart';
import 'PostQuestionAPIResponse.dart';
import 'package:path/path.dart' as p;

class PostQuestion extends StatefulWidget {
  @override
  _PostQuestionState createState() => _PostQuestionState();
}

class _PostQuestionState extends State<PostQuestion>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  //constructor variables
  var name, imageurl, header, planid;
  String? email;
  String? userid;
  //bottomnavigation index
  int selectedIndex = 1;
  final List<String> errors = [];
  TextEditingController _searchcontroller = TextEditingController();
  bool isVisible = true;
  //answer format list declaration
  List<String> answerformatlist = ["Select your answer format"];
  List<String> questiontypeid = [];
  List<String> communityid = [];
  //text editing controllers for question,contacts and selected communities
  TextEditingController questioncontroller = TextEditingController();
  TextEditingController emailaddressfield = TextEditingController();
  TextEditingController selectedcommunityfield = TextEditingController();
  //answercounter for which answer format is chosen
  int answercounter = 0;
  //list for how many options are to be used
  List<int> optioncount = [1, 2];
  int optioncounter = 2;
  //list of widgets
  List<Widget> list = [];
  List<Widget> optionlist = [];
  bool _enabled = true;
  bool expansionstep1 = true;
  bool expansionstep2 = false;
  bool expansionstep3 = false;
  int tempanswercount = 0;
  List<Color> stepcolor = [
    kBackgroundColor,
    kBackgroundColor,
    kBackgroundColor
  ];
  List<Color> textcolor = [Colors.black, Colors.black, Colors.black];
  bool multipleselectionflag = false;
  bool _allowmultipleselection = false;
  late int _selectedsendoption;
  int _groupValue = 0;
  var question, usercontacts;
  List<String> useroptions = [];
  List<String> tempuseroptions = [];
  List<TextEditingController> _optionscontroller = [];
  CroppedFile? _pickedImage;
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  File? videoFile;
  final _formKey = GlobalKey<FormState>();
  List<String> communityname = [];
  List<Categories> categories = [];
  List<Categories> tempcategories = [];
  List<ItemClass> communitytype = [];
  String _dropdownError = "";
  List<String> sendoptionsidlist = [];
  List<bool> sendoptionslist = [
    false,
    false,
    false,
  ];
  late String selectedcommunity;
  FocusNode questiontextfield = FocusNode();
  FocusNode communitydropdownfield = FocusNode();
  FocusNode searchablefocus = FocusNode();
  List<FocusNode> optiontextfield = [];
  FocusNode contactstextfield = FocusNode();
  Categories? dropdownvalue;
  final List<DropdownMenuItem> dropdownitems = [];
  var errormessagecontacts = "";
  var errorflagcontacts = 0;
  var errorflagsform = 0;
  String postquestion_status_id = "07e20fda-233a-11eb-b17b-c85b767b9463";
  var multipleselectionid;
  List<String> contactdetails = [];
  int postordraftquestionflag = 0;
  List<String> groups = ["Choose existing group"];
  List<String> groupidlist = [];
  int groupcounter = 0;
  List<String> contactgrouplist = [];
  List<String> answeroptions = [];
  String blurrydialoggroupname = "";
  TextEditingController groupcontroller = TextEditingController();
  late String groupvalue;
  List<String> selectedcommunitieslist = [];
  List<String> selectedcommunitiesidlist = [];
  int numberofcommunitiesplan = 1;
  bool _isDraft = false;
  late String draftquestionname, draftquestionid = "";
  List<String> draftcommunities = [];
  late Timer _timer;
  bool postanonymously = false;
  late int isprofileprivate;
  late int numberofprivateinvitation = 0;
  late int numberofcommunityinvitation = 0;
  AppBar appbar = AppBar();
  List<String> communityemails = [];
  bool showcommunityoption = false;
  String? imageVideoUrl, questionId, fileExtension;
  List<String> providedvideoextensions = [];
  List<String> providedimageextensions = [];
  bool showcheckicon = false;
  final _showDropDownBloc = IndosNoBloc();
  final _errorCommunityBloc = ResumeErrorIssuingAuthorityBloc();
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
    answercounter = tempanswercount;
    for (int i = 0; i < 6; i++) {
      _optionscontroller.add(TextEditingController());
    }
    for (int i = 0; i < 6; i++) {
      optiontextfield.add(FocusNode());
    }
    cleardata();
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
    _showDropDownBloc.dispose();
    _errorCommunityBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
            height: appbar.preferredSize.height * 0.8,
            child: Image.asset('logos/DI_Logo.png')),
        centerTitle: true,
        backgroundColor: kBluePrimaryColor,
        leading: GestureDetector(
          onTap: () {
            _scaffoldkey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //height: MediaQuery.of(context).size.height * 0.012,
              //width: MediaQuery.of(context).size.width * 0.006,
              child: Image.asset(
                'images/menu.png',
                color: kBackgroundColor,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(child: SideBar()),
      bottomNavigationBar: getbottomnavigation(),
      body: Stack(
        children: [
          ModalProgressHUD(
            inAsyncCall: _enabled,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: const CircularProgressIndicator(),
            child: GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Post ',
                              style: TextStyle(
                                  color: kBluePrimaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Question',
                                    style: TextStyle(
                                        color: kOrangePrimaryColor,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ExpansionTile(
                          onExpansionChanged: removespoce,
                          initiallyExpanded: expansionstep1,
                          title: Row(
                            children: [
                              RawMaterialButton(
                                onPressed: () {},
                                elevation: 2.0,
                                fillColor: stepcolor[0],
                                padding: const EdgeInsets.all(15.0),
                                shape: const CircleBorder(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Step',
                                      style: TextStyle(
                                          color: textcolor[0],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('1',
                                        style: TextStyle(
                                            color: textcolor[0],
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                              const Text('Question',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            buildenterquestionfield(),
                            const SizedBox(
                              height: 5,
                            ),
                            buildchooseimagevideofield(),
                            const SizedBox(
                              height: 10,
                            ),
                            _pickedImage == null
                                ? imageVideoUrl != null
                                    ? providedimageextensions
                                            .contains(fileExtension)
                                        ? Image.network(
                                            '$imageapiurl/question/${questionId!}/${imageVideoUrl!}')
                                        : const SizedBox()
                                    : const SizedBox()
                                : Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.12,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 8,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: showImage(),
                                        )),
                                  ),
                            videoFile == null
                                ? imageVideoUrl != null
                                    ? providedvideoextensions.contains(
                                            fileExtension!.toLowerCase())
                                        ? chewieController != null
                                            ? Container(
                                                height: 240,
                                                child: Chewie(
                                                  controller: chewieController!,
                                                ),
                                              )
                                            : Container()
                                        : const SizedBox()
                                    : const SizedBox()
                                : chewieController != null
                                    ? Container(
                                        height: 240,
                                        child: Chewie(
                                          controller: chewieController!,
                                        ),
                                      )
                                    : Container(),
                            // Visibility(
                            //     visible: _controller != null,
                            //     child: FutureBuilder(
                            //       future:
                            //           _initializeVideoPlayerFuture,
                            //       builder: (context, snapshot) {
                            //         if (snapshot.connectionState ==
                            //             ConnectionState.done) {
                            //           // If the VideoPlayerController has finished initialization, use
                            //           // the data it provides to limit the aspect ratio of the video.
                            //           return AspectRatio(
                            //             aspectRatio: _controller!
                            //                 .value.aspectRatio,
                            //             // Use the VideoPlayer widget to display the video.
                            //             child: GestureDetector(
                            //                 child: Stack(
                            //               alignment:
                            //                   Alignment.bottomCenter,
                            //               children: [
                            //                 VideoPlayer(_controller!),
                            //                 const ClosedCaption(
                            //                     text: null),
                            //                 GestureDetector(
                            //                   onTap: () {
                            //                     setState(() {
                            //                       // If the video is playing, pause it.
                            //                       if (_controller!
                            //                           .value
                            //                           .isPlaying) {
                            //                         _controller!
                            //                             .pause();
                            //                       } else {
                            //                         // If the video is paused, play it.
                            //                         _controller!
                            //                             .play();
                            //                       }
                            //                     });
                            //                   },
                            //                   child: Icon(
                            //                     _controller!.value
                            //                             .isPlaying
                            //                         ? Icons.pause
                            //                         : Icons
                            //                             .play_arrow,
                            //                   ),
                            //                 ),
                            //                 const SizedBox(
                            //                   height: 2,
                            //                 ),
                            //                 VideoProgressIndicator(
                            //                   _controller!,
                            //                   allowScrubbing: true,
                            //                   padding:
                            //                       const EdgeInsets
                            //                           .all(3),
                            //                   colors: VideoProgressColors(
                            //                       playedColor: Theme
                            //                               .of(context)
                            //                           .primaryColor),
                            //                 ),
                            //               ],
                            //             )),
                            //           );
                            //         } else {
                            //           // If the VideoPlayerController is still initializing, show a
                            //           // loading spinner.
                            //           return const Center(
                            //               child:
                            //                   CircularProgressIndicator());
                            //         }
                            //       },
                            //     ),
                            //   )
                            // : const SizedBox()

                            //   Visibility(
                            //             visible: _controller != null,
                            //             child: FutureBuilder(
                            //               future: _initializeVideoPlayerFuture,
                            //               builder: (context, snapshot) {
                            //                 if (snapshot.connectionState ==
                            //                     ConnectionState.done) {
                            //                   // If the VideoPlayerController has finished initialization, use
                            //                   // the data it provides to limit the aspect ratio of the video.
                            //                   return AspectRatio(
                            //                     aspectRatio:
                            //                         _controller!.value.aspectRatio,
                            //                     // Use the VideoPlayer widget to display the video.
                            //                     child: GestureDetector(
                            //                         child: Stack(
                            //                       alignment: Alignment.bottomCenter,
                            //                       children: [
                            //                         VideoPlayer(_controller!),
                            //                         const ClosedCaption(text: null),
                            //                         GestureDetector(
                            //                           onTap: () {
                            //                             setState(() {
                            //                               // If the video is playing, pause it.
                            //                               if (_controller!
                            //                                   .value.isPlaying) {
                            //                                 _controller!.pause();
                            //                               } else {
                            //                                 // If the video is paused, play it.
                            //                                 _controller!.play();
                            //                               }
                            //                             });
                            //                           },
                            //                           child: Icon(
                            //                             _controller!.value.isPlaying
                            //                                 ? Icons.pause
                            //                                 : Icons.play_arrow,
                            //                           ),
                            //                         ),
                            //                         const SizedBox(
                            //                           height: 2,
                            //                         ),
                            //                         VideoProgressIndicator(
                            //                           _controller!,
                            //                           allowScrubbing: true,
                            //                           padding:
                            //                               const EdgeInsets.all(3),
                            //                           colors: VideoProgressColors(
                            //                               playedColor:
                            //                                   Theme.of(context)
                            //                                       .primaryColor),
                            //                         ),
                            //                       ],
                            //                     )),
                            //                   );
                            //                 } else {
                            //                   // If the VideoPlayerController is still initializing, show a
                            //                   // loading spinner.
                            //                   return const Center(
                            //                       child: CircularProgressIndicator());
                            //                 }
                            //               },
                            //             ),
                            //           ),
                            //   ],
                            // ),
                            ExpansionTile(
                              onExpansionChanged: removespoce,
                              initiallyExpanded: expansionstep2,
                              title: Row(
                                children: [
                                  RawMaterialButton(
                                    onPressed: () {},
                                    elevation: 2.0,
                                    fillColor: stepcolor[1],
                                    padding: const EdgeInsets.all(15.0),
                                    shape: const CircleBorder(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Step',
                                          style: TextStyle(
                                              color: textcolor[1],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('2',
                                            style: TextStyle(
                                                color: textcolor[1],
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                  const Text('Answer Format',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                buildentoptionlistfield(),
                                const SizedBox(
                                  height: 10,
                                ),
                                _enabled
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.black12,
                                        highlightColor: Colors.white10,
                                        enabled: _enabled,
                                        child: Container(
                                          child: const Text('Loading...'),
                                        ))
                                    : buildanswerlistfield(
                                        answerformatlist[answercounter]),
                                _allowmultipleselection
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Theme(
                                            data: ThemeData(),
                                            child: Checkbox(
                                              value: multipleselectionflag,
                                              checkColor: kBluePrimaryColor,
                                              activeColor: kBackgroundColor,
                                              onChanged: (value) {
                                                setState(() {
                                                  optionlist.clear();
                                                  list.clear();
                                                  optionlist = [];
                                                  list = [];
                                                  multipleselectionflag =
                                                      value!;
                                                });
                                              },
                                            ),
                                          ),
                                          const Text(
                                            'Allow multiple selection',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'OpenSans',
                                            ),
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                _dropdownError.isEmpty
                                    ? const SizedBox.shrink()
                                    : Text(
                                        _dropdownError,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                              ],
                            ),
                            ExpansionTile(
                              onExpansionChanged: removespoce,
                              initiallyExpanded: expansionstep3,
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              childrenPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              title: Row(
                                children: [
                                  RawMaterialButton(
                                    onPressed: () {},
                                    elevation: 2.0,
                                    fillColor: stepcolor[2],
                                    padding: const EdgeInsets.all(15.0),
                                    shape: const CircleBorder(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Step',
                                          style: TextStyle(
                                              color: textcolor[2],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('3',
                                            style: TextStyle(
                                                color: textcolor[2],
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                  const Text('Send To & Options',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))
                                ],
                              ),
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Who would you like to send this?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                groups.isEmpty
                                    ? const SizedBox()
                                    : userid == null
                                        ? const SizedBox()
                                        : displaygroups(),
                                const SizedBox(
                                  height: 5,
                                ),
                                buildentersendfield(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: RaisedButton(
                                      //padding: EdgeInsets.only(left: 8.0),
                                      onPressed: () {
                                        showgroupdialog();
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: const Text('Save As Group'),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'More Send Options',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Wrap(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Theme(
                                        data: ThemeData(),
                                        child: Checkbox(
                                          value: sendoptionslist[0],
                                          checkColor: kBluePrimaryColor,
                                          activeColor: kBackgroundColor,
                                          onChanged: (value) {
                                            setState(() {
                                              optionlist.clear();
                                              list.clear();
                                              optionlist = [];
                                              list = [];
                                              sendoptionslist[0] =
                                                  value ?? false;
                                              print(value);
                                              print(sendoptionslist);
                                            });
                                          },
                                        ),
                                      ),
                                      const Text(
                                        'Show invitee list only to me',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Theme(
                                        data: ThemeData(),
                                        child: Checkbox(
                                          value: sendoptionslist[1],
                                          checkColor: kBluePrimaryColor,
                                          activeColor: kBackgroundColor,
                                          onChanged: (value) {
                                            setState(() {
                                              optionlist.clear();
                                              list.clear();
                                              optionlist = [];
                                              list = [];
                                              sendoptionslist[1] =
                                                  value ?? false;
                                              print(value);
                                              print(sendoptionslist);
                                            });
                                          },
                                        ),
                                      ),
                                      const Text(
                                        'Show results only to me',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Theme(
                                        data: ThemeData(),
                                        child: Checkbox(
                                          value: sendoptionslist[2],
                                          checkColor: kBluePrimaryColor,
                                          activeColor: kBackgroundColor,
                                          onChanged: (value) {
                                            setState(() {
                                              optionlist.clear();
                                              list.clear();
                                              optionlist = [];
                                              list = [];
                                              sendoptionslist[2] =
                                                  value ?? false;
                                              print(value);
                                              print(sendoptionslist);
                                            });
                                          },
                                        ),
                                      ),
                                      const Text(
                                        'Recipients can invite others',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Post as Private question or select a Community',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            buildchooseprivateorcommunityfield(),
                            _groupValue == 0
                                ? const SizedBox()
                                : displaycommunities(),
                            selectedcommunitieslist.isEmpty
                                ? const SizedBox()
                                : displayselectedcommunities(),
                            _groupValue == 0
                                ? const SizedBox()
                                : displaypostanonymouslyoption(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    errorflagsform = 0;
                                    print('Communities Length: ');
                                    print(selectedcommunitieslist.length);
                                    if (emailaddressfield.text.isNotEmpty) {
                                      final split =
                                          emailaddressfield.text.split(',');
                                      final Map<int, String> values = {
                                        for (int i = 0; i < split.length; i++)
                                          i: split[i]
                                      };

                                      print(values.length);
                                      bool duplicateflag = false;
                                      print(values);
                                      print('Emails are');
                                      for (int i = 0; i < values.length; i++) {
                                        print(values[i]);
                                        for (int j = i + 1;
                                            j < values.length;
                                            j++) {
                                          if (values[i] == values[j]) {
                                            duplicateflag = true;
                                          }
                                        }
                                      }

                                      if (duplicateflag) {
                                        errorflagsform = 1;
                                        BlurryDialogSingle alert =
                                            BlurryDialogSingle("Error",
                                                'You have one or more duplicate email or phone numbers in invitations. Please remove duplicate email or phone.');
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            var height = MediaQuery.of(context)
                                                .size
                                                .height;
                                            var width = MediaQuery.of(context)
                                                .size
                                                .width;
                                            return alert;
                                          },
                                        );
                                      }
                                      if (_groupValue == 0) {
                                        if (values.length >
                                            numberofprivateinvitation) {
                                          BlurryDialogSingle alert =
                                              BlurryDialogSingle("Error",
                                                  'Your invitation limit for private question is $numberofprivateinvitation');
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              var height =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height;
                                              var width = MediaQuery.of(context)
                                                  .size
                                                  .width;
                                              return alert;
                                            },
                                          );
                                        }
                                      } else {
                                        if (values.length >
                                            numberofcommunityinvitation) {
                                          BlurryDialogSingle alert =
                                              BlurryDialogSingle("Error",
                                                  'Your invitation limit for community question is $numberofcommunityinvitation');
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              var height =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height;
                                              var width = MediaQuery.of(context)
                                                  .size
                                                  .width;
                                              return alert;
                                            },
                                          );
                                        }
                                      }
                                      for (int i = 0; i < values.length; i++) {
                                        String trimmedvalue = values[i]!.trim();
                                        if (_isNumeric(trimmedvalue) == true) {
                                          if (trimmedvalue.length < 10) {
                                            setState(() {
                                              optionlist.clear();
                                              list.clear();
                                              optionlist = [];
                                              list = [];
                                              print('Enter a valid number');
                                              errorflagcontacts = 2;
                                              errorflagsform = 1;
                                              errormessagecontacts =
                                                  'Enter a valid phone number';
                                              contactstextfield.requestFocus();
                                            });
                                          } else {
                                            print('Accepted');
                                            if (errorflagsform != 1) {
                                              errorflagsform = 0;
                                            }
                                            contactdetails.add(trimmedvalue);
                                          }
                                        } else {
                                          if (emailValidatorRegExp
                                              .hasMatch(trimmedvalue)) {
                                            print('Accepted');
                                            if (errorflagsform != 1) {
                                              errorflagsform = 0;
                                            }
                                            contactdetails.add(trimmedvalue);
                                          } else {
                                            setState(() {
                                              optionlist.clear();
                                              list.clear();
                                              optionlist = [];
                                              list = [];
                                              print('Not valid email');
                                              errorflagcontacts = 3;
                                              errorflagsform = 1;
                                              errormessagecontacts =
                                                  'Enter a valid email address';
                                              contactstextfield.requestFocus();
                                            });
                                          }
                                        }
                                      }
                                    }

                                    if (questioncontroller.text.isEmpty) {
                                      BlurryDialogSingle alert =
                                          BlurryDialogSingle("Error",
                                              'Please enter the question!');
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          var height = MediaQuery.of(context)
                                              .size
                                              .height;
                                          var width =
                                              MediaQuery.of(context).size.width;
                                          return alert;
                                        },
                                      );
                                    } else {
                                      if (errorflagsform == 0) {
                                        print('Inside if');
                                        //_formKey.currentState.save();
                                        postordraftquestionflag = 0;
                                        if (_isDraft) {
                                          postdraftquestion();
                                        } else {
                                          postquestion();
                                        }
                                      } else {
                                        print('In else');
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          const BorderSide(color: Colors.grey)),
                                  child: const Text('Save Draft'),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                RaisedButton(
                                    onPressed: () {
                                      errorflagsform = 0;
                                      print('Communities Length: ');
                                      print(selectedcommunitieslist.length);
                                      if (emailaddressfield.text.isNotEmpty) {
                                        final split =
                                            emailaddressfield.text.split(',');
                                        final Map<int, String> values = {
                                          for (int i = 0; i < split.length; i++)
                                            i: split[i]
                                        };

                                        print(values.length);
                                        bool duplicateflag = false;
                                        print('Emails are:');
                                        print(duplicateflag);
                                        for (int i = 0;
                                            i < values.length;
                                            i++) {
                                          print(values[i]);
                                          for (int j = i + 1;
                                              j < values.length;
                                              j++) {
                                            if (values[i] == values[j]) {
                                              print(i);
                                              duplicateflag = true;
                                            }
                                          }
                                        }

                                        if (duplicateflag) {
                                          errorflagsform = 1;
                                          BlurryDialogSingle alert =
                                              BlurryDialogSingle("Error",
                                                  'You have one or more duplicate email or phone numbers in invitations. Please remove duplicate email or phone.');
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              var height =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height;
                                              var width = MediaQuery.of(context)
                                                  .size
                                                  .width;
                                              return alert;
                                            },
                                          );
                                        }
                                        if (_groupValue == 0) {
                                          if (values.length >
                                              numberofprivateinvitation) {
                                            BlurryDialogSingle alert =
                                                BlurryDialogSingle("Error",
                                                    'Your invitation limit for private question is $numberofprivateinvitation');
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                var height =
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height;
                                                var width =
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width;
                                                return alert;
                                              },
                                            );
                                          }
                                        } else {
                                          if (values.length >
                                              numberofcommunityinvitation) {
                                            BlurryDialogSingle alert =
                                                BlurryDialogSingle("Error",
                                                    'Your invitation limit for community question is $numberofcommunityinvitation');
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                var height =
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height;
                                                var width =
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width;
                                                return alert;
                                              },
                                            );
                                          }
                                        }
                                        for (int i = 0;
                                            i < values.length;
                                            i++) {
                                          String trimmedvalue =
                                              values[i]!.trim();
                                          if (_isNumeric(trimmedvalue) ==
                                              true) {
                                            if (trimmedvalue.length < 10) {
                                              setState(() {
                                                optionlist.clear();
                                                list.clear();
                                                optionlist = [];
                                                list = [];
                                                print('Enter a valid number');
                                                errorflagcontacts = 2;
                                                errorflagsform = 1;
                                                errormessagecontacts =
                                                    'Enter a valid phone number';
                                                contactstextfield
                                                    .requestFocus();
                                              });
                                            } else {
                                              print('Accepted');
                                              if (errorflagsform != 1) {
                                                errorflagsform = 0;
                                              }
                                              contactdetails.add(trimmedvalue);
                                            }
                                          } else {
                                            if (emailValidatorRegExp
                                                .hasMatch(trimmedvalue)) {
                                              print('Accepted');
                                              if (errorflagsform != 1) {
                                                errorflagsform = 0;
                                                errorflagcontacts = 0;
                                              }
                                              contactdetails.add(trimmedvalue);
                                            } else {
                                              setState(() {
                                                optionlist.clear();
                                                list.clear();
                                                optionlist = [];
                                                list = [];
                                                print('Not valid email');
                                                errorflagcontacts = 3;
                                                errorflagsform = 1;
                                                errormessagecontacts =
                                                    'Enter a valid email address';
                                                contactstextfield
                                                    .requestFocus();
                                              });
                                            }
                                          }
                                        }
                                      }

                                      if (answerformatlist[answercounter] ==
                                          answerformatlist[0]) {
                                        print('in answerformat');
                                        setState(() {
                                          optionlist.clear();
                                          list.clear();
                                          optionlist = [];
                                          list = [];
                                          errorflagsform = 1;
                                          _dropdownError =
                                              "Please select an answer format";
                                          expansionstep1 = true;
                                          expansionstep2 = true;
                                          expansionstep3 = true;
                                        });
                                      } else {
                                        if (errorflagsform != 1) {
                                          errorflagsform = 0;
                                        }
                                      }

                                      if (_formKey.currentState!.validate()) {
                                        print('All steps corect');
                                        if (stepcolor
                                            .contains(kBackgroundColor)) {
                                          if (_groupValue == 0 &&
                                              stepcolor[2] ==
                                                  kBackgroundColor) {
                                            if (stepcolor[1] ==
                                                kBackgroundColor) {
                                              setState(() {
                                                optionlist.clear();
                                                list.clear();
                                                optionlist = [];
                                                list = [];
                                                expansionstep1 = true;
                                                expansionstep2 = true;
                                                expansionstep3 = true;
                                              });
                                              errorflagsform = 1;
                                              BlurryDialogSingle alert =
                                                  BlurryDialogSingle("Error",
                                                      'Please complete all the steps!');
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  var height =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height;
                                                  var width =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width;
                                                  return alert;
                                                },
                                              );
                                            } else if (questioncontroller
                                                .text.isEmpty) {
                                              setState(() {
                                                optionlist.clear();
                                                list.clear();
                                                optionlist = [];
                                                list = [];
                                                expansionstep1 = true;
                                                expansionstep2 = true;
                                                expansionstep3 = true;
                                              });
                                              errorflagsform = 1;
                                              BlurryDialogSingle alert =
                                                  BlurryDialogSingle("Error",
                                                      'Please complete all the steps!');
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  var height =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height;
                                                  var width =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width;
                                                  return alert;
                                                },
                                              );
                                            } else {
                                              setState(() {
                                                optionlist.clear();
                                                list.clear();
                                                optionlist = [];
                                                list = [];
                                                expansionstep1 = true;
                                                expansionstep2 = true;
                                                expansionstep3 = true;
                                              });
                                              errorflagsform = 1;
                                              BlurryDialogSingle alert =
                                                  BlurryDialogSingle("Error",
                                                      'Please complete all the steps!');
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  var height =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .height;
                                                  var width =
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width;
                                                  return alert;
                                                },
                                              );
                                            }
                                          }
                                        } else {
                                          if (errorflagsform != 1) {
                                            errorflagsform = 0;
                                          }
                                        }

                                        if (_groupValue == 1 &&
                                            selectedcommunitieslist.isEmpty) {
                                          errorflagsform = 1;
                                          setState(() {
                                            optionlist.clear();
                                            list.clear();
                                            optionlist = [];
                                            list = [];
                                            searchablefocus.requestFocus();
                                          });

                                          print('Communities Length: ');
                                          print('Dropdown error');

                                          print(selectedcommunitieslist.length);
                                          BlurryDialogSingle alert =
                                              BlurryDialogSingle("Error",
                                                  'Please choose the community');
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              var height =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height;
                                              var width = MediaQuery.of(context)
                                                  .size
                                                  .width;
                                              return alert;
                                            },
                                          );
                                        } else {
                                          if (errorflagsform != 1) {
                                            errorflagsform = 0;
                                          }
                                        }

                                        if (errorflagsform == 0) {
                                          print('Inside if');
                                          _formKey.currentState!.save();
                                          postordraftquestionflag = 1;
                                          if (_isDraft) {
                                            postdraftquestion();
                                          } else {
                                            postquestion();
                                          }
                                        } else {
                                          print('In else');
                                        }
                                      }

                                      // if all are valid then go to success screen

                                      //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                                    },
                                    color: kBluePrimaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: const BorderSide(
                                            color: kBluePrimaryColor)),
                                    child: const Text(
                                      'Post',
                                      style: TextStyle(color: kBackgroundColor),
                                    )),
                              ],
                            )
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
          showcheckicon
              ? Center(
                  child: FadeInImage.assetNetwork(
                  placeholder: 'images/transparent.png',
                  image: '$imageapiurl/app-icons/checked.png',
                  height: MediaQuery.of(context).size.height * 0.2,
                ))
              : const SizedBox(),
        ],
      ),
    );
  }

  showImage() {
    return _pickedImage == null
        ? const SizedBox()
        : FileImage(File(_pickedImage!.path));
  }

  getbottomnavigation() {
    return BottomNavyBar(
      showElevation: true,
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        setState(() {
          selectedIndex = index;

          if (selectedIndex == 3) {
            if (userid == null) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PersonalProfile()));
            }
          } else if (selectedIndex == 2) {
            if (userid == null) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Dashboard()));
            }
          } else if (selectedIndex == 0) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        });
      },
      items: [
        BottomNavyBarItem(
          icon: const Icon(Icons.home_outlined),
          title: const Text(''),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.create_outlined),
          title: const Text(''),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.dashboard),
          title: const Text(''),
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.person_outline),
          title: const Text(''),
        ),
      ],
    );
  }

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
  }

  buildenterquestionfield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          textInputAction: TextInputAction.go,
          focusNode: questiontextfield,
          controller: questioncontroller,
          onSaved: (newValue) => question = newValue,
          onChanged: (value) {
            setState(() {
              questioncontroller.text.isEmpty
                  ? stepcolor[0] = kBackgroundColor
                  : stepcolor[0] = kBluePrimaryColor;
              questioncontroller.text.isEmpty
                  ? textcolor[0] = Colors.black
                  : textcolor[0] = kBackgroundColor;
              expansionstep2 = true;
            });

            if (value.isNotEmpty) {
              removeError(error: 'Please enter the question');
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              questiontextfield.requestFocus();
              return 'Please enter the question';
              //addError(error: kNamelNullError);
            }
            return null;
          },
          maxLength: 255,
          maxLines: 5,
          minLines: 1,
          decoration: InputDecoration(
              //labelText: "Name",
              hintText: 'Ask your Question',
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
    );
  }

  buildchooseimagevideofield() {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        print('Upload Button Clicked');
        _showimageorvideochooseDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: const [
            Text(
              'Supporting Video or Photo',
              style: TextStyle(fontSize: 15),
            ),
            Spacer(),
            Icon(Icons.upload_outlined)
          ],
        ),
      ),
    );
  }

  buildentoptionlistfield() {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.04,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isExpanded: true,
                value: answercounter == null
                    ? answerformatlist[0]
                    : answerformatlist[answercounter],
                items: answerformatlist.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: const Text(
                  "Select your answer format",
                  style: TextStyle(color: kBluePrimaryColor),
                ),
                onChanged: (value) {
                  setState(() {
                    answercounter = answerformatlist.indexOf(value.toString());
                    _optionscontroller.clear();
                    for (int i = 0; i < 6; i++) {
                      _optionscontroller.add(TextEditingController());
                    }
                    answeroptions.clear();
                    optionlist = [];
                    list = [];
                    if (answercounter != 0) {
                      stepcolor[1] = kBluePrimaryColor;
                      textcolor[1] = kBackgroundColor;
                      _dropdownError = "";
                    } else {
                      stepcolor[1] = kBackgroundColor;
                      textcolor[1] = Colors.black;
                    }
                    expansionstep1 = false;
                    expansionstep3 = true;
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  });
                },
              ),
            ),
          )),
    );
  }

  void getanswerformat() async {
    print('Getting data 2');
    print(userid);
    var response;
    print('In here 2');
    try {
      print('Calling');
      response =
          await http.get(Uri.parse('$apiurl/question/getDefaultData/$userid'));
    } catch (err) {
      print(err.toString());
    }

    print(response.body);

    if (response.statusCode == 200) {
      PostQuestionAnswerFormat postQuestionAnswerFormat =
          postQuestionAnswerFormatFromJson(response.body);
      print(response.body);
      Data data = postQuestionAnswerFormat.data;
      List<Question> questiontypes = data.questionTypes;
      List<Category> categorylist = data.categories;
      List<Question> questionsendoptions = data.questionSendOptions;
      List<Group> groupslist = data.groups;
      List<String> communityemailsapi = data.communityEmails;
      for (int i = 0; i < questionsendoptions.length; i++) {
        sendoptionsidlist.add(questionsendoptions[i].id);
      }
      for (int i = 0; i < categorylist.length; i++) {
        communityid.add(categorylist[i].id ?? "");
        communityname.add(categorylist[i].name);
        if (categorylist[i].itemClass != null) {
          communitytype.add(categorylist[i].itemClass!);
        }
      }
      for (int i = 0; i < questiontypes.length; i++) {
        if (questiontypes[i].displayText == "Multi Pick List") {
          multipleselectionid = questiontypes[i].id;
          continue;
        } else {
          questiontypeid.add(questiontypes[i].id);
          answerformatlist.add(questiontypes[i].displayText);
        }
      }
      print('Group List Length');
      print(groupslist.length);
      for (int i = 0; i < groupslist.length; i++) {
        groups.add(groupslist[i].name);
        groupidlist.add(groupslist[i].id);
      }

      for (int i = 0; i < communityemailsapi.length; i++) {
        communityemails.add(communityemailsapi[i].toLowerCase());
      }

      if (communityemails.contains(email!.toLowerCase())) {
        setState(() {
          showcommunityoption = true;
        });
      } else {
        setState(() {
          showcommunityoption = false;
        });
      }
    } else {
      print(response.statusCode);
      print(response.body);
    }

    for (int i = 0; i < communityname.length; i++) {
      categories.add(Categories(
          name: communityname[i], type: communitytype[i].toString()));
    }
    for (int i = 0; i < categories.length; i++) {
      tempcategories
          .add(Categories(name: categories[i].name, type: categories[i].type));
    }
    print(answerformatlist);
    print(groups);
    print(groups[0]);
    setState(() {
      getplandata();
      if (_isDraft) {
        print('Caallling draft question data');
        getdraftquestiondata();
      }
      _enabled = false;
      //answercounter = tempanswercount;
    });
  }

  buildanswerlistfield(String formatname) {
    if (formatname == "Select your answer format") {
      setState(() {
        optionlist.clear();
        list.clear();
        optionlist = [];
        list = [];
        searchablefocus.requestFocus();
        _allowmultipleselection = false;
      });
      list.add(const SizedBox());
    } else {
      if (formatname == 'Option List') {
        setState(() {
          optionlist.clear();
          list.clear();
          optionlist = [];
          list = [];
          searchablefocus.requestFocus();
          _allowmultipleselection = true;
        });
        list.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('Enter a list of answer options',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                child: displayoptions(),
              ),
            ],
          ),
        ));
      } else if (formatname == 'Ranked List') {
        setState(() {
          optionlist.clear();
          list.clear();
          optionlist = [];
          list = [];
          searchablefocus.requestFocus();
          _allowmultipleselection = false;
        });
        list.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text('Enter my answer options as a Ranked list',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                child: displayranks(),
              ),
            ],
          ),
        ));
      } else if (formatname == 'Yes or No') {
        setState(() {
          optionlist.clear();
          list.clear();
          optionlist = [];
          list = [];
          searchablefocus.requestFocus();
          _allowmultipleselection = false;
        });
        list.add(const SizedBox());
      } else if (formatname == 'Express Yourself') {
        setState(() {
          optionlist.clear();
          list.clear();
          optionlist = [];
          list = [];
          searchablefocus.requestFocus();
          _allowmultipleselection = false;
        });
        list.add(const SizedBox());
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }

  displayoptions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          //primary: false,
          scrollDirection: Axis.vertical,
          itemCount: optioncounter + 1,
          padding: const EdgeInsets.only(top: 10.0),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      //padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                          focusNode: optiontextfield[index],
                          controller: _optionscontroller[index],
                          onSaved: (newValue) =>
                              useroptions.add(newValue ?? ""),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              print(index);
                              removeError(error: 'Please enter your Option');
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              optiontextfield[index].requestFocus();
                              return 'Please enter your Option';
                              //addError(error: kNamelNullError);
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              //labelText: "Name",
                              hintText: 'Option ${index + 1}',
                              hintStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ))
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          ),
                    ),
                    index != 0 && index != 1
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                print(index);
                                int i;
                                for (i = index; i < optioncounter; i++) {
                                  _optionscontroller[i].text =
                                      _optionscontroller[i + 1].text;
                                }
                                _optionscontroller[i].clear();
                                optioncounter--;
                                optionlist.clear();
                                list.clear();
                                optionlist = [];
                                list = [];
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: kOrangePrimaryColor,
                                    border: Border.all(color: kBackgroundColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                height:
                                    MediaQuery.of(context).size.height * 0.035,
                                width:
                                    MediaQuery.of(context).size.height * 0.035,
                                child: const ImageIcon(
                                  AssetImage(
                                    'images/Cross.png',
                                  ),
                                  color: kBackgroundColor,
                                  size: 12,
                                )),
                          )
                        : const SizedBox(),
                    index == optioncounter && optioncounter <= 4
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                optioncounter++;
                                optionlist.clear();
                                list.clear();
                                optionlist = [];
                                list = [];
                                //_enabled = true;
                                //getanswerformat();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kBluePrimaryColor,
                                  border: Border.all(color: kBackgroundColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                              width: MediaQuery.of(context).size.height * 0.035,
                              child: const Icon(
                                Icons.add,
                                color: kBackgroundColor,
                                size: 18,
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            );
          }),
    );
  }

  displayranks() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          //primary: false,
          scrollDirection: Axis.vertical,
          itemCount: optioncounter + 1,
          padding: const EdgeInsets.only(top: 10.0),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      //padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                          controller: _optionscontroller[index],
                          onSaved: (newValue) =>
                              useroptions.add(newValue ?? ""),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              print(index);
                              removeError(error: 'Please enter your Option');
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Option';
                              //addError(error: kNamelNullError);
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              //labelText: "Name",
                              hintText: 'Choice ${index + 1}',
                              hintStyle: const TextStyle(color: Colors.black),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ))
                          // If  you are using latest version of flutter then lable text and hint text shown like this
                          // if you r using flutter less then 1.20.* then maybe this is not working properly
                          ),
                    ),
                    index != 0 && index != 1
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                print(index);
                                int i;
                                for (i = index; i < optioncounter; i++) {
                                  _optionscontroller[i].text =
                                      _optionscontroller[i + 1].text;
                                }
                                _optionscontroller[i].clear();
                                print(_optionscontroller);
                                optioncounter--;
                                optionlist.clear();
                                list.clear();
                                optionlist = [];
                                list = [];
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: kOrangePrimaryColor,
                                    border: Border.all(color: kBackgroundColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                height:
                                    MediaQuery.of(context).size.height * 0.035,
                                width:
                                    MediaQuery.of(context).size.height * 0.035,
                                child: const ImageIcon(
                                  AssetImage(
                                    'images/Cross.png',
                                  ),
                                  color: kBackgroundColor,
                                  size: 12,
                                )),
                          )
                        : const SizedBox(),
                    index == optioncounter && optioncounter <= 4
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                print(index);
                                optioncounter++;
                                optionlist.clear();
                                list.clear();
                                optionlist = [];
                                list = [];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: kBluePrimaryColor,
                                  border: Border.all(color: kBackgroundColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                              width: MediaQuery.of(context).size.height * 0.035,
                              child: const Icon(
                                Icons.add,
                                color: kBackgroundColor,
                                size: 18,
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            );
          }),
    );
  }

  Widget buildRow(int index) {
    print(answeroptions);
    String optionname = answeroptions[index];
    ListTile tile = ListTile(
      title: Row(
        children: [
          SizedBox(
            //padding: EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width * 0.65,
            child: TextFormField(
                controller: _optionscontroller[index],
                onSaved: (newValue) => useroptions.add(newValue ?? ""),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    print(index);
                    removeError(error: 'Please enter your Option');
                  }

                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Option';
                    //addError(error: kNamelNullError);
                  }
                  return null;
                },
                decoration: InputDecoration(
                    //labelText: "Name",
                    hintText: 'Choice ${index + 1}',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ))
                // If  you are using latest version of flutter then lable text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                ),
          ),
          index != 0 && index != 1
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      print(index);
                      int i;
                      for (i = index; i < optioncounter; i++) {
                        _optionscontroller[i].text =
                            _optionscontroller[i + 1].text;
                      }
                      _optionscontroller[i].clear();
                      print(_optionscontroller);
                      optioncounter--;
                      optionlist.clear();
                      list.clear();
                      optionlist = [];
                      list = [];
                    });
                  },
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: kOrangePrimaryColor,
                          border: Border.all(color: kBackgroundColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      height: MediaQuery.of(context).size.height * 0.035,
                      width: MediaQuery.of(context).size.height * 0.035,
                      child: const ImageIcon(
                        AssetImage(
                          'images/Cross.png',
                        ),
                        color: kBackgroundColor,
                        size: 12,
                      )),
                )
              : const SizedBox(),
          index == optioncounter && optioncounter <= 4
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      print(index);
                      optioncounter++;
                      optionlist.clear();
                      list.clear();
                      optionlist = [];
                      list = [];
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: kBluePrimaryColor,
                        border: Border.all(color: kBackgroundColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    height: MediaQuery.of(context).size.height * 0.035,
                    width: MediaQuery.of(context).size.height * 0.035,
                    child: const Icon(
                      Icons.add,
                      color: kBackgroundColor,
                      size: 18,
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
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
        return answeroptions.indexOf(optionname ?? "") != index;
      },
      onAccept: (optionname) {
        setState(() {
          print('Change');
          print(answeroptions);
          List<String> tempansweroptions = [];
          for (int i = 0; i < _optionscontroller.length; i++) {
            tempansweroptions.add(_optionscontroller[i].text);
          }
          print(tempansweroptions);
          print(optionname);
          print(index);
          int currentIndex = tempansweroptions.indexOf(optionname);
          tempansweroptions.remove(optionname);
          tempansweroptions.insert(
              currentIndex > index ? index : index - 1, optionname);
          _optionscontroller.remove(currentIndex);
          TextEditingController tempcontroller = TextEditingController();
          tempcontroller.text = optionname;
          _optionscontroller.insert(
              currentIndex > index ? index : index - 1, tempcontroller);
          answeroptions = tempansweroptions;
          tempuseroptions.clear();
          print('Change');
          print(answeroptions);
          print(_optionscontroller[0].text);
          print(_optionscontroller[1].text);
          print(_optionscontroller[2].text);
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

  buildentersendfield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          focusNode: contactstextfield,
          controller: emailaddressfield,
          onSaved: (newValue) => emailaddressfield.text = newValue!,
          onChanged: (value) {
            setState(() {
              optionlist.clear();
              list.clear();
              optionlist = [];
              list = [];
              emailaddressfield.text.isEmpty
                  ? stepcolor[2] = kBackgroundColor
                  : stepcolor[2] = kBluePrimaryColor;
              emailaddressfield.text.isEmpty
                  ? textcolor[2] = Colors.black
                  : textcolor[2] = kBackgroundColor;
              expansionstep3 = true;
              expansionstep2 = false;
              expansionstep1 = false;
            });
            if (value.isNotEmpty) {
              removeError(error: 'Please enter contacts');
            } else if (errorflagcontacts != 3) {
              removeError(error: 'Please enter a valid email address');
            } else if (errorflagcontacts != 2) {
              removeError(error: 'Please enter a valid phone number');
            }
          },
          validator: (value) {
            if (_groupValue == 0) {
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
            } else if (errorflagcontacts == 3) {
              print('In here');
              return 'Please enter a valid email address';
            } else if (errorflagcontacts == 2) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
          //maxLength: 255,
          maxLines: 5,
          minLines: 1,
          decoration: const InputDecoration(
              //labelText: "Name",
              /*errorText:
                                                        errormessagecontacts == null ? "" : errormessagecontacts,*/
              hintText:
                  'Enter email addresses or telephone numbers separated by commas (Example : bestfriend@url.com, 123-321-4565, sister@xyz.com)',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  buildchooseprivateorcommunityfield() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: Row(
          children: [
            Radio(
                value: 0,
                groupValue: _groupValue,
                onChanged: (newValue) => setState(() {
                      optionlist.clear();
                      list.clear();
                      optionlist = [];
                      list = [];
                      _groupValue = int.parse(newValue.toString());
                      int tempindex = 0;
                      String communitytype = "";
                      print(tempcategories.length);
                      for (int j = 0; j < selectedcommunitieslist.length; j++) {
                        for (int i = 0; i < tempcategories.length; i++) {
                          if (tempcategories[i].name ==
                              selectedcommunitieslist[j]) {
                            tempindex = i;
                            communitytype = tempcategories[i].type!;
                          }
                        }
                        Categories addcategory = Categories(
                            name: selectedcommunitieslist[j],
                            type: communitytype);
                        selectedcommunitieslist.removeAt(j);
                        categories.insert(tempindex, addcategory);
                        dropdownvalue = Categories();
                      }
                    })),
            GestureDetector(
                onTap: () {
                  setState(() {
                    optionlist.clear();
                    list.clear();
                    optionlist = [];
                    list = [];
                    _groupValue = 0;
                    int tempindex = 0;
                    String communitytype = "";
                    print(tempcategories.length);
                    for (int j = 0; j < selectedcommunitieslist.length; j++) {
                      for (int i = 0; i < tempcategories.length; i++) {
                        if (tempcategories[i].name ==
                            selectedcommunitieslist[j]) {
                          tempindex = i;
                          communitytype = tempcategories[i].type!;
                        }
                      }
                      Categories addcategory = Categories(
                          name: selectedcommunitieslist[j],
                          type: communitytype);
                      selectedcommunitieslist.removeAt(j);
                      categories.insert(tempindex, addcategory);
                      dropdownvalue = Categories();
                    }
                  });
                },
                child: const Text('Private')),
            showcommunityoption
                ? Radio(
                    value: 1,
                    groupValue: _groupValue,
                    onChanged: (newValue) => setState(() {
                          optionlist.clear();
                          list.clear();
                          optionlist = [];
                          list = [];
                          _groupValue = int.parse(newValue.toString());
                        }))
                : const SizedBox(),
            showcommunityoption
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        optionlist.clear();
                        list.clear();
                        optionlist = [];
                        list = [];
                        _groupValue = 1;
                      });
                    },
                    child: const Text('Community'))
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  void _showimageorvideochooseDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: kBluePrimaryColor,
                    child: ListTile(
                      leading: const Icon(
                        Icons.image,
                        color: kBackgroundColor,
                      ),
                      title: const Text(
                        'Upload Image',
                        style: TextStyle(color: kBackgroundColor),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showPickImageOptionsDialog(context);
                      },
                    ),
                  ),
                  const Divider(),
                  Container(
                    color: kBluePrimaryColor,
                    child: ListTile(
                      leading: const Icon(
                        Icons.video_collection,
                        color: kBackgroundColor,
                      ),
                      title: const Text(
                        'Upload Video',
                        style: TextStyle(color: kBackgroundColor),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _showPickVideoOptionsDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  void _showPickImageOptionsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: kBluePrimaryColor,
                    child: ListTile(
                      leading: const Icon(
                        Icons.folder,
                        color: kBackgroundColor,
                      ),
                      title: const Text(
                        'Pick from Gallery',
                        style: TextStyle(color: kBackgroundColor),
                      ),
                      onTap: () {
                        _loadPicker(ImageSource.gallery);
                      },
                    ),
                  ),
                  const Divider(),
                  Container(
                    color: kBluePrimaryColor,
                    child: ListTile(
                      leading: const Icon(
                        Icons.camera_alt_outlined,
                        color: kBackgroundColor,
                      ),
                      title: const Text(
                        'Take a Picture',
                        style: TextStyle(color: kBackgroundColor),
                      ),
                      onTap: () {
                        _loadPicker(ImageSource.camera);
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  _loadPicker(ImageSource source) async {
    try {
      PickedFile? picked = await ImagePicker.platform.pickImage(source: source);
      if (picked != null) {
        _cropImage(picked);
      }
    } on PlatformException catch (err) {
      if (err.code == "photo_access_denied") {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User did not allow photo access!!')));
      } else if (err.code == "multiple_request") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Cancelled!!')));
      }
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Something went wrong!!$err')));
    }
    Navigator.pop(context);
  }

  _cropImage(PickedFile picked) async {
    CroppedFile? cropped = await ImageCropper.platform.cropImage(
      sourcePath: picked.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
      maxWidth: 800,
    );
    if (cropped != null) {
      setState(() {
        optionlist.clear();
        list.clear();
        optionlist = [];
        list = [];
        _pickedImage = cropped;
        print('The image has been picked');
        print(_pickedImage!.path.toString());
        var fileName = (_pickedImage!.path.split('/').last);
        var imageextension = fileName.split('.').last;
        print(imageextension);
        print('The image file is selected');
        print(_pickedImage!.path);

        String tempextension = imageextension;
        imageextension = tempextension.toLowerCase();
        print('The imnageextension is$imageextension');
        print(providedimageextensions);

        if (providedimageextensions.contains(imageextension)) {
          print('In Post question perfect extensions');
          var k = 1024;
          var filesize = File(_pickedImage!.path).lengthSync();
          var kb = filesize / k;
          var mb = kb / k;
          if (mb > 2) {
            _pickedImage = null;
            BlurryDialogSingle alert = BlurryDialogSingle(
                'Error', 'Please choose images of size less than 2MB');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                var height = MediaQuery.of(context).size.height;
                var width = MediaQuery.of(context).size.width;
                return alert;
              },
            );
          } else {
            _pickedImage = cropped;
          }
        } else {
          _pickedImage = null;
          print('In Post question other extensions');
          print(imageextension);
          String temp = "";
          for (int i = 0; i < providedimageextensions.length; i++) {
            temp = "$temp${providedimageextensions[i]} ";
          }
          print(temp);
          BlurryDialogSingle alert = BlurryDialogSingle('Error',
              'Please choose images with the following extensions: $temp');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return alert;
            },
          );
        }
      });
    }
  }

  void _showPickVideoOptionsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: kBluePrimaryColor,
                    child: ListTile(
                      leading: const Icon(
                        Icons.folder,
                        color: kBackgroundColor,
                      ),
                      title: const Text(
                        'Pick from Gallery',
                        style: TextStyle(color: kBackgroundColor),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _loadVideoPicker(ImageSource.gallery);
                      },
                    ),
                  ),
                  const Divider(),
                  Container(
                    color: kBluePrimaryColor,
                    child: ListTile(
                      leading: const Icon(
                        Icons.camera_alt_outlined,
                        color: kBackgroundColor,
                      ),
                      title: const Text(
                        'Take a Video',
                        style: TextStyle(color: kBackgroundColor),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _loadVideoPicker(ImageSource.camera);
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  _loadVideoPicker(ImageSource source) async {
    PickedFile? picked = await ImagePicker.platform.pickVideo(source: source);
    if (picked != null) {
      optionlist.clear();
      list.clear();
      optionlist = [];
      list = [];
      videoFile = File(picked.path);
      final path = videoFile!.path;
      print('The size of the video is');
      print(videoFile!.lengthSync());
      print('The extension of file is: ');
      var fileName = (path.split('/').last);
      var videoextension = fileName.split('.').last;
      print(videoextension);
      print('The video file is selected');
      print(path);

      String tempextension = videoextension;
      videoextension = tempextension.toLowerCase();
      print('The videoextension is$videoextension');
      print(providedvideoextensions);
      if (providedvideoextensions.contains(videoextension)) {
        print('In Post question perfect extensions');
        var k = 1024;
        var filesize = videoFile!.lengthSync();
        var kb = filesize / k;
        var mb = kb / k;
        if (mb > 5) {
          BlurryDialogSingle alert = BlurryDialogSingle(
              'Error', 'Please choose videos of size less than 5MB');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return alert;
            },
          );
        } else {
          _controller = VideoPlayerController.file(videoFile!);

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
      } else {
        videoFile = null;
        print('In Post question other extensions');
        print(videoextension);
        String temp = "";
        for (int i = 0; i < providedvideoextensions.length; i++) {
          temp = "$temp${providedvideoextensions[i]} ";
        }
        print(temp);
        BlurryDialogSingle alert = BlurryDialogSingle('Error',
            'Please choose videos with the following extensions: $temp');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return alert;
          },
        );
      }
      setState(() {});
    }
  }

  displaycommunities() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: _errorCommunityBloc.stateResumeIssuingAuthorityStrean,
        builder: (context, errorsnapshot) {
          return Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0,
                          color: errorsnapshot.hasData &&
                                  _errorCommunityBloc.showtext
                              ? Colors.red
                              : Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(
                              20.0) //                 <--- border radius here
                          ),
                    ),
                    child: showCommunityDropdown(),
                  )),
              TextBoxLabel('Communities')
            ],
          );
        },
      ),
    );
  }

  showCommunityDropdown() {
    return Column(
      children: [
        DrodpownContainer(
          title: 'Select Community',
          showDropDownBloc: _showDropDownBloc,
          searchHint: 'Search Communities',
          originalList:
              Provider.of<SearchChangeProvider>(context, listen: false)
                      .searchList
                      .isEmpty
                  ? categories
                  : Provider.of<SearchChangeProvider>(context, listen: false)
                      .searchList,
          showSearch: true,
        ),
        StreamBuilder(
          stream: _showDropDownBloc.stateIndosNoStrean,
          initialData: false,
          builder: (context, snapshot) {
            return ExpandedSection(
              expand: _showDropDownBloc.isedited,
              height: 100,
              child: MyScrollbar(
                builder: (context, scrollController2) => ListView.builder(
                    padding: const EdgeInsets.all(0),
                    controller: scrollController2,
                    shrinkWrap: true,
                    itemCount: Provider.of<SearchChangeProvider>(context,
                                listen: false)
                            .searchList
                            .isEmpty
                        ? categories.length
                        : Provider.of<SearchChangeProvider>(context,
                                listen: false)
                            .searchList
                            .length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            showDropdown(
                                Provider.of<SearchChangeProvider>(context,
                                            listen: false)
                                        .searchList
                                        .isEmpty
                                    ? categories
                                    : Provider.of<SearchChangeProvider>(context,
                                            listen: false)
                                        .searchList,
                                index)
                          ],
                        ),
                      );
                    }),
              ),
            );
          },
        )
      ],
    );
  }

  void getuserdata() async {
    print('Getting data');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var sharedquestionid = prefs.getString('questionid');

      providedimageextensions = prefs.getStringList('imageextensions') ?? [];
      providedvideoextensions = prefs.getStringList('videoextensions') ?? [];
      email = prefs.getString('email');
      userid = prefs.getString('userid');
      imageurl = prefs.getString('imageurl');
      name = prefs.getString('name');
      header = prefs.getString('header');
      planid = prefs.getString('planid');
      isprofileprivate = prefs.getInt('isprofileprivate') ?? 0;
      if (userid == null) {
        showlogindialog();
      }
      if (isprofileprivate == 1) {
        postanonymously = true;
      }
      if (sharedquestionid != null) {
        prefs.remove('questionid');
        draftquestionid = sharedquestionid;
        _isDraft = true;
        expansionstep2 = true;
      }
      getanswerformat();
    });
    print('coming from shared preference $email$userid$name');
  }

  getdraftquestiondata() async {
    print(draftquestionid);
    var response = await http.get(
      Uri.parse('$apiurl/question/getEditData/$draftquestionid'),
      headers: {"Content-Type": "application/json", "Authorization": header},
    );

    if (response.statusCode == 200) {
      print(response.body);
      DraftQuestionApi draftQuestionApi =
          draftQuestionApiFromJson(response.body);

      DatumDraft data = draftQuestionApi.data;
      String questiontype = "";

      questioncontroller.text = data.questionText;
      questiontype = data.questionTypeId;
      questionId = data.id;
      imageVideoUrl = data.imageVideoUrl;
      if (imageVideoUrl != null) {
        fileExtension = p.extension(imageVideoUrl!);
        fileExtension = fileExtension!.split(".").last;
        if (providedvideoextensions.contains(fileExtension!.toLowerCase())) {
          _controller = VideoPlayerController.network(
              '$imageapiurl/question/${questionId!}/${imageVideoUrl!}');

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
      }
      if (multipleselectionid == questiontype) {
        multipleselectionflag = true;
        answercounter = answerformatlist.indexOf("Option List");
      } else {
        for (int i = 0; i < questiontypeid.length; i++) {
          if (questiontype == questiontypeid[i]) {
            answercounter = i + 1;
          }
        }
      }
      List<Communities> community = data.community;
      String communityids = "";
      for (int i = 0; i < community.length; i++) {
        communityids = community[i].communityId;
        for (int j = 0; j < communityid.length; j++) {
          if (communityids == communityid[j]) {
            selectedcommunitieslist.add(communityname[j]);
            categories.removeAt(j);
            _groupValue = 1;
          }
        }
      }
      List<Options> options = data.option;
      print('Option Lenght is : ${options.length}');
      if (options.length < 3) {
        optioncounter = 1;
      } else {
        optioncounter = options.length - 1;
      }
      for (int i = 0; i < options.length; i++) {
        _optionscontroller[i].text = options[i].value;
      }
      if (data.inviteesOnlyToMe != "0") {
        sendoptionslist[0] = true;
      }
      if (data.answerOnlyToMe != "0") {
        sendoptionslist[1] = true;
      }
      if (data.inviteeCanInviteOthers != "0") {
        sendoptionslist[2] = true;
      }
      List<dynamic> inviteeslist = data.invitee;
      String templist = "";
      for (int i = 0; i < inviteeslist.length; i++) {
        print('in temp');
        print('Invitee list');
        print(inviteeslist[i]);
        if (i + 1 == inviteeslist.length) {
          templist = templist + inviteeslist[i];
        } else {
          templist = '${templist + inviteeslist[i]},';
        }
      }
      emailaddressfield.text = templist;
      if (emailaddressfield.text.isNotEmpty) {
        stepcolor[2] = kBluePrimaryColor;
        textcolor[2] = kBackgroundColor;
      }
      print('What is question type');
      print(questiontype);
      if (questiontype != "0") {
        stepcolor[1] = kBluePrimaryColor;
        textcolor[1] = kBackgroundColor;
      }
      stepcolor[0] = kBluePrimaryColor;
      textcolor[0] = kBackgroundColor;
      setState(() {});
    } else {
      print('Response from draft qestion data');
      print(response.statusCode);
      print(response.body);
    }
  }

  Future<void> postquestion() async {
    if (userid == null) {
      showlogindialog();
    }
    print('In post question');
    List<String> selectedcommunityid = [];
    if (selectedcommunitieslist.isNotEmpty) {
      for (int i = 0; i < selectedcommunitieslist.length; i++) {
        var communityindex = communityname.indexOf(selectedcommunitieslist[i]);
        selectedcommunityid.add(communityid[communityindex]);
      }
    }
    String sendoption1 = "";
    String sendoption2 = "";
    String sendoption3 = "";
    String sendpostanonymously = "";

    if (sendoptionslist[0]) {
      sendoption1 = sendoptionsidlist[0];
    }
    if (sendoptionslist[1]) {
      sendoption2 = sendoptionsidlist[1];
    }
    if (sendoptionslist[2]) {
      sendoption3 = sendoptionsidlist[2];
    }
    if (postanonymously) {
      sendpostanonymously = sendoptionsidlist[3];
    }

    var bytes;
    File? imageorvideo;
    if (_pickedImage != null) {
      bytes = _pickedImage!.readAsBytes();
      imageorvideo = File(_pickedImage!.path);
    } else if (videoFile != null) {
      imageorvideo = videoFile!;
      bytes = videoFile!.readAsBytes();
    }

    List<PostOptions> postoptions = [];
    for (int i = 0; i < _optionscontroller.length; i++) {
      if (_optionscontroller[i].text == '') {
        continue;
      } else {
        postoptions.add(PostOptions(
            optionValue: _optionscontroller[i].text,
            isCorrectOption: 0,
            isActive: 1));
      }
    }

    String questiontype = "";
    if (answercounter != 0) {
      if (multipleselectionflag) {
        questiontype = multipleselectionid;
      } else {
        questiontype = questiontypeid[answercounter - 1];
      }
    }

    String bodydraftquestionid = "";
    if (_isDraft) {
      bodydraftquestionid = draftquestionid;
    }

    String postquestiontojson = postOptionsToJson(postoptions);
    String communitytojson = "";
    if (selectedcommunityid.isNotEmpty) {
      communitytojson = contactdeatilsToJson(selectedcommunityid);
    }
    String contacttojson = contactdeatilsToJson(contactdetails);

    if (postordraftquestionflag == 0) {
      postquestion_status_id = "4dfbe6db-233a-11eb-b17b-c85b767b9463";
    } else {
      postquestion_status_id = "07e20fda-233a-11eb-b17b-c85b767b9463";
    }
    //print(questiontypeid[answercounter - 1]);
    //print(optionslist);
    print(postquestiontojson);

    var imagebody = {'image_video_file': imageorvideo};
    String path = "";
    String name = "";
    if (imageVideoUrl != null) {
      path = imageVideoUrl!;
    }
    if (_pickedImage != null || videoFile != null) {
      String addimageUrl = '$apiurl/question/fileUpload';
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        "Authorization": header
      };
      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath(
            'image_video_file', imageorvideo!.path));
      var imageresponse = await request.send();

      print('Following is the response from image upload');
      print(imageresponse.statusCode);
      print(imageresponse.reasonPhrase);

      if (imageresponse.statusCode == 200) {
        print('Image Upload worked');
        String convertedresponse = await imageresponse.stream.bytesToString();
        PostQuestionImageResponse postQuestionImageResponse =
            postQuestionImageResponseFromJson(convertedresponse);
        path = postQuestionImageResponse.path;
        name = postQuestionImageResponse.name;
        print(path);
      }
    }

    var body = {
      'question_text': questioncontroller.text,
      'question_type_id': questiontype,
      'question_option': postquestiontojson,
      'contact_details': contacttojson,
      'community_id': communitytojson,
      'invitees_only_to_me': sendoption1,
      'answer_only_to_me': sendoption2,
      'invitee_can_invite_others': sendoption3,
      'send_anonymously': sendpostanonymously,
      'question_status_id': postquestion_status_id,
      'user_id': userid,
      'question_id': bodydraftquestionid,
      "path": path,
      "name": name,
      "image_video": name
    };
    print(body);
    setState(() {
      _enabled = true;
    });

    var response = await http.post(Uri.parse('$apiurl/question/add'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      _enabled = false;
    });

    if (response.statusCode == 200) {
      print(response.body);
      PostQuestionResponse postQuestionResponse =
          postquestionResponseFromJson(response.body);
      //showSnackBar(postQuestionResponse.message);
      print(postQuestionResponse.message);

      if (postordraftquestionflag == 0) {
        sharemessage('Question has been drafted successfully.');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        setState(() {
          showcheckicon = true;
        });
        sharemessage(postQuestionResponse.message);
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      }
    } else if (response.statusCode == 422) {
      PostQuestionResponse postQuestionResponse =
          postquestionResponseFromJson(response.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle('Error', postQuestionResponse.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
    } else {
      print(response.body);
      print(response.statusCode);
      PostQuestionResponse postQuestionResponse =
          postquestionResponseFromJson(response.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle('Error', postQuestionResponse.message);
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

  void sharemessage(String s) async {
    print('In shared function');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('QuestionPosted', s);
    print('In post message sncak');
    print(prefs.getString('QuestionPosted'));
  }

  void showSnackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
    ));
  }

  Future<void> postdraftquestion() async {
    print('In post question');
    List<String> selectedcommunityid = [];
    if (selectedcommunitieslist.isNotEmpty) {
      for (int i = 0; i < selectedcommunitieslist.length; i++) {
        var communityindex = communityname.indexOf(selectedcommunitieslist[i]);
        selectedcommunityid.add(communityid[communityindex]);
      }
    }
    String sendoption1 = "";
    String sendoption2 = "";
    String sendoption3 = "";
    String sendpostanonymously = "";

    if (sendoptionslist[0]) {
      sendoption1 = sendoptionsidlist[0];
    }
    if (sendoptionslist[1]) {
      sendoption2 = sendoptionsidlist[1];
    }
    if (sendoptionslist[2]) {
      sendoption3 = sendoptionsidlist[2];
    }
    if (postanonymously) {
      sendpostanonymously = sendoptionsidlist[3];
    }

    var bytes;
    File? imageorvideo;
    if (_pickedImage != null) {
      bytes = _pickedImage!.readAsBytes();
      imageorvideo = File(_pickedImage!.path);
    } else if (videoFile != null) {
      imageorvideo = videoFile!;
      bytes = videoFile!.readAsBytes();
    }

    List<PostOptions> postoptions = [];
    for (int i = 0; i < _optionscontroller.length; i++) {
      if (_optionscontroller[i].text == '') {
        continue;
      } else {
        postoptions.add(PostOptions(
            optionValue: _optionscontroller[i].text,
            isCorrectOption: 0,
            isActive: 1));
      }
    }

    String questiontype = "";
    if (answercounter != 0) {
      if (multipleselectionflag) {
        questiontype = multipleselectionid;
      } else {
        questiontype = questiontypeid[answercounter - 1];
      }
    }

    String bodydraftquestionid = draftquestionid;

    String postquestiontojson = postOptionsToJson(postoptions);
    String communitytojson = "";
    if (selectedcommunityid.isNotEmpty) {
      communitytojson = contactdeatilsToJson(selectedcommunityid);
    }
    String contacttojson = contactdeatilsToJson(contactdetails);

    if (postordraftquestionflag == 0) {
      postquestion_status_id = "4dfbe6db-233a-11eb-b17b-c85b767b9463";
    } else {
      postquestion_status_id = "07e20fda-233a-11eb-b17b-c85b767b9463";
    }

    //print(optionslist);
    print(postquestiontojson);
    var body = {
      'user_id': userid,
      'question_text': questioncontroller.text,
      'question_type_id': questiontype,
      'question_status_id': postquestion_status_id,
      'community_id': communitytojson,
      'contact_details': contacttojson,
      'invitees_only_to_me': sendoption1,
      'answer_only_to_me': sendoption2,
      'invitee_can_invite_others': sendoption3,
      'image_video_file': bytes,
      'image_video': imageorvideo,
      'question_option': postquestiontojson,
      'question_id': bodydraftquestionid,
      'send_anonymously': sendpostanonymously,
      "image_video_url": imageVideoUrl ?? ""
    };
    print(body);
    setState(() {
      _enabled = true;
    });

    var response = await http.post(Uri.parse('$apiurl/question/UpdateQuestion'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      _enabled = false;
    });

    if (response.statusCode == 200) {
      print(response.body);
      PostQuestionResponse postQuestionResponse =
          postquestionResponseFromJson(response.body);
      if (postordraftquestionflag == 0) {
        sharemessage('Question has been drafted successfully.');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        setState(() {
          showcheckicon = true;
        });
        sharemessage(postQuestionResponse.message);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      }
    } else {
      print(response.body);
      print(response.statusCode);
    }
  }

  void showgroupdialog() {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 10.0),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            title: Container(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Add Group',
                  style: TextStyle(color: kBluePrimaryColor),
                ),
              ),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Group Name',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                    //focusNode: questiontextfield,
                    controller: groupcontroller,
                    onSaved: (newValue) => groupvalue = newValue!,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        removeError(error: 'Please enter the group name');
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        questiontextfield.requestFocus();
                        return 'Please enter the group name';
                        //addError(error: kNamelNullError);
                      }
                    },
                    decoration: const InputDecoration(
                        //labelText: "Name",
                        hintText: 'Enter Group Name',
                        hintStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ))
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    ),
              ],
            ),
            actions: <Widget>[
              Container(
                color: kBackgroundColor,
                //width: double.maxFinite,
                alignment: Alignment.center,
                child: RaisedButton(
                  color: kBluePrimaryColor,
                  child: const Text("ADD"),
                  onPressed: () {
                    if (groupcontroller.text.isEmpty) {
                    } else {
                      addgroup();
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              Container(
                color: kBackgroundColor,
                //width: double.maxFinite,
                alignment: Alignment.center,
                child: RaisedButton(
                  color: kOrangePrimaryColor,
                  child: const Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
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

  void addgroup() async {
    //String contacttojson = contactToJson(contactdetails)
    contactdetails.clear();
    print(emailaddressfield.text);
    if (emailaddressfield.text.isNotEmpty) {
      final split = emailaddressfield.text.split(',');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };

      print(values.length);
      for (int i = 0; i < values.length; i++) {
        String trimmedvalue = values[i]!.trim();
        if (_isNumeric(trimmedvalue) == true) {
          if (trimmedvalue.length < 10) {
            setState(() {
              optionlist.clear();
              list.clear();
              optionlist = [];
              list = [];
              print('Enter a valid number');
              errorflagcontacts = 2;
              errorflagsform = 1;
              errormessagecontacts = 'Enter a valid phone number';
              contactstextfield.requestFocus();
            });
          } else {
            print('Accepted');
            contactdetails.add(trimmedvalue);
          }
        } else {
          if (emailValidatorRegExp.hasMatch(trimmedvalue)) {
            print('Accepted');
            contactdetails.add(trimmedvalue);
          } else {
            setState(() {
              optionlist.clear();
              list.clear();
              optionlist = [];
              list = [];
              print('Not valid email');
              errorflagcontacts = 3;
              errorflagsform = 1;
              errormessagecontacts = 'Enter a valid email address';
              contactstextfield.requestFocus();
            });
          }
        }
      }
    }
    String tempcontactdetails = contactdeatilsToJson(contactdetails);
    print(tempcontactdetails);
    print('Hello');
    print(contactdetails);
    if (errorflagsform != 1) {
      var body = {
        'group_details': {
          'group_name': groupcontroller.text,
          'users_details': contactdetails
        }
      };

      print(body);

      setState(() {
        _enabled = true;
      });
      var response = await http.post(Uri.parse('$apiurl/question/add-group'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Authorization": header
          },
          encoding: Encoding.getByName("utf-8"));

      setState(() {
        _enabled = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gropup Name Added Successfully')));
        print(response.statusCode);
        print(response.body);
      } else {
        InvalidGroupNameAPI invalidGroupNameAPI =
            invalidGroupNameAPIFromJson(response.body);
        BlurryDialogSingle alert =
            BlurryDialogSingle('Error', invalidGroupNameAPI.message);
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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errormessagecontacts)));
    }
  }

  displaygroups() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        width: MediaQuery.of(context).size.width * 0.65,
        height: MediaQuery.of(context).size.height * 0.04,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              value: groupcounter == 0 ? groups[0] : groups[groupcounter],
              items: groups.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: const Text(
                "Choose existing group",
                style: TextStyle(color: kBluePrimaryColor),
              ),
              onChanged: (value) {
                setState(() {
                  print(value);
                  groupcounter = groups.indexOf(value.toString());
                  print(groupcounter);
                  emailaddressfield.clear();
                  getgroupdata();
                  optionlist = [];
                  list = [];
                  if (answercounter != 0) {
                    stepcolor[1] = kBluePrimaryColor;
                    textcolor[1] = kBackgroundColor;
                    _dropdownError = "";
                  } else {
                    stepcolor[1] = kBackgroundColor;
                    textcolor[1] = Colors.black;
                  }
                  expansionstep1 = false;
                  expansionstep3 = true;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  void getgroupdata() async {
    if (groupcounter != 0) {
      var response = await http.get(
          Uri.parse(
              '$apiurl/question/getGroupData/${groupidlist[groupcounter - 1]}'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": header
          });

      print('Group id is: ');
      print(groupidlist[groupcounter - 1]);
      if (response.statusCode == 200) {
        print(response.body);
        GroupData groupData = groupDataFromJson(response.body);
        contactgrouplist = groupData.data;
        String groupcontactlist = "";
        for (int i = 0; i < contactgrouplist.length; i++) {
          groupcontactlist += contactgrouplist[i];
          if (i + 1 == contactgrouplist.length) {
            continue;
          } else {
            groupcontactlist += ",";
          }
        }
        setState(() {
          emailaddressfield.text = groupcontactlist;
          if (emailaddressfield.text.isEmpty) {
            print('Empty');
            stepcolor[2] = kBackgroundColor;
            textcolor[2] = Colors.black;
          } else {
            print('Not empty');
            stepcolor[2] = kBluePrimaryColor;
            textcolor[2] = kBackgroundColor;
          }
        });
      } else {
        print(response.statusCode);
      }
    } else {
      print('Groupcounter is 0');
      setState(() {
        stepcolor[2] = kBackgroundColor;
        textcolor[2] = Colors.black;
      });
    }
  }

  displayselectedcommunities() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 35,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedcommunitieslist.length,
            itemBuilder: (context, index) {
              return Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                color: const Color(0xFFFFFFFF),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFF1F1F1),
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10), //To provide some space on sides
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment:
                          WrapCrossAlignment.center, //The change
                      children: [
                        Text(
                          selectedcommunitieslist[index],
                          style: const TextStyle(
                              fontSize: 18,
                              color: kBluePrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            height: 10,
                            width: 10,
                            child: GestureDetector(
                                onTap: () {
                                  print('Removed Community');
                                  removeselectedcommunity(
                                      selectedcommunitieslist[index], index);
                                },
                                child: const ImageIcon(
                                    AssetImage('images/Cross.png')))),
                        const SizedBox(
                          width: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
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

      for (int i = 0; i < data.length; i++) {
        if (planid == data[i].id) {
          print('Number of communities');
          print(data[i].numberOfCommunities);
          numberofcommunitiesplan = data[i].numberOfCommunities;
          numberofprivateinvitation = data[i].numberOfInvitations;
          numberofcommunityinvitation =
              data[i].communityQuestionNumberOfInvitations;
        }
      }
      print(numberofprivateinvitation);
      print(numberofcommunityinvitation);
      _enabled = false;
      setState(() {});
    }
  }

  void removeselectedcommunity(String selectedcommunity, int index) {
    int tempindex = 0;
    String communitytype = "";
    print(tempcategories.length);
    print(selectedcommunity);
    setState(() {
      print(tempcategories);
      print(tempcategories.length);
      for (int i = 0; i < tempcategories.length; i++) {
        if (tempcategories[i].name == selectedcommunity) {
          tempindex = i;
          communitytype = tempcategories[i].type ?? "";
        }
      }
      Categories addcategory =
          Categories(name: selectedcommunity, type: communitytype);
      selectedcommunitieslist.removeAt(index);
      categories.insert(tempindex, addcategory);
      dropdownvalue = Categories();
    });
  }

  void cleardata() {
    setState(() {
      questioncontroller.text = "";
      answercounter = 0;
      for (int i = 0; i < _optionscontroller.length; i++) {
        _optionscontroller[i].text = "";
      }
      emailaddressfield.text = "";
      sendoptionslist[0] = false;
      sendoptionslist[1] = false;
      sendoptionslist[2] = false;
      _groupValue = 0;
      selectedcommunitieslist.clear();
      stepcolor[0] = kBackgroundColor;
      stepcolor[1] = kBackgroundColor;
      stepcolor[2] = kBackgroundColor;
      textcolor[0] = Colors.black;
      textcolor[1] = Colors.black;
      textcolor[2] = Colors.black;
      _isDraft = false;
    });
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
            onChanged: isprofileprivate == 1
                ? null
                : (value) {
                    setState(() {
                      optionlist.clear();
                      list.clear();
                      optionlist = [];
                      list = [];
                      if (isprofileprivate == 1) {
                        if (!value!) {
                          BlurryDialogSingle alert = BlurryDialogSingle('Error',
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

  void showlogindialog() {
    var alert = LoginDialog('Error', 'Please login to continue');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return alert;
      },
    );
  }

  void removespoce(bool value) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    print('In focus');
    if (!currentFocus.hasPrimaryFocus) {
      print('Has focus');
      currentFocus.unfocus();
    }
  }

  displaycheckicon() {
    print('in checkicon');
    return Center(
      child: Image.network(
        '$imageapiurl/app-icons/checked.png',
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.2,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }

  showDropdown(List<Categories> categoryList, int index) {
    return categoryList[index].type == "ItemClass.FIRST_LEVEL"
        ? Text(categoryList[index].name!,
            style: const TextStyle(color: Colors.grey))
        : InkWell(
            onTap: () {
              setState(() {
                _showDropDownBloc.isedited = false;
                optionlist.clear();
                list.clear();
                optionlist = [];
                list = [];
                if (selectedcommunitieslist.length == numberofcommunitiesplan) {
                  BlurryDialogSingle alert = BlurryDialogSingle("Error",
                      'Please upgrade plan to select more communities.');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      var height = MediaQuery.of(context).size.height;
                      var width = MediaQuery.of(context).size.width;
                      return alert;
                    },
                  );
                } else {
                  print(index);
                  selectedcommunitieslist.add(categoryList[index].name!);
                  categoryList.removeAt(index);
                  print('Temp Communities');
                  print(tempcategories);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(categoryList[index].name!),
            ),
          );
  }
}

class Categories {
  String? name;
  String? type;

  Categories({this.name, this.type});

  @override
  String toString() {
    return name ?? "";
  }
}
