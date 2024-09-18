// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';
import 'package:decideitfinal/CommunityQuestions/CommunityQuestion.dart';
import 'package:decideitfinal/DI%20Stars/DIStars.dart';
import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/Home/HomeDataApi.dart';
import 'package:decideitfinal/Home/QuestionCard.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/PublicProfile/PublicProfileApi.dart';
import 'package:decideitfinal/QuestionDetail/QuestionDetail.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class DIStarProfile extends StatefulWidget {
  var questionuserid, sourcecount;

  DIStarProfile(questionuserid, this.sourcecount, {Key? key})
      : super(key: key) {
    this.questionuserid = questionuserid;
  }
  @override
  _DIStarProfileState createState() =>
      _DIStarProfileState(questionuserid, sourcecount);
  //
}

class _DIStarProfileState extends State<DIStarProfile>
    with SingleTickerProviderStateMixin {
  var userid, questionuserid, sourcecount, searchword;
  var header;
  var email, imageurl, name;
  List<String> sourcelist = [];

  List<String> searchlist = [];

  _DIStarProfileState(this.questionuserid, this.sourcecount);
  late TabController _tabController;
  int _selectedTabbar = 0;
  List<String> topquestionid = [];
  List<String> topquestionslist = [];
  List<String> topquestionimageurl = [];
  List<String> topquestioncommunity = [];
  List<String> topquestioncommunityid = [];
  List<String> topquestionusername = [];
  List<String> topquestionreportedname = [];
  List<String> topquestionprofileimageurl = [];
  List<String> topquestionexpiringtitle = [];
  List<String> topquestionexpiringtime = [];
  List<String> topquestionpostedtime = [];
  List<int> topquestionviews = [];
  List<int> topquestioncomments = [];
  List<String> topquestioncommunityimage = [];
  List<String> topquestionfileextension = [];
  List<String> topquestionuserid = [];
  List<String> topquestionlikescount = [];
  List<String> topquestionisliked = [];
  List<String> topquestionisreported = [];
  List<String> newquestionid = [];
  List<String> newquestionslist = [];
  List<String> newquestionimageurl = [];
  List<String> newquestioncommunity = [];
  List<String> newquestioncommunityid = [];
  List<String> newquestionusername = [];
  List<String> newquestionprofileimageurl = [];
  List<String> newquestionexpiringtitle = [];
  List<String> newquestionexpiringtime = [];
  List<String> newquestionpostedtime = [];
  List<int> newquestionviews = [];
  List<int> newquestioncomments = [];
  List<String> newquestioncommunityimage = [];
  List<String> newquestionfileextension = [];
  List<String> newquestionuserid = [];
  List<String> newquestionlikescount = [];
  List<String> newquestionisliked = [];
  List<String> newquestionisreported = [];
  List<String> newquestionreportedname = [];
  String tempcommlist = "";
  String tempcommidlist = "";

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  int selectedIndex = 4;
  late File _pickedImage;
  final List<String> errors = [];
  bool _isInAsyncCall = false;
  late int isprofileprivate = 0;
  late String userbio, profileimageurl, username, randomname;
  bool _enabled = true;
  bool _enabledquestions = true;
  late int activequestioncount, answercount;
  AppBar appbar = AppBar();

  @override
  void initState() {
    super.initState();
    getuserdata();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SizedBox(
              height: appbar.preferredSize.height * 0.8,
              child: Image.asset('logos/DI_Logo.png')),
          centerTitle: true,
          leading: GestureDetector(
              onTap: () async {
                // if (sourcelist.isNotEmpty) {
                //   sourcecount = sourcelist[sourcelist.length - 1];
                // }

                // if (sourcelist.length != 1) {
                //   searchword = searchlist[searchlist.length - 2];
                //   sourcelist.removeLast();
                //   searchlist.removeLast();
                //   SharedPreferences prefs =
                //       await SharedPreferences.getInstance();
                //   prefs.setStringList('communitysource', sourcelist);
                //   prefs.setStringList('searchword', searchlist);
                // } else {
                //   searchword = searchlist[searchlist.length - 1];
                //   SharedPreferences prefs =
                //       await SharedPreferences.getInstance();
                //   prefs.remove('communitysource');
                //   prefs.remove('searchword');
                // }
                if (sourcecount == 1) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                } /*else if (sourcecount == 2) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GlobalSearch(searchword)));
              }*/
                else if (sourcecount == 3) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Dashboard()));
                } else if (sourcecount == 4) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => CommunityQuestion(searchword)));
                } else if (sourcecount == 5) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => DIStars()));
                } else if (sourcecount == 6) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => QuestionDetail(searchword)));
                }
              },
              child: const Icon(Icons.arrow_back_ios)),
          backgroundColor: kBluePrimaryColor,
          bottomOpacity: 0.0,
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _enabled
                        ? Shimmer.fromColors(
                            baseColor: Colors.black12,
                            highlightColor: Colors.white10,
                            enabled: _enabled,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: MediaQuery.of(context).size.width,
                                child: Card(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.23,
                                    width: MediaQuery.of(context).size.width,
                                  ),
                                ),
                              ),
                            ))
                        : isprofileprivate != 0
                            ? Column(
                                children: [
                                  Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .08,
                                            color: kBluePrimaryColor,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .03,
                                            right: 0.0,
                                            left: 10.0),
                                        child: Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.11,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.11,
                                                  decoration:
                                                      const ShapeDecoration(
                                                          shape: CircleBorder(),
                                                          color: Colors.white),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: DecoratedBox(
                                                      decoration: ShapeDecoration(
                                                          shape: const CircleBorder(),
                                                          image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: showImage(),
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text(
                                                    isprofileprivate == 0
                                                        ? 'Display Name'
                                                        : isprofileprivate == 0
                                                            ? username
                                                            : randomname,
                                                    style: const TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 55,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        color: kBackgroundColor,
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'images/private_profile.png',
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              'This Profile is Private',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: kBluePrimaryColor),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .08,
                                            color: kBluePrimaryColor,
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .03,
                                            right: 0.0,
                                            left: 10.0),
                                        child: Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.10,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.10,
                                                  decoration:
                                                      const ShapeDecoration(
                                                          shape: CircleBorder(),
                                                          color: Colors.white),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: DecoratedBox(
                                                      decoration: ShapeDecoration(
                                                          shape:
                                                              const CircleBorder(),
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  showImage())),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12.0),
                                                  child: Text(
                                                    username,
                                                    style: const TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Calibri'),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0),
                                                  child: Row(
                                                    children: [
                                                      RaisedButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          ),
                                                          color:
                                                              kOrangePrimaryColor,
                                                          onPressed: () {
                                                            print('Contacts');
                                                          },
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Active Questions: ',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: activequestioncount
                                                                        .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                              ],
                                                            ),
                                                          )),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      RaisedButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          ),
                                                          color:
                                                              kBluePrimaryColor,
                                                          onPressed: () {
                                                            print('Address');
                                                          },
                                                          child: RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  'Total Answers: ',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: answercount
                                                                        .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                              ],
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  userbio == null
                                      ? const SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(userbio),
                                        ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8),
                                    child: Text(
                                      'Community Questions',
                                      style: TextStyle(
                                          color: kBluePrimaryColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    child: TabBar(
                                      indicatorColor: kBluePrimaryColor,
                                      labelColor: kBluePrimaryColor,
                                      unselectedLabelColor: Colors.grey,
                                      onTap: (index) {
                                        setState(() {
                                          _selectedTabbar = index;
                                          _enabledquestions = true;
                                          cleardata();
                                          getcommunityquestions();
                                        });
                                      },
                                      controller: _tabController,
                                      tabs: const [
                                        Tab(
                                          text: 'Top',
                                        ),
                                        Tab(
                                          text: 'New',
                                        ),
                                      ],
                                    ),
                                  ),
                                  displaytabdata(),
                                ],
                              ),
                  ])),
        ));
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedsourcelist = prefs.getStringList('communitysource');
    var sharedsearchlist = prefs.getStringList('searchword');

    if (sharedsourcelist != null) {
      sourcelist = sharedsourcelist;
      searchlist = sharedsearchlist ?? [];
    }
    email = sharedemail;
    userid = shareduserid;
    imageurl = sharedimageurl;
    name = sharedname;
    header = sharedtoken;

    getpublicprofiledata();
    print('coming from shared preference $email$userid$name');
  }

  displaytabdata() {
    if (_selectedTabbar == 0) {
      return _enabledquestions
          ? Shimmer.fromColors(
              baseColor: Colors.black12,
              highlightColor: Colors.white10,
              enabled: _enabled,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          QuestionCard(
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
                              header,
                              '',
                              '',
                              1,
                              ''),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    }),
              ))
          : topquestioncomments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      color: kBackgroundColor,
                      child: Column(
                        children: [
                          Image.asset(
                            'images/no_found.png',
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'No Questions Found For Your Selection',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: kBluePrimaryColor),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topquestioncomments.length,
                    itemBuilder: (context, index) {
                      var communitynames = [];
                      var communityids = [];
                      if (topquestioncommunity[index].contains(',')) {
                        final split = topquestioncommunity[index].split(',');
                        final Map<int, String> values = {
                          for (int i = 0; i < split.length; i++) i: split[i]
                        };
                        final splitid =
                            topquestioncommunityid[index].split(',');
                        final Map<int, String> valuesid = {
                          for (int i = 0; i < splitid.length; i++) i: splitid[i]
                        };
                        for (int i = 0; i < valuesid.length; i++) {
                          String trimmedvalue = valuesid[i]!.trim();
                          if (i + 1 != valuesid.length) {
                            communityids.add('$trimmedvalue, ');
                          } else {
                            communityids.add(trimmedvalue);
                          }
                        }
                        for (int i = 0; i < values.length; i++) {
                          String trimmedvalue = values[i]!.trim();
                          if (i + 1 != values.length) {
                            communitynames.add('$trimmedvalue, ');
                          } else {
                            communitynames.add(trimmedvalue);
                          }
                        }
                      } else {
                        communitynames.add(topquestioncommunity[index]);
                        communityids.add(topquestioncommunityid[index]);
                      }
                      return Column(
                        children: [
                          QuestionCard(
                              topquestionslist[index],
                              topquestionprofileimageurl[index],
                              topquestionusername[index],
                              communitynames,
                              topquestionpostedtime[index],
                              topquestionexpiringtitle[index],
                              topquestionexpiringtime[index],
                              topquestionviews[index].toString(),
                              topquestioncomments[index].toString(),
                              topquestionimageurl[index],
                              topquestionfileextension[index],
                              topquestionid[index],
                              communityids,
                              topquestionlikescount[index],
                              topquestionisliked[index],
                              topquestionisreported[index],
                              topquestionreportedname[index],
                              header,
                              name,
                              topquestionuserid[index],
                              5,
                              questionuserid),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    },
                  ),
                );
    } else {
      return _enabledquestions
          ? Shimmer.fromColors(
              baseColor: Colors.black12,
              highlightColor: Colors.white10,
              enabled: _enabled,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          QuestionCard(
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
                              header,
                              '',
                              '',
                              5,
                              questionuserid),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    }),
              ))
          : newquestioncomments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      color: kBackgroundColor,
                      child: Column(
                        children: [
                          Image.asset(
                            'images/no_found.png',
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'No Questions Found For Your Selection',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: kBluePrimaryColor),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: newquestioncomments.length,
                    itemBuilder: (context, index) {
                      var communitynames = [];
                      var communityids = [];
                      if (newquestioncommunity[index].contains(',')) {
                        final split = newquestioncommunity[index].split(',');
                        final Map<int, String> values = {
                          for (int i = 0; i < split.length; i++) i: split[i]
                        };
                        final splitid =
                            newquestioncommunityid[index].split(',');
                        final Map<int, String> valuesid = {
                          for (int i = 0; i < splitid.length; i++) i: splitid[i]
                        };
                        for (int i = 0; i < valuesid.length; i++) {
                          String trimmedvalue = valuesid[i]!.trim();
                          if (i + 1 != valuesid.length) {
                            communityids.add('$trimmedvalue, ');
                          } else {
                            communityids.add(trimmedvalue);
                          }
                        }
                        for (int i = 0; i < values.length; i++) {
                          String trimmedvalue = values[i]!.trim();
                          if (i + 1 != values.length) {
                            communitynames.add('$trimmedvalue, ');
                          } else {
                            communitynames.add(trimmedvalue);
                          }
                        }
                      } else {
                        communitynames.add(newquestioncommunity[index]);
                        communityids.add(newquestioncommunityid[index]);
                      }
                      return Column(
                        children: [
                          QuestionCard(
                              newquestionslist[index],
                              newquestionprofileimageurl[index],
                              newquestionusername[index],
                              communitynames,
                              newquestionpostedtime[index],
                              newquestionexpiringtitle[index],
                              newquestionexpiringtime[index],
                              newquestionviews[index].toString(),
                              newquestioncomments[index].toString(),
                              newquestionimageurl[index],
                              newquestionfileextension[index],
                              newquestionid[index],
                              communityids,
                              newquestionlikescount[index],
                              newquestionisliked[index],
                              newquestionisreported[index],
                              newquestionreportedname[index],
                              header,
                              name,
                              newquestionuserid[index],
                              5,
                              questionuserid),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    },
                  ),
                );
    }
  }

  void getpublicprofiledata() async {
    var body = {"flag": "personal_details", "user_id": questionuserid};
    var response = await http.post(Uri.parse('$apiurl/getTopQuestionData'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      PublicProfile publicProfile = publicProfileFromJson(response.body);
      isprofileprivate = publicProfile.isProfilePrivate;
      userbio = publicProfile.userProfile ?? "";
      username = publicProfile.userName;
      randomname = publicProfile.randomName;
      profileimageurl = publicProfile.profileImageUrl ?? "";
      answercount = publicProfile.commentsCount;
      activequestioncount = publicProfile.activeQuestionsCount;
      if (isprofileprivate == 0) {
        setState(() {
          _enabled = false;
        });
        getcommunityquestions();
      } else {
        setState(() {
          _enabled = false;
          _enabledquestions = false;
        });
      }
    }
  }

  void getcommunityquestions() async {
    var body = {"flag": "top_questions", "user_id": questionuserid};
    var response = await http.post(Uri.parse('$apiurl/getTopQuestionData'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));
    print(response.body);
    if (response.statusCode == 200) {
      HomeData homeData = homeDataFromJson(response.body);
      List<Question> topquestion = homeData.topQuestions;
      List<Question> newquestion = homeData.newQuestions;
      for (int i = 0; i < topquestion.length; i++) {
        topquestionid.add(topquestion[i].id);
        topquestionslist.add(topquestion[i].questionText);
        topquestionlikescount.add(topquestion[i].likes.toString());
        List<Community> community = topquestion[i].community;
        tempcommlist = "";
        tempcommidlist = "";
        for (int j = 0; j < community.length; j++) {
          if (j + 1 == community.length) {
            tempcommlist = tempcommlist + community[j].name;
            tempcommidlist = tempcommidlist + community[j].id;
          } else {
            tempcommlist = "$tempcommlist${community[j].name}, ";
            tempcommidlist = "$tempcommidlist${community[j].id}, ";
          }
        }
        topquestioncommunity.add(tempcommlist);
        topquestioncommunityid.add(tempcommidlist);
        topquestionisreported.add(topquestion[i].isAbused ?? "");
        topquestionisliked.add(topquestion[i].islike ?? "");
        topquestionimageurl.add(topquestion[i].imageVideoUrl ?? "");
        topquestionfileextension.add(topquestion[i].fileExtention);
        topquestionprofileimageurl.add(topquestion[i].profileImageUrl ?? "");
        topquestioncomments.add(topquestion[i].comments);
        topquestionviews.add(topquestion[i].views);
        topquestionexpiringtime.add(topquestion[i].expireTime.toString());
        topquestionexpiringtitle.add(topquestion[i].expireTitle.toString());
        topquestionpostedtime.add(topquestion[i].postedTime.toString());
        topquestionusername.add(topquestion[i].displayName.toString());
        topquestionreportedname.add(topquestion[i].userName);
        topquestionuserid.add(topquestion[i].userId);
      }
      for (int i = 0; i < newquestion.length; i++) {
        newquestionid.add(newquestion[i].id);
        newquestionslist.add(newquestion[i].questionText);
        newquestionlikescount.add(newquestion[i].likes.toString());
        List<Community> community = newquestion[i].community;
        tempcommlist = "";
        tempcommidlist = "";
        for (int j = 0; j < community.length; j++) {
          if (j + 1 == community.length) {
            tempcommlist = tempcommlist + community[j].name;
            tempcommidlist = tempcommidlist + community[j].id;
          } else {
            tempcommlist = "$tempcommlist${community[j].name}, ";
            tempcommidlist = "$tempcommidlist${community[j].id}, ";
          }
        }
        newquestioncommunity.add(tempcommlist);
        newquestioncommunityid.add(tempcommidlist);
        newquestionisreported.add(newquestion[i].isAbused ?? "");
        newquestionimageurl.add(newquestion[i].imageVideoUrl ?? "");
        newquestionisliked.add(newquestion[i].islike ?? "");
        newquestionfileextension.add(newquestion[i].fileExtention);
        newquestionprofileimageurl.add(newquestion[i].profileImageUrl ?? "");
        newquestioncomments.add(newquestion[i].comments);
        newquestionviews.add(newquestion[i].views);
        newquestionexpiringtime.add(newquestion[i].expireTime.toString());
        newquestionexpiringtitle.add(newquestion[i].expireTitle.toString());
        newquestionpostedtime.add(newquestion[i].postedTime.toString());
        newquestionusername.add(newquestion[i].displayName.toString());
        newquestionreportedname.add(newquestion[i].userName);
        newquestionuserid.add(newquestion[i].userId);
      }

      setState(() {
        _enabledquestions = false;
      });
    }
  }

  void cleardata() {
    topquestionreportedname = [];
    topquestionid = [];
    topquestionslist = [];
    topquestionimageurl = [];
    topquestioncommunity = [];
    topquestioncommunityid = [];
    topquestionusername = [];
    topquestionprofileimageurl = [];
    topquestionexpiringtitle = [];
    topquestionexpiringtime = [];
    topquestionpostedtime = [];
    topquestionviews = [];
    topquestioncomments = [];
    topquestioncommunityimage = [];
    topquestionfileextension = [];
    topquestionlikescount = [];
    topquestionisliked = [];
    newquestionid = [];
    newquestionslist = [];
    newquestionimageurl = [];
    newquestioncommunity = [];
    newquestioncommunityid = [];
    newquestionusername = [];
    newquestionreportedname = [];
    newquestionprofileimageurl = [];
    newquestionexpiringtitle = [];
    newquestionexpiringtime = [];
    newquestionpostedtime = [];
    newquestionviews = [];
    newquestioncomments = [];
    newquestioncommunityimage = [];
    newquestionfileextension = [];
    newquestionlikescount = [];
    newquestionisliked = [];
  }

  showImage() {
    return profileimageurl == '' || profileimageurl == null
        ? const AssetImage('images/user.jpg')
        : NetworkImage('$imageapiurl/$profileimageurl');
  }
}
