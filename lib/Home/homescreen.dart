// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:decideitfinal/DI%20Stars/DIStars.dart';
import 'package:decideitfinal/DropdownContainer.dart';
import 'package:decideitfinal/Home/Drawer.dart';
import 'package:decideitfinal/Home/HomeCommunities.dart';
import 'package:decideitfinal/Home/HomeDataApi.dart';
import 'package:decideitfinal/Home/VideExtensionsAPI.dart';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/SearchTextProvider.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../Dashboard/Dashboard.dart';
import '../DropdownBloc.dart';
import '../ExpandedAnimation.dart';
import '../IssuingAuthorityErrorBloc.dart';
import '../PostQuestion/PostQuestion.dart';
import '../ProfileScreens/PersonalProfile.dart';
import '../Scrollbar.dart';
import '../logindialog.dart';
import 'QuestionCard.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var imageurl;
  var name;
  var email;
  var userid;
  int selectedIndex = 0;
  String? header;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  bool _enabled = true;
  List<String> sortBylist = ["Top", "New"];
  int sortbycounter = 0;
  final List<DropdownMenuItem> dropdownitems = [];
  List<Categories> categories = [];
  Categories? dropdownvalue;
  List<String> topquestionid = [];
  List<String> topquestionslist = [];
  List<String> topquestionimageurl = [];
  List<String> topquestioncommunity = [];
  List<String> topquestionusername = [];
  List<String> topquestionreportname = [];
  List<String> topquestionprofileimageurl = [];
  List<String> topquestionexpiringtitle = [];
  List<String> topquestionexpiringtime = [];
  List<String> topquestionpostedtime = [];
  List<int> topquestionviews = [];
  List<int> topquestioncomments = [];
  List<String> topquestioncommunityimage = [];
  List<String> topquestionfileextension = [];
  List<String> topquestionisreported = [];
  List<String> topquestionisliked = [];
  List<String> topquestionlikescount = [];
  List<String> topquestionuserid = [];
  List<String> newquestionid = [];
  List<String> newquestionslist = [];
  List<String> newquestionimageurl = [];
  List<String> newquestioncommunity = [];
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
  List<String> newquestionisreported = [];
  List<String> newquestionisliked = [];
  List<String> newquestionlikescount = [];
  List<String> newquestionreportname = [];
  List<String> communityname = [];
  List<String> communityclass = [];
  List<String> communitynamequestion = [];
  List<String> communityidquestion = [];
  String flag = "top_questions";
  String tempcommlist = "";
  GlobalKey _toolTipKey = GlobalKey();
  TextEditingController _searchcontroller = TextEditingController();
  //dom.Document document;
  late String htmlData;
  AppBar appbar = AppBar();
  static List<String> providedvideoextensions = [];
  static List<String> providedimageextensions = [];
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final _showDropDownBloc = IndosNoBloc();
  final _errorCommunityBloc = ResumeErrorIssuingAuthorityBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
  }

  @override
  void dispose() {
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'images/BG.jpg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Center(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    "Join these top DI questions, or Post your own",
                    style: TextStyle(
                        color: kBackgroundColor,
                        fontSize: MediaQuery.of(context).size.width * 0.053,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                )),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Top ',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Questions',
                            style: TextStyle(
                                color: kOrangePrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  RaisedButton(
                    color: kBackgroundColor,
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => DIStars()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: kBackgroundColor)),
                    child: RichText(
                      text: TextSpan(
                        text: 'Decide',
                        style: TextStyle(
                            color: kBluePrimaryColor,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'It Stars',
                              style: TextStyle(
                                  color: kOrangePrimaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  displaycommunities(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: [
                        const Text('Sort By:'),
                        const SizedBox(
                          width: 5,
                        ),
                        showText(0, sortbycounter == 0 ? true : false),
                        const SizedBox(
                          width: 5,
                        ),
                        showText(1, sortbycounter == 0 ? false : true),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            if (dropdownvalue != null) {
                              clearDropdown();
                            }
                          },
                          child: const Text(
                            'Clear Community',
                            style: TextStyle(
                                color: kBluePrimaryColor, fontSize: 12.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _enabled
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
                : sortbycounter == 0
                    ? topquestioncomments.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
                                  final split =
                                      topquestioncommunity[index].split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  for (int i = 0; i < values.length; i++) {
                                    String trimmedvalue = values[i]!.trim();
                                    if (i + 1 != values.length) {
                                      communitynames.add('$trimmedvalue, ');
                                    } else {
                                      communitynames.add(trimmedvalue);
                                    }

                                    int value = communitynamequestion
                                        .indexOf(trimmedvalue);
                                    communityids
                                        .add(communityidquestion[value]);
                                  }
                                } else {
                                  communitynames
                                      .add(topquestioncommunity[index]);
                                  int value = communitynamequestion
                                      .indexOf(topquestioncommunity[index]);
                                  communityids.add(communityidquestion[value]);
                                }
                                bool flag = false;
                                if (index % 2 == 0) {
                                  flag = true;
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
                                        topquestionreportname[index],
                                        header,
                                        name,
                                        topquestionuserid[index],
                                        1,
                                        ''),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                    : newquestioncomments.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
                                  final split =
                                      newquestioncommunity[index].split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  for (int i = 0; i < values.length; i++) {
                                    String trimmedvalue = values[i]!.trim();
                                    if (i + 1 != values.length) {
                                      communitynames.add('$trimmedvalue, ');
                                    } else {
                                      communitynames.add(trimmedvalue);
                                    }
                                    int value = communitynamequestion
                                        .indexOf(trimmedvalue);
                                    communityids
                                        .add(communityidquestion[value]);
                                  }
                                } else {
                                  communitynames
                                      .add(newquestioncommunity[index]);
                                  int value = communitynamequestion
                                      .indexOf(newquestioncommunity[index]);
                                  communityids.add(communityidquestion[value]);
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
                                        newquestionreportname[index],
                                        header,
                                        name,
                                        newquestionuserid[index],
                                        1,
                                        ''),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              },
                            ),
                          )
          ],
        ),
      ),
    );
  }

  getbottomnavigation() {
    return BottomNavyBar(
      showElevation: true,
      selectedIndex: selectedIndex,
      onItemSelected: (index) async {
        print(index);
        SharedPreferences userprefs = await SharedPreferences.getInstance();
        setState(() {
          selectedIndex = index;

          if (selectedIndex == 3) {
            if (userid == null) {
              setState(() {
                selectedIndex = 0;
              });
              if (userid == null) {
                userprefs.setString('ReportQuestion', 'Please login');
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PersonalProfile()));
            }
          } else if (selectedIndex == 2) {
            if (userid == null) {
              setState(() {
                selectedIndex = 0;
              });

              userprefs.setString('ReportQuestion', 'Please login');
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Dashboard()));
            }
          } else if (selectedIndex == 1) {
            if (userid == null) {
              setState(() {
                selectedIndex = 0;
              });

              userprefs.setString('ReportQuestion', 'Please login');
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            } else {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => PostQuestion()));
            }
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

  displaycommunities() {
    return StreamBuilder(
      stream: _errorCommunityBloc.stateResumeIssuingAuthorityStrean,
      builder: (context, errorsnapshot) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 1.0,
                    color: errorsnapshot.hasData && _errorCommunityBloc.showtext
                        ? Colors.red
                        : Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(
                        20.0) //                 <--- border radius here
                    ),
              ),
              child: showCommunityDropdown(),
            ));
      },
    );
  }

  showCommunityDropdown() {
    return Column(
      children: [
        DrodpownContainer(
          title: dropdownvalue == null
              ? 'Select Community'
              : dropdownvalue!.name ?? "",
          showDropDownBloc: _showDropDownBloc,
          searchHint: 'Search Community',
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
                            showData(
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

  clearDropdown() {
    setState(() {
      dropdownvalue = null;
      cleardata();
      _enabled = true;
      flag = "top_questions";
      gethomedata();
      _showDropDownBloc.isedited = false;
    });
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedquestion = prefs.getString('QuestionPosted');
    var sharedcontactus = prefs.getString('Contactus');

    if (sharedcontactus != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(sharedcontactus),
      ));
      prefs.remove('Contactus');
    }

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
      if (sharedquestion != null) {
        print('In snack');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(sharedquestion),
        ));
        prefs.remove('QuestionPosted');
      } else {
        print('In null');
      }
      gethomedata();
    });
    print('coming from shared preference $email$userid$name');
  }

  void gethomedata() async {
    var body;
    if (flag == "categories") {
      List<String> newList =
          communitynamequestion.map((list) => list.toLowerCase()).toList();
      int index = newList.indexOf(dropdownvalue!.name!.toLowerCase());
      String id = communityidquestion[index];
      body = {"flag": "top_questions", "community_id": id};
    } else {
      body = {"flag": flag};
    }
    communityname = [];
    communityclass = [];
    categories = [];
    communitynamequestion = [];
    communityidquestion = [];
    var response = await http.post(Uri.parse('$apiurl/getTopQuestionData'),
        body: json.encode(body),
        headers: {
          "Content-Type": "application/json",
          "Authorization": header ?? ""
        },
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(response.body);
      HomeData homeData = homeDataFromJson(response.body);
      List<Question> topquestion = homeData.topQuestions;
      List<Question> newquestion = homeData.newQuestions;
      for (int i = 0; i < topquestion.length; i++) {
        topquestionid.add(topquestion[i].id);
        topquestionslist.add(topquestion[i].questionText);
        List<Community> community = topquestion[i].community;
        tempcommlist = "";
        for (int j = 0; j < community.length; j++) {
          if (j + 1 == community.length) {
            tempcommlist = tempcommlist + community[j].name;
          } else {
            tempcommlist = "$tempcommlist${community[j].name}, ";
          }
        }

        topquestioncommunity.add(tempcommlist);
        topquestionlikescount.add(topquestion[i].likes.toString());
        topquestionisliked.add(topquestion[i].islike ?? "");
        topquestionisreported.add(topquestion[i].isAbused ?? "");
        topquestionimageurl.add(topquestion[i].imageVideoUrl ?? "");
        topquestionfileextension.add(topquestion[i].fileExtention);
        topquestionprofileimageurl.add(topquestion[i].profileImageUrl ?? '');
        topquestioncomments.add(topquestion[i].comments);
        topquestionviews.add(topquestion[i].views);
        topquestionexpiringtime.add(topquestion[i].expireTime.toString());
        topquestionexpiringtitle.add(topquestion[i].expireTitle.toString());
        topquestionpostedtime.add(topquestion[i].postedTime.toString());
        topquestionusername.add(topquestion[i].displayName.toString());
        topquestionreportname.add(topquestion[i].userName.toString());
        topquestionuserid.add(topquestion[i].userId);
      }
      for (int i = 0; i < newquestion.length; i++) {
        newquestionid.add(newquestion[i].id);
        newquestionslist.add(newquestion[i].questionText);
        List<Community> community = newquestion[i].community;
        tempcommlist = "";
        for (int j = 0; j < community.length; j++) {
          if (j + 1 == community.length) {
            tempcommlist = tempcommlist + community[j].name;
          } else {
            tempcommlist = "$tempcommlist${community[j].name}, ";
          }
        }
        newquestioncommunity.add(tempcommlist);
        newquestionimageurl.add(newquestion[i].imageVideoUrl ?? "");
        newquestionisliked.add(newquestion[i].islike ?? "");
        newquestionlikescount.add(newquestion[i].likes.toString());
        newquestionisreported.add(newquestion[i].isAbused ?? "");
        newquestionfileextension.add(newquestion[i].fileExtention);
        newquestionprofileimageurl.add(newquestion[i].profileImageUrl ?? '');
        newquestioncomments.add(newquestion[i].comments);
        newquestionviews.add(newquestion[i].views);
        newquestionexpiringtime.add(newquestion[i].expireTime.toString());
        newquestionexpiringtitle.add(newquestion[i].expireTitle.toString());
        newquestionpostedtime.add(newquestion[i].postedTime.toString());
        newquestionusername.add(newquestion[i].displayName.toString());
        newquestionreportname.add(newquestion[i].userName.toString());
        newquestionuserid.add(newquestion[i].userId);
      }
    }

    var body1 = {"flag": "categories"};
    var categoryresponse = await http.post(
        Uri.parse('$apiurl/getTopQuestionData'),
        body: json.encode(body1),
        headers: {
          "Content-Type": "application/json",
          "Authorization": header ?? ""
        },
        encoding: Encoding.getByName("utf-8"));

    if (categoryresponse.statusCode == 200) {
      print(categoryresponse.body);
      HomeCommunity homeCommunity =
          homeCommunityFromJson(categoryresponse.body);
      List<Datum> data = homeCommunity.data;
      for (int i = 0; i < data.length; i++) {
        communityname.add(data[i].name);
        communityclass.add(data[i].itemClass.toString());
        if (data[i].itemClass != 'first-level') {
          communitynamequestion.add(data[i].name);
          communityidquestion.add(data[i].id);
        }
      }
    }

    for (int i = 0; i < communityname.length; i++) {
      categories
          .add(Categories(name: communityname[i], type: communityclass[i]));
    }

    var extensionresponse =
        await http.get(Uri.parse('$apiurl/getImageVideoExtensions'));
    if (extensionresponse.statusCode == 200) {
      print(extensionresponse.body);
      VideoExtensionsApi videoExtensionsApi =
          videoExtensionsApiFromJson(extensionresponse.body);

      Data data = videoExtensionsApi.data;

      providedimageextensions = data.imageExtensions;
      providedvideoextensions = data.videoExtensions;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('imageextensions', providedimageextensions);
      prefs.setStringList('videoextensions', providedvideoextensions);
    }

    setState(() {
      _enabled = false;
    });
  }

  void cleardata() {
    topquestionid = [];
    topquestionslist = [];
    topquestionimageurl = [];
    topquestioncommunity = [];
    topquestionusername = [];
    topquestionprofileimageurl = [];
    topquestionexpiringtitle = [];
    topquestionexpiringtime = [];
    topquestionpostedtime = [];
    topquestionviews = [];
    topquestioncomments = [];
    topquestioncommunityimage = [];
    topquestionfileextension = [];
    newquestionid = [];
    newquestionslist = [];
    newquestionimageurl = [];
    newquestioncommunity = [];
    newquestionusername = [];
    newquestionprofileimageurl = [];
    newquestionexpiringtitle = [];
    newquestionexpiringtime = [];
    newquestionpostedtime = [];
    newquestionviews = [];
    newquestioncomments = [];
    newquestioncommunityimage = [];
    newquestionfileextension = [];
    topquestionisreported = [];
    newquestionisreported = [];
    topquestionlikescount = [];
    topquestionisliked = [];
    newquestionlikescount = [];
    newquestionisliked = [];
    communityname = [];
    communityclass = [];
  }

  showData(List<Categories> list, int index) {
    return list[index].type == "first-level"
        ? Text(list[index].name ?? "",
            style: const TextStyle(color: Colors.grey))
        : InkWell(
            onTap: () {
              setState(() {
                dropdownvalue = list[index];
                cleardata();
                _enabled = true;
                flag = "categories";
                gethomedata();
                _showDropDownBloc.isedited = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(list[index].name ?? ""),
            ),
          );
  }

  showText(int i, bool isTopSelected) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (i == 0 && !isTopSelected) {
              setState(() {
                sortbycounter = i;
                _enabled = true;
                gethomedata();
              });
            } else if (i == 1 && !isTopSelected) {
              setState(() {
                sortbycounter = i;
                _enabled = true;
                gethomedata();
              });
            }
          },
          child: Text(
            i == 0 ? 'Top' : 'New',
            style: TextStyle(
                color: i == 0
                    ? isTopSelected
                        ? Colors.black
                        : kBluePrimaryColor
                    : isTopSelected
                        ? Colors.black
                        : kBluePrimaryColor,
                decoration: i == 0
                    ? isTopSelected
                        ? TextDecoration.none
                        : TextDecoration.underline
                    : isTopSelected
                        ? TextDecoration.none
                        : TextDecoration.underline,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
