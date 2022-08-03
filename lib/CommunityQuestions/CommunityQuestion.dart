import 'dart:async';
import 'dart:convert';

import 'package:decideitfinal/Community/CommunityListApiResponse.dart';
import 'package:decideitfinal/CommunityQuestions/CommunityQuestionAPI.dart';
import 'package:decideitfinal/Home/QuestionCard.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:html/parser.dart';
import 'CommunityQuestionCard.dart';
import 'CommunityQuestionsList.dart';

class CommunityQuestion extends StatefulWidget {
  var communityid;

  CommunityQuestion(id) {
    this.communityid = id;
  }
  @override
  _CommunityQuestionState createState() => _CommunityQuestionState(communityid);
}

class _CommunityQuestionState extends State<CommunityQuestion>
    with SingleTickerProviderStateMixin {
  late var communityid, email, userid, name, header ="";

  _CommunityQuestionState(id) {
    communityid = id;
  }
  var imageurl, sourceoption, searchword;
  late String bannerimage,
      thumbnailimage,
      communityname,
      categoryname,
      description,
      communityuserid = "";
  bool _enabled = true;
  bool _enabledquestions = true;
  bool isTopSelected = true;
  bool isNewSelected = false;
  late Timer _timer;
  List<String> topcommunityquestiontext = [];
  List<String> topcommunityquestionusername = [];
  List<String> topcommunityquestionuserprofile = [];
  List<int> topcommunityquestionviews = [];
  List<int> topcommunityquestioncomments = [];
  List<String> topcommunityquestionpostedtime = [];
  List<String> topcommunityquestionexpiredtitle = [];
  List<String> topcommunityquestionexpiredtext = [];
  List<String> topcommunityquestionimageurl = [];
  List<String> topcommunityquestionfileExtension = [];
  List<String> topcommunityquestionid = [];
  List<String> topquestionuserid = [];
  List<String> topquestionisliked = [];
  List<String> topquestionislikescount = [];
  List<String> topquestionisreported = [];
  List<String> topcommunityquestionreportedname = [];
  List<String> newcommunityquestiontext = [];
  List<String> newcommunityquestionusername = [];
  List<String> newcommunityquestionuserprofile = [];
  List<int> newcommunityquestionviews = [];
  List<int> newcommunityquestioncomments = [];
  List<String> newcommunityquestionpostedtime = [];
  List<String> newcommunityquestionexpiredtitle = [];
  List<String> newcommunityquestionexpiredtext = [];
  List<String> newcommunityquestionimageurl = [];
  List<String> newcommunityquestionfileExtension = [];
  List<String> newcommunityquestionid = [];
  List<String> newquestionuserid = [];
  List<String> newquestionisliked = [];
  List<String> newquestionislikescount = [];
  List<String> newquestionisreported = [];
  List<String> newcommunityquestionreportedname = [];
  List<String> sourcelist = [];
  List<String> searchlist = [];
  late Image _bannerimage;
  late Image _thumbnailimage;
  late bool _bannerloader = true;
  var decodedImage;
  var decodeheight = 0;
  late TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Top'),
    const Tab(text: 'New'),
  ];
  int _selectedTabbar = 0;
  AppBar appbar = AppBar();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setStringList('communitysource', sourcelist);
                  prefs.setStringList('searchword', searchlist);
                } else {
                  searchword = searchlist[searchlist.length - 1];
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('communitysource');
                  prefs.remove('searchword');
                }
                print(sourcelist);
                print(sourceoption);
                if (sourceoption == '1') {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                } else if (sourceoption == '2') {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => GlobalSearch(searchword)));
                } else if (sourceoption == '3') {
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => Dashboard()));
                } else if (sourceoption == '4') {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => QuestionDetail(searchword)));
                } else if (sourceoption == '5') {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => DIStarProfile(searchword)));
                } else if (sourceoption == '6') {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => QuestionDetail(searchword)));
                }
              },
              child: const Icon(Icons.arrow_back_ios)),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _enabled
                  ? Shimmer.fromColors(
                      baseColor: Colors.black12,
                      highlightColor: Colors.white10,
                      enabled: _enabled,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.23,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.23,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ))
                  : Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.07,
                            ), // this will give extra space below the image
                            //color: kBluePrimaryColor,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.33,
                            child: bannerimage == '' || bannerimage == null
                                ? Image.asset('images/placeholder.png')
                                : _bannerloader
                                    ? Image.asset(
                                        'images/placeholder.png',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        '$imageapiurl/community-image/$bannerimage',
                                        fit: BoxFit.cover,
                                      )),
                        Positioned(
                          bottom:
                              0, // how far you want image to be from bottom of the screen
                          left:
                              10, // how far you want image to be from left of the screen
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Container(
                              //alignment: Alignment(0, -0.5),
                              width: MediaQuery.of(context).size.width * 0.16,
                              height:
                                  MediaQuery.of(context).size.height * 0.125,
                              decoration: const ShapeDecoration(
                                  shape: CircleBorder(), color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(4.5),
                                child: DecoratedBox(
                                  decoration: ShapeDecoration(
                                      shape: const CircleBorder(),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: showImage())),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: MediaQuery.of(context).size.width * 0.2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: categoryname.isEmpty
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              communityname.isEmpty
                                                  ? const SizedBox()
                                                  : Text(
                                                      communityname,
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                              categoryname.isEmpty
                                                  ? const SizedBox()
                                                  : Row(
                                                      children: [
                                                        SizedBox(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.03,
                                                            child: Image.asset(
                                                                'logos/DI_Logo.png')),
                                                        Text('/ $categoryname')
                                                      ],
                                                    )
                                            ],
                                          ),
                                          const Spacer(),
                                          /*new SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                          ),*/
                                          RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  side: const BorderSide(
                                                      color:
                                                          kBluePrimaryColor)),
                                              color: kBackgroundColor,
                                              onPressed: () async {
                                                print('Address');
                                                if (communityuserid.isEmpty) {
                                                  setState(() {
                                                    _enabledquestions = true;
                                                  });
                                                  var response = await http.get(
                                                      Uri.parse(
                                                          '$apiurl/addUserCommunity/' +
                                                              communityid),
                                                      headers: {
                                                        "Authorization": header
                                                      });

                                                  if (response.statusCode ==
                                                      200) {
                                                    print(response.body);
                                                    CommunityListResponse
                                                        communityListResponse =
                                                        communityListResponseFromJson(
                                                            response.body);
                                                    BlurryDialogSingle alert =
                                                        BlurryDialogSingle(
                                                            "Success",
                                                            communityListResponse
                                                                .message);
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        var height =
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height;
                                                        var width =
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width;
                                                        return alert;
                                                      },
                                                    );

                                                    setState(() {
                                                      getcommunityquestiondata();
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _enabledquestions = false;
                                                    });
                                                    print(response.statusCode);
                                                    print(response.body);
                                                  }
                                                } else {
                                                  print('Already joined');
                                                }
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                    text:
                                                        communityuserid.isEmpty
                                                            ? 'JOIN'
                                                            : 'JOINED',
                                                    style: const TextStyle(
                                                        color:
                                                            kBluePrimaryColor,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Calibri')),
                                              )),
                                          const SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      )),
                          ),
                        )
                      ],
                    ),
              const SizedBox(
                height: 10,
              ),
              TabBar(
                indicatorColor: kBluePrimaryColor,
                labelColor: kBluePrimaryColor,
                unselectedLabelColor: Colors.grey,
                onTap: (index) {
                  print('Index');
                  print(index);
                  setState(() {
                    _selectedTabbar = index;
                    cleardata();
                    _enabledquestions = true;
                    getuserdata();
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
              displaycommunitytabs(),
            ],
          ),
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
    print('Search list in shared preference');
    print(sharedsearchlist);

    if (sharedsourcelist != null) {
      sourcelist = sharedsourcelist;
      searchlist = sharedsearchlist!;
    }

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken??"";
      getcommunityquestiondata();
    });
    print('coming from shared preference $email$userid$name');
  }

  void getcommunityquestiondata() async {
    print(communityid);
    var body = {"id": communityid, "flag": "community_details"};
    var response = await http.post(Uri.parse('$apiurl/communityQuestions'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(response.body);
      CommunityQuestionApi communityQuestionApi =
          communityQuestionApiFromJson(response.body);
      setState(() {
        bannerimage = communityQuestionApi.communityBannerImage;
        thumbnailimage = communityQuestionApi.communityThumbnailImage;
        communityname = communityQuestionApi.name;
        description = communityQuestionApi.description;
        final document = parse(description);
        List<Category> users = communityQuestionApi.users;
        for (int i = 0; i < users.length; i++) {
          communityuserid = users[i].userId ?? "";
        }
        description = parse(document.body!.text).documentElement!.text;
        Category categories = communityQuestionApi.category;
        categoryname = categories.name ?? "";
        _bannerimage = Image.network(
          '$imageapiurl/community-image/$bannerimage',
          fit: BoxFit.cover,
        );
        /*_timer = new Timer(const Duration(milliseconds: 400), () {
                        setState(() {
                          
                        });
                      });*/

        getquestions();
      });
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  void getquestions() async {
    var body = {"id": communityid, "flag": "community_questions"};
    var response = await http.post(Uri.parse('$apiurl/communityQuestions'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      CommunityQuestionslistApi communityQuestionslistApi =
          communityQuestionslistApiFromJson(response.body);

      setState(() {
        List<Question> topquestionlist = communityQuestionslistApi.topQuestions;
        for (int i = 0; i < topquestionlist.length; i++) {
          print('Username from API');
          print(topquestionlist[i].displayName.toString());
          topquestionuserid.add(topquestionlist[i].userId);
          topcommunityquestiontext.add(topquestionlist[i].questionText);
          topcommunityquestionimageurl
              .add(topquestionlist[i].imageVideoUrl ?? "");
          topcommunityquestionfileExtension.add(topquestionlist[i].fileExtention ?? "");
          topcommunityquestionusername
              .add(topquestionlist[i].displayName.toString());
          topcommunityquestionreportedname
              .add(topquestionlist[i].userName.toString());
          topcommunityquestionuserprofile
              .add(topquestionlist[i].profileImageUrl);
          topcommunityquestioncomments.add(topquestionlist[i].comments);
          topcommunityquestionviews.add(topquestionlist[i].views);
          topcommunityquestionexpiredtext.add(topquestionlist[i].expireTime);
          topcommunityquestionexpiredtitle.add(topquestionlist[i].expireTitle);
          topcommunityquestionpostedtime.add(topquestionlist[i].postedTime);
          topcommunityquestionid.add(topquestionlist[i].id);
          topquestionisliked.add(topquestionlist[i].isLike ?? "");
          topquestionislikescount.add(topquestionlist[i].likes.toString());
          topquestionisreported.add(topquestionlist[i].isAbused.toString());
        }
        print('Username is');
        print(topcommunityquestionusername);
        List<Question> newquestionlist = communityQuestionslistApi.newQuestions;
        for (int i = 0; i < newquestionlist.length; i++) {
          newquestionuserid.add(newquestionlist[i].userId);
          newcommunityquestiontext.add(newquestionlist[i].questionText);
          newcommunityquestionimageurl
              .add(newquestionlist[i].imageVideoUrl ?? "");
          newcommunityquestionfileExtension
              .add(newquestionlist[i].fileExtention ?? "");
          newcommunityquestionid.add(newquestionlist[i].id);
          newcommunityquestionusername
              .add(newquestionlist[i].displayName.toString());
          newcommunityquestionuserprofile
              .add(newquestionlist[i].profileImageUrl);
          newcommunityquestioncomments.add(newquestionlist[i].comments);
          newcommunityquestionviews.add(newquestionlist[i].views);
          newcommunityquestionexpiredtext.add(newquestionlist[i].expireTime);
          newcommunityquestionexpiredtitle.add(newquestionlist[i].expireTitle);
          newcommunityquestionpostedtime.add(newquestionlist[i].postedTime);
          newquestionisliked.add(newquestionlist[i].isLike ?? "");
          newquestionislikescount.add(newquestionlist[i].likes.toString());
          newcommunityquestionreportedname
              .add(newquestionlist[i].userName.toString());
          newquestionisreported.add(newquestionlist[i].isAbused.toString());
        }
        print(newcommunityquestiontext);
        this._bannerimage.image.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener((ImageInfo image, bool synchronousCall) {
          if (mounted) setState(() => this._bannerloader = false);
        }));
        _enabled = false;
        _enabledquestions = false;
      });
    }
  }

  void cleardata() {
    topquestionuserid = [];
    topcommunityquestiontext = [];
    topcommunityquestionusername = [];
    topcommunityquestionreportedname = [];
    topcommunityquestionuserprofile = [];
    topcommunityquestionviews = [];
    topcommunityquestioncomments = [];
    topcommunityquestionpostedtime = [];
    topcommunityquestionexpiredtitle = [];
    topcommunityquestionexpiredtext = [];
    topcommunityquestionimageurl = [];
    topcommunityquestionid = [];
    newcommunityquestiontext = [];
    newquestionuserid = [];
    newcommunityquestionusername = [];
    newcommunityquestionuserprofile = [];
    newcommunityquestionviews = [];
    newcommunityquestioncomments = [];
    newcommunityquestionpostedtime = [];
    newcommunityquestionexpiredtitle = [];
    newcommunityquestionexpiredtext = [];
    newcommunityquestionimageurl = [];
    newcommunityquestionid = [];
    newcommunityquestionreportedname = [];
  }

  displaycommunitytabs() {
    if (_selectedTabbar == 0) {
      print('In Selected tab bar');
      return _enabledquestions
          ? Shimmer.fromColors(
              baseColor: Colors.black12,
              highlightColor: Colors.white10,
              enabled: _enabledquestions,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                                '',
                                ''),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      }),
                ),
              ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: topcommunityquestioncomments.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommunityQuestionCard(
                            topcommunityquestiontext[index],
                            topcommunityquestionuserprofile[index],
                            topcommunityquestionusername[index],
                            topcommunityquestionpostedtime[index],
                            topcommunityquestionexpiredtitle[index],
                            topcommunityquestionexpiredtext[index],
                            topcommunityquestionviews[index].toString(),
                            topcommunityquestioncomments[index].toString(),
                            topcommunityquestionimageurl[index],
                            topcommunityquestionfileExtension[index],
                            topquestionisliked[index],
                            topquestionislikescount[index],
                            topquestionisreported[index],
                            topcommunityquestionreportedname[index],
                            topcommunityquestionid[index],
                            topquestionuserid[index],
                            header,
                            name,
                            communityid),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  },
                ),
              ),
            );
    } else {
      return _enabledquestions
          ? Shimmer.fromColors(
              baseColor: Colors.black12,
              highlightColor: Colors.white10,
              enabled: _enabledquestions,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                                '',
                                ''),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      }),
                ),
              ))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newcommunityquestioncomments.length,
                  itemBuilder: (context, index) {
                    print('in new');
                    print(newcommunityquestiontext[index]);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CommunityQuestionCard(
                            newcommunityquestiontext[index],
                            newcommunityquestionuserprofile[index],
                            newcommunityquestionusername[index],
                            newcommunityquestionpostedtime[index],
                            newcommunityquestionexpiredtitle[index],
                            newcommunityquestionexpiredtext[index],
                            newcommunityquestionviews[index].toString(),
                            newcommunityquestioncomments[index].toString(),
                            newcommunityquestionimageurl[index],
                            newcommunityquestionfileExtension[index],
                            newquestionisliked[index],
                            newquestionislikescount[index],
                            newquestionisreported[index],
                            newcommunityquestionreportedname[index],
                            newcommunityquestionid[index],
                            newquestionuserid[index],
                            header,
                            name,
                            communityid),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  },
                ),
              ),
            );
    }
  }

  showImage() {
    return thumbnailimage == '' 
        ? const AssetImage('images/user.jpg')
        : NetworkImage(
            '$imageapiurl/community-image/$thumbnailimage',
          );
  }
}
