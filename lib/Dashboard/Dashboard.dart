import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:decideitfinal/Dashboard/DashboardAPI.dart';
import 'package:decideitfinal/Dashboard/DraftQuestionCard.dart';
import 'package:decideitfinal/Home/Drawer.dart';
import 'package:decideitfinal/Home/QuestionCard.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:decideitfinal/ProfileScreens/PersonalProfile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';
import '../logindialog.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  var imageurl, userid, name, email, header;
  int selectedIndex = 2;
  TextEditingController controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int sortbycounter = 0;
  List<String> sortBylist = ["All", "Private", "Community", "Posted by me"];
  bool isOpenSelected = true;
  bool isCompletedSelected = false;
  bool isDraftSelected = false;
  bool _enabled = true;
  late TabController _tabController;
  late String tempcommlist;
  late String tempcommidlist;
  List<String> openquestionid = [];
  List<String> openquestionslist = [];
  List<String> openquestionimageurl = [];
  List<String> openquestioncommunity = [];
  List<String> openquestionusername = [];
  List<String> openquestionreportedname = [];
  List<String> openquestionuseridlist = [];
  List<String> openquestionprofileimageurl = [];
  List<String> openquestionexpiringtitle = [];
  List<String> openquestionexpiringtime = [];
  List<String> openquestionpostedtime = [];
  List<int> openquestionviews = [];
  List<int> openquestioncomments = [];
  List<String> openquestionuserid = [];
  List<String> openquestionlikescount = [];
  List<String> openquestionisliked = [];
  List<String> openquestionfileextension = [];
  List<String> openquestioncommunityid = [];
  List<String> openquestionisreported = [];

  List<String> completedquestionid = [];
  List<String> completedquestionlikescount = [];
  List<String> completedquestionslist = [];
  List<String> completedquestionimageurl = [];
  List<String> completedquestioncommunity = [];
  List<String> completedquestionusername = [];
  List<String> completedquestionuseridlist = [];
  List<String> completedquestionprofileimageurl = [];
  List<String> completedquestionexpiringtitle = [];
  List<String> completedquestionexpiringtime = [];
  List<String> completedquestionpostedtime = [];
  List<int> completedquestionviews = [];
  List<int> completedquestioncomments = [];
  List<String> completedquestionfileextension = [];
  List<String> completedquestioncommunityid = [];
  List<String> completedquestionuserid = [];
  List<String> completedquestionisliked = [];
  List<String> completedquestionisreported = [];
  List<String> completedquestionreportedname = [];

  List<String> draftquestionid = [];
  List<String> draftquestionslist = [];
  List<String> draftquestionimageurl = [];
  List<String> draftquestioncommunity = [];
  List<String> draftquestionpostedtime = [];
  List<String> draftquestionfileextension = [];
  List<String> draftquestioncommunityid = [];
  int _selectedTabbar = 0;
  bool showsearchbar = false;
  List<String> _searchquestionlist = [];
  List<String> _searchquestionlikescount = [];
  List<String> _searchquestionid = [];
  List<String> _searchquestionimageurl = [];
  List<String> _searchquestioncommunity = [];
  List<String> _searchquestionusername = [];
  List<String> _searchquestionuseridlist = [];
  List<String> _searchquestionprofileimageurl = [];
  List<String> _searchquestionexpiringtitle = [];
  List<String> _searchquestionexpiringtime = [];
  List<String> _searchquestionpostedtime = [];
  List<int> _searchquestionviews = [];
  List<int> _searchquestioncomments = [];
  List<String> _searchquestionfileextension = [];
  List<String> _searchquestioncommunityid = [];
  List<String> _searchquestionuserid = [];
  List<String> _searchquestionisliked = [];
  List<String> _searchquestionisreported = [];
  List<String> _searchquestionreportedname = [];

  List<String> tempquestionlist = [];
  List<String> tempquestionlikescount = [];
  List<String> tempquestionid = [];
  List<String> tempquestionimageurl = [];
  List<String> tempquestioncommunity = [];
  List<String> tempquestionusername = [];
  List<String> tempquestionuseridlist = [];
  List<String> tempquestionprofileimageurl = [];
  List<String> tempquestionexpiringtitle = [];
  List<String> tempquestionexpiringtime = [];
  List<String> tempquestionpostedtime = [];
  List<int> tempquestionviews = [];
  List<int> tempquestioncomments = [];
  List<String> tempquestionfileextension = [];
  List<String> tempquestioncommunityid = [];
  List<String> tempquestionuserid = [];
  List<String> tempquestionisliked = [];
  List<String> tempquestionisreported = [];
  List<String> tempquestionreportedname = [];

  List<String> sortbyquestionlist = [];
  List<String> sortbyquestionid = [];
  List<String> sortbyquestionimageurl = [];
  List<String> sortbyquestioncommunity = [];
  List<String> sortbyquestionusername = [];
  List<String> sortbyquestionuseridlist = [];
  List<String> sortbyquestionprofileimageurl = [];
  List<String> sortbyquestionexpiringtitle = [];
  List<String> sortbyquestionexpiringtime = [];
  List<String> sortbyquestionpostedtime = [];
  List<int> sortbyquestionviews = [];
  List<int> sortbyquestioncomments = [];
  List<String> sortbyquestionfileextension = [];
  List<String> sortbyquestioncommunityid = [];
  List<String> sortbyquestionuserid = [];
  List<String> sortbyquestionlikescount = [];
  List<String> sortbyquestionisliked = [];
  List<String> sortbyquestionisreported = [];
  List<String> sortbyquestionreportedname = [];
  AppBar appbar = AppBar();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getuserdata();
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
              child: Image.asset(
                'images/menu.png',
                color: kBackgroundColor,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        drawer: Drawer(child: SideBar()),
        bottomNavigationBar: getbottomnavigation(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'images/BG.jpg',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Center(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      "My DI Dashboard",
                      style: TextStyle(
                          color: kBackgroundColor,
                          fontSize: MediaQuery.of(context).size.width * 0.063,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ),
              ]),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (showsearchbar) {
                          showsearchbar = false;
                        } else {
                          showsearchbar = true;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.width * 0.15,
                        child: const Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Icon(Icons.search)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                          color: kBackgroundColor,
                          border: Border.all(
                              //color: kBluePrimaryColor,
                              ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 2.0,
                            ),
                          ],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      //height: MediaQuery.of(context).size.height * 0.04,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            value: sortbycounter == 0
                                ? sortBylist[0]
                                : sortBylist[sortbycounter],
                            items: sortBylist.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: const Text(
                              "Sort By",
                              style: TextStyle(color: kBluePrimaryColor),
                            ),
                            onChanged: (value) {
                              setState(() {
                                sortbycounter =
                                    sortBylist.indexOf(value.toString());
                                if (sortbycounter == 1) {
                                  //Private
                                  cleartemplist();
                                  getprivatequestions();
                                  if (controller.text.isNotEmpty) {
                                    onSearchTextChanged(controller.text);
                                  }
                                  cleardata();
                                  _enabled = true;
                                  getuserdata();
                                } else if (sortbycounter == 2) {
                                  //Community
                                  cleartemplist();
                                  getcommunityquestions();
                                  if (controller.text.isNotEmpty) {
                                    onSearchTextChanged(controller.text);
                                  }
                                  print('Community');
                                } else if (sortbycounter == 0) {
                                  cleardata();
                                  cleartemplist();
                                  _enabled = true;
                                  getuserdata();
                                  if (controller.text.isNotEmpty) {
                                    onSearchTextChanged(controller.text);
                                  }
                                } else if (sortbycounter == 3) {
                                  //postedbyme
                                  cleartemplist();
                                  getpostedbymequestions();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              showsearchbar
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Card(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: ListTile(
                            leading: const Icon(Icons.search),
                            title: TextField(
                              controller: controller,
                              decoration: const InputDecoration(
                                  hintText: 'Search', border: InputBorder.none),
                              //onChanged: onSearchTextChanged,
                              onSubmitted: (value) {
                                onSearchTextChanged(value);
                              },
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  controller.clear();
                                  onSearchTextChanged('');
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              Container(
                child: TabBar(
                  indicatorColor: kBluePrimaryColor,
                  labelColor: kBluePrimaryColor,
                  unselectedLabelColor: Colors.grey,
                  onTap: (index) {
                    print('Index');
                    print(index);
                    setState(() {
                      _selectedTabbar = index;
                      if (_selectedTabbar == 2) {
                        print('Before');
                        print(sortbycounter);
                        sortBylist.removeAt(3);
                        print('After');
                        print(sortbycounter);
                        if (sortbycounter == 3) {
                          sortbycounter = 0;
                        }
                      } else {
                        if (sortBylist.length != 4) {
                          sortBylist.add('Posted By Me');
                        }
                      }
                      if (sortbycounter == 1) {
                        cleartemplist();
                        print('Lenght of temp: ${tempquestionlist.length}');
                        getprivatequestions();
                      } else if (sortbycounter == 2) {
                        cleartemplist();
                        print('Lenght of temp: ${tempquestionlist.length}');
                        getcommunityquestions();
                      } else if (sortbycounter == 0) {
                        cleardata();
                        _enabled = true;
                        getuserdata();
                      }
                    });
                  },
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      text: 'Open',
                    ),
                    Tab(
                      text: 'Completed',
                    ),
                    Tab(
                      text: 'Draft',
                    ),
                  ],
                ),
              ),
              displayquestions(),
            ],
          ),
        ));
  }

  getbottomnavigation() {
    return BottomNavyBar(
      showElevation: true,
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        setState(() {
          selectedIndex = index;
          if (selectedIndex == 3) {
            Navigator.of(context)
                .pushReplacement(
                    MaterialPageRoute(builder: (context) => PersonalProfile()));
          } else if (selectedIndex == 1) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => PostQuestion()));
          } else if (selectedIndex == 0) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
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

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        cleardata();
        _enabled = true;
        getuserdata();
      });
      return;
    } else {
      setState(() {
        if (_selectedTabbar == 0) {
          clearsearchdata();

          if (sortbycounter != 0) {
            makesortbyquestiondata();
            _searchquestionlist = sortbyquestionlist
                .where((string) =>
                    string.toLowerCase().contains(text.toLowerCase()))
                .toList();
            for (int i = 0; i < _searchquestionlist.length; i++) {
              for (int j = 0; j < sortbyquestionlist.length; i++) {
                if (_searchquestionlist[i] == sortbyquestionlist[j]) {
                  _searchquestionreportedname
                      .add(sortbyquestionreportedname[j]);
                  _searchquestionisreported.add(sortbyquestionisreported[j]);
                  _searchquestionisliked.add(sortbyquestionisliked[j]);
                  _searchquestionlikescount.add(sortbyquestionlikescount[j]);
                  _searchquestioncomments.add(sortbyquestioncomments[j]);
                  _searchquestioncommunity.add(sortbyquestioncommunity[j]);
                  _searchquestioncommunityid.add(sortbyquestioncommunityid[j]);
                  _searchquestionexpiringtime
                      .add(sortbyquestionexpiringtime[j]);
                  _searchquestionexpiringtitle
                      .add(sortbyquestionexpiringtitle[j]);
                  _searchquestionfileextension
                      .add(sortbyquestionfileextension[j]);
                  _searchquestionid.add(sortbyquestionid[j]);
                  _searchquestionimageurl.add(sortbyquestionimageurl[j]);
                  _searchquestionpostedtime.add(sortbyquestionpostedtime[j]);
                  _searchquestionprofileimageurl
                      .add(sortbyquestionprofileimageurl[j]);
                  _searchquestionuseridlist.add(sortbyquestionuseridlist[j]);
                  _searchquestionusername.add(sortbyquestionusername[j]);
                  _searchquestionviews.add(sortbyquestionviews[j]);
                  _searchquestionuserid.add(sortbyquestionuserid[j]);
                  clearsortbydata(j);
                }
              }
            }
          } else {
            _searchquestionlist = openquestionslist
                .where((string) =>
                    string.toLowerCase().contains(text.toLowerCase()))
                .toList();
            maketempopenquestiondata();
            for (int i = 0; i < _searchquestionlist.length; i++) {
              for (int j = 0; j < tempquestionlist.length; i++) {
                if (_searchquestionlist[i] == tempquestionlist[j]) {
                  _searchquestionreportedname.add(tempquestionreportedname[j]);
                  _searchquestionisreported.add(tempquestionisreported[j]);
                  _searchquestionisliked.add(tempquestionisliked[j]);
                  _searchquestionlikescount.add(tempquestionlikescount[j]);
                  _searchquestionuserid.add(tempquestionuserid[j]);
                  _searchquestioncomments.add(tempquestioncomments[j]);
                  _searchquestioncommunity.add(tempquestioncommunity[j]);
                  _searchquestioncommunityid.add(tempquestioncommunityid[j]);
                  _searchquestionexpiringtime.add(tempquestionexpiringtime[j]);
                  _searchquestionexpiringtitle
                      .add(tempquestionexpiringtitle[j]);
                  _searchquestionfileextension
                      .add(tempquestionfileextension[j]);
                  _searchquestionid.add(tempquestionid[j]);
                  _searchquestionimageurl.add(tempquestionimageurl[j]);
                  _searchquestionpostedtime.add(tempquestionpostedtime[j]);
                  _searchquestionprofileimageurl
                      .add(tempquestionprofileimageurl[j]);
                  _searchquestionuseridlist.add(tempquestionuseridlist[j]);
                  _searchquestionusername.add(tempquestionusername[j]);
                  _searchquestionviews.add(tempquestionviews[j]);
                  cleartempdata(j);
                }
              }
            }
          }

          cleardata();
          _enabled = true;
          getuserdata();
        } else if (_selectedTabbar == 1) {
          clearsearchdata();

          if (sortbycounter != 0) {
            makesortbyquestiondata();
            _searchquestionlist = sortbyquestionlist
                .where((string) =>
                    string.toLowerCase().contains(text.toLowerCase()))
                .toList();
            for (int i = 0; i < _searchquestionlist.length; i++) {
              for (int j = 0; j < sortbyquestionlist.length; j++) {
                if (_searchquestionlist[i] == sortbyquestionlist[j]) {
                  _searchquestionreportedname
                      .add(sortbyquestionreportedname[j]);
                  _searchquestionisreported.add(sortbyquestionisreported[j]);
                  _searchquestionisliked.add(sortbyquestionisliked[j]);
                  _searchquestionlikescount.add(sortbyquestionlikescount[j]);
                  _searchquestionuserid.add(sortbyquestionuserid[j]);
                  _searchquestioncomments.add(sortbyquestioncomments[j]);
                  _searchquestioncommunity.add(sortbyquestioncommunity[j]);
                  _searchquestioncommunityid.add(sortbyquestioncommunityid[j]);
                  _searchquestionexpiringtime
                      .add(sortbyquestionexpiringtime[j]);
                  _searchquestionexpiringtitle
                      .add(sortbyquestionexpiringtitle[j]);
                  _searchquestionfileextension
                      .add(sortbyquestionfileextension[j]);
                  _searchquestionid.add(sortbyquestionid[j]);
                  _searchquestionimageurl.add(sortbyquestionimageurl[j]);
                  _searchquestionpostedtime.add(sortbyquestionpostedtime[j]);
                  _searchquestionprofileimageurl
                      .add(sortbyquestionprofileimageurl[j]);
                  _searchquestionuseridlist.add(sortbyquestionuseridlist[j]);
                  _searchquestionusername.add(sortbyquestionusername[j]);
                  _searchquestionviews.add(sortbyquestionviews[j]);
                  clearsortbydata(j);
                }
              }
            }
          } else {
            _searchquestionlist = completedquestionslist
                .where((string) =>
                    string.toLowerCase().contains(text.toLowerCase()))
                .toList();
            maketempcompletedquestiondata();
            for (int i = 0; i < _searchquestionlist.length; i++) {
              for (int j = 0; j < tempquestionlist.length; j++) {
                if (_searchquestionlist[i] == tempquestionlist[j]) {
                  _searchquestionreportedname.add(tempquestionreportedname[j]);
                  _searchquestionisreported.add(tempquestionisreported[j]);
                  _searchquestionisliked.add(tempquestionisliked[j]);
                  _searchquestionlikescount.add(tempquestionlikescount[j]);
                  _searchquestionuserid.add(tempquestionuserid[j]);
                  _searchquestioncomments.add(tempquestioncomments[j]);
                  _searchquestioncommunity.add(tempquestioncommunity[j]);
                  _searchquestioncommunityid.add(tempquestioncommunityid[j]);
                  _searchquestionexpiringtime.add(tempquestionexpiringtime[j]);
                  _searchquestionexpiringtitle
                      .add(tempquestionexpiringtitle[j]);
                  _searchquestionfileextension
                      .add(tempquestionfileextension[j]);
                  _searchquestionid.add(tempquestionid[j]);
                  _searchquestionimageurl.add(tempquestionimageurl[j]);
                  _searchquestionpostedtime.add(tempquestionpostedtime[j]);
                  _searchquestionprofileimageurl
                      .add(tempquestionprofileimageurl[j]);
                  _searchquestionuseridlist.add(tempquestionuseridlist[j]);
                  _searchquestionusername.add(tempquestionusername[j]);
                  _searchquestionviews.add(tempquestionviews[j]);
                  cleartempdata(j);
                }
              }
            }
          }

          cleardata();
          _enabled = true;
          getuserdata();
        } else if (_selectedTabbar == 2) {
          clearsearchdata();
          print(_searchquestionlist);
          if (sortbycounter != 0) {
            makesortbytempdraftquestiondata();
            print(sortbyquestionlist);
            _searchquestionlist = sortbyquestionlist
                .where((string) =>
                    string.toLowerCase().contains(text.toLowerCase()))
                .toList();
            print('Search List');
            print(_searchquestionlist);
            for (int i = 0; i < _searchquestionlist.length; i++) {
              for (int j = 0; j < sortbyquestionlist.length; j++) {
                if (_searchquestionlist[i] == tempquestionlist[j]) {
                  print('In If');
                  _searchquestioncommunity.add(sortbyquestioncommunity[j]);
                  _searchquestioncommunityid.add(sortbyquestioncommunityid[j]);
                  _searchquestionfileextension
                      .add(sortbyquestionfileextension[j]);
                  _searchquestionid.add(sortbyquestionid[j]);
                  _searchquestionimageurl.add(sortbyquestionimageurl[j]);
                  _searchquestionpostedtime.add(sortbyquestionpostedtime[j]);
                  clearsortbydraftdata(j);
                }
              }
            }
          } else {
            _searchquestionlist = draftquestionslist
                .where((string) =>
                    string.toLowerCase().contains(text.toLowerCase()))
                .toList();
            maketempdraftquestiondata();
            for (int i = 0; i < _searchquestionlist.length; i++) {
              for (int j = 0; j < tempquestionlist.length; j++) {
                if (_searchquestionlist[i] == tempquestionlist[j]) {
                  _searchquestioncommunity.add(tempquestioncommunity[j]);
                  _searchquestioncommunityid.add(tempquestioncommunityid[j]);
                  _searchquestionfileextension
                      .add(tempquestionfileextension[j]);
                  _searchquestionid.add(tempquestionid[j]);
                  _searchquestionimageurl.add(tempquestionimageurl[j]);
                  _searchquestionpostedtime.add(tempquestionpostedtime[j]);
                  cleartempdraftdata(j);
                }
              }
            }
          }

          cleardata();
          _enabled = true;
          getuserdata();
        }
      });
    }
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedquestion = prefs.getString('QuestionPosted');

    if (shareduserid == null) {
      showlogindialog();
    }

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
      if (sharedquestion != null) {
        print('In snack');
        _selectedTabbar = 2;
        _tabController.index = 2;
        print(_selectedTabbar);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(sharedquestion),
        ));
        prefs.remove('QuestionPosted');
      } else {
        print('In null');
      }
      getdashboarddata();
    });
    print('coming from shared preference $email$userid$name');
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

  void getdashboarddata() async {
    var body = {"flag": "dashboard_data"};
    var response = await http.post(Uri.parse('$apiurl/getHomeData'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      setState(() {
        DashboardApi dashboardApi = dashboardApiFromJson(response.body);
        List<Question> openquestionslistapi = dashboardApi.openQuestions;
        for (int i = 0; i < openquestionslistapi.length; i++) {
          openquestionisreported.add(openquestionslistapi[i].isAbused ?? "");
          openquestionisliked.add(openquestionslistapi[i].isLike ?? "");
          openquestionid.add(openquestionslistapi[i].id);
          openquestionslist.add(openquestionslistapi[i].questionText);
          openquestionimageurl.add(openquestionslistapi[i].imageVideoUrl ?? "");
          openquestionlikescount.add(openquestionslistapi[i].likes.toString());
          openquestionuseridlist.add(openquestionslistapi[i].userId);
          openquestionusername.add(openquestionslistapi[i].displayName);
          openquestionreportedname.add(openquestionslistapi[i].userName);
          openquestionprofileimageurl
              .add(openquestionslistapi[i].profileImageUrl ?? "");
          openquestionpostedtime.add(openquestionslistapi[i].postedTime);
          openquestionexpiringtitle.add(openquestionslistapi[i].expireTitle);
          openquestionexpiringtime.add(openquestionslistapi[i].expireTime);
          openquestioncomments.add(openquestionslistapi[i].comments);
          openquestionviews.add(openquestionslistapi[i].views);
          openquestionfileextension.add(openquestionslistapi[i].fileExtention);
          openquestionuserid.add(openquestionslistapi[i].userId);
          List<Community> community = openquestionslistapi[i].community;
          tempcommlist = "";
          tempcommidlist = "";
          for (int j = 0; j < community.length; j++) {
            if (j + 1 == community.length) {
              tempcommlist = tempcommlist + community[j].name;
              tempcommidlist = tempcommidlist + community[j].id;
            } else {
              tempcommidlist = "$tempcommidlist${community[j].id}, ";
              tempcommlist = "$tempcommlist${community[j].name}, ";
            }
          }
          openquestioncommunity.add(tempcommlist);
          openquestioncommunityid.add(tempcommidlist);
        }
        print('In completed');
        print(openquestioncommunity);
        for (int i = 0; i < openquestioncommunity.length; i++) {
          if (openquestioncommunity[i] == '') {
            openquestioncommunity[i] = "Private";
          }
        }
        print(openquestioncommunity);

        List<Question> completedquestionlistapi =
            dashboardApi.completedQuestions;
        for (int i = 0; i < completedquestionlistapi.length; i++) {
          completedquestionreportedname
              .add(completedquestionlistapi[i].userName);
          completedquestionisreported
              .add(completedquestionlistapi[i].isAbused ?? "");
          completedquestionisliked.add(completedquestionlistapi[i].isLike ?? "");
          completedquestionlikescount
              .add(completedquestionlistapi[i].likes.toString());
          completedquestionid.add(completedquestionlistapi[i].id);
          completedquestionslist.add(completedquestionlistapi[i].questionText);
          completedquestionimageurl
              .add(completedquestionlistapi[i].imageVideoUrl ?? "");
          completedquestionuseridlist.add(completedquestionlistapi[i].userId);
          completedquestionusername
              .add(completedquestionlistapi[i].displayName);
          completedquestionprofileimageurl
              .add(completedquestionlistapi[i].profileImageUrl ?? "");
          completedquestionpostedtime
              .add(completedquestionlistapi[i].postedTime);
          completedquestionexpiringtitle
              .add(completedquestionlistapi[i].expireTitle);
          completedquestionexpiringtime
              .add(completedquestionlistapi[i].expireTime);
          completedquestioncomments.add(completedquestionlistapi[i].comments);
          completedquestionviews.add(completedquestionlistapi[i].views);
          completedquestionfileextension
              .add(completedquestionlistapi[i].fileExtention);
          completedquestionuserid.add(completedquestionlistapi[i].userId);
          List<Community> community = completedquestionlistapi[i].community;
          tempcommlist = "";
          tempcommidlist = "";
          for (int j = 0; j < community.length; j++) {
            if (j + 1 == community.length) {
              tempcommlist = tempcommlist + community[j].name;
              tempcommidlist = tempcommidlist + community[j].id;
            } else {
              tempcommidlist = "$tempcommidlist${community[j].id}, ";
              tempcommlist = "$tempcommlist${community[j].name}, ";
            }
          }
          completedquestioncommunity.add(tempcommlist);
          completedquestioncommunityid.add(tempcommidlist);
        }
        for (int i = 0; i < completedquestioncommunity.length; i++) {
          if (completedquestioncommunity[i] == '') {
            completedquestioncommunity[i] = "Private";
          }
        }
        List<DraftQuestion> draftquestionlistapi = dashboardApi.draftQuestions;
        for (int i = 0; i < draftquestionlistapi.length; i++) {
          draftquestionid.add(draftquestionlistapi[i].id);
          draftquestionslist.add(draftquestionlistapi[i].questionText);
          draftquestionimageurl.add(draftquestionlistapi[i].imageVideoUrl ?? "");
          draftquestionpostedtime
              .add(draftquestionlistapi[i].postedTime.toString());
          draftquestionfileextension.add(draftquestionlistapi[i].fileExtention.toLowerCase());
          List<Community> community = draftquestionlistapi[i].community;
          tempcommlist = "";
          tempcommidlist = "";
          for (int j = 0; j < community.length; j++) {
            if (j + 1 == community.length) {
              tempcommlist = tempcommlist + community[j].name;
              tempcommidlist = tempcommidlist + community[j].id;
            } else {
              tempcommidlist = "$tempcommidlist${community[j].id}, ";
              tempcommlist = "$tempcommlist${community[j].name}, ";
            }
          }
          draftquestioncommunity.add(tempcommlist);
          draftquestioncommunityid.add(tempcommidlist);
          for (int k = 0; k < draftquestioncommunity.length; k++) {
            if (draftquestioncommunity[k] == '') {
              draftquestioncommunity[k] = "Private";
            }
          }
        }
        _enabled = false;
      });
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  displayquestions() {
    if (_selectedTabbar == 0) {
      return _enabled
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
                              '',
                              ''),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    }),
              ))
          : sortbycounter != 0
              ? tempquestionlist.isEmpty
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
                  : controller.text.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tempquestioncomments.length,
                              itemBuilder: (context, index) {
                                print('Temp Values');
                                print(tempquestionlikescount);
                                print('USERid');
                                var communitynames = [];
                                var communityids = [];
                                if (tempquestioncommunity[index]
                                    .contains(',')) {
                                  final split =
                                      tempquestioncommunity[index].split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      tempquestioncommunityid[index].split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(tempquestioncommunity[index]);
                                  communityids
                                      .add(tempquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    QuestionCard(
                                        tempquestionlist[index],
                                        tempquestionprofileimageurl[index],
                                        tempquestionusername[index],
                                        communitynames,
                                        tempquestionpostedtime[index],
                                        tempquestionexpiringtitle[index],
                                        tempquestionexpiringtime[index],
                                        tempquestionviews[index].toString(),
                                        tempquestioncomments[index].toString(),
                                        tempquestionimageurl[index],
                                        tempquestionfileextension[index],
                                        tempquestionid[index],
                                        communityids,
                                        tempquestionlikescount[index],
                                        tempquestionisliked[index],
                                        tempquestionisreported[index],
                                        tempquestionreportedname[index],
                                        header,
                                        name,
                                        tempquestionuseridlist[index],
                                        3,
                                        ''),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        )
                      : _searchquestionlist.isEmpty
                          ? Padding(
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
                                  itemCount: _searchquestioncomments.length,
                                  itemBuilder: (context, index) {
                                    var communitynames = [];
                                    var communityids = [];
                                    if (_searchquestioncommunity[index]
                                        .contains(',')) {
                                      final split =
                                          _searchquestioncommunity[index]
                                              .split(',');
                                      final Map<int, String> values = {
                                        for (int i = 0; i < split.length; i++)
                                          i: split[i]
                                      };
                                      final splitid =
                                          _searchquestioncommunityid[index]
                                              .split(',');
                                      final Map<int, String> valuesid = {
                                        for (int i = 0; i < splitid.length; i++)
                                          i: splitid[i]
                                      };
                                      for (int i = 0;
                                          i < valuesid.length;
                                          i++) {
                                        String trimmedvalue =
                                            valuesid[i]!.trim();
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
                                      communitynames
                                          .add(_searchquestioncommunity[index]);
                                      communityids.add(
                                          _searchquestioncommunityid[index]);
                                    }
                                    return Column(
                                      children: [
                                        QuestionCard(
                                            _searchquestionlist[index],
                                            _searchquestionprofileimageurl[
                                                index],
                                            _searchquestionusername[index],
                                            communitynames,
                                            _searchquestionpostedtime[index],
                                            _searchquestionexpiringtitle[index],
                                            _searchquestionexpiringtime[index],
                                            _searchquestionviews[index]
                                                .toString(),
                                            _searchquestioncomments[index]
                                                .toString(),
                                            _searchquestionimageurl[index],
                                            _searchquestionfileextension[index],
                                            _searchquestionid[index],
                                            communityids,
                                            _searchquestionlikescount[index],
                                            _searchquestionisliked[index],
                                            _searchquestionisreported[index],
                                            _searchquestionreportedname[index],
                                            header,
                                            name,
                                            _searchquestionuserid[index],
                                            3,
                                            ''),
                                        const SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    );
                                  }),
                            )
              : controller.text.isEmpty
                  ? openquestioncomments.isEmpty
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
                              itemCount: openquestioncomments.length,
                              itemBuilder: (context, index) {
                                var communitynames = [];
                                var communityids = [];
                                if (openquestioncommunity[index]
                                    .contains(',')) {
                                  final split =
                                      openquestioncommunity[index].split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      openquestioncommunityid[index].split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(openquestioncommunity[index]);
                                  communityids
                                      .add(openquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    QuestionCard(
                                        openquestionslist[index],
                                        openquestionprofileimageurl[index],
                                        openquestionusername[index],
                                        communitynames,
                                        openquestionpostedtime[index],
                                        openquestionexpiringtitle[index],
                                        openquestionexpiringtime[index],
                                        openquestionviews[index].toString(),
                                        openquestioncomments[index].toString(),
                                        openquestionimageurl[index],
                                        openquestionfileextension[index],
                                        openquestionid[index],
                                        communityids,
                                        openquestionlikescount[index],
                                        openquestionisliked[index],
                                        openquestionisreported[index],
                                        openquestionreportedname[index],
                                        header,
                                        name,
                                        openquestionuserid[index],
                                        3,
                                        ''),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        )
                  : _searchquestionlist.isEmpty
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
                              itemCount: _searchquestioncomments.length,
                              itemBuilder: (context, index) {
                                var communitynames = [];
                                var communityids = [];
                                if (_searchquestioncommunity[index]
                                    .contains(',')) {
                                  final split = _searchquestioncommunity[index]
                                      .split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      _searchquestioncommunityid[index]
                                          .split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(_searchquestioncommunity[index]);
                                  communityids
                                      .add(_searchquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    QuestionCard(
                                        _searchquestionlist[index],
                                        _searchquestionprofileimageurl[index],
                                        _searchquestionusername[index],
                                        communitynames,
                                        _searchquestionpostedtime[index],
                                        _searchquestionexpiringtitle[index],
                                        _searchquestionexpiringtime[index],
                                        _searchquestionviews[index].toString(),
                                        _searchquestioncomments[index]
                                            .toString(),
                                        _searchquestionimageurl[index],
                                        _searchquestionfileextension[index],
                                        _searchquestionid[index],
                                        communityids,
                                        _searchquestionlikescount[index],
                                        _searchquestionisliked[index],
                                        _searchquestionisreported[index],
                                        _searchquestionreportedname[index],
                                        header,
                                        name,
                                        _searchquestionuserid[index],
                                        3,
                                        ''),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        );
    } else if (_selectedTabbar == 1) {
      return _enabled
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
                              3,
                              ''),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    }),
              ))
          : sortbycounter != 0
              ? tempquestionlist.isEmpty
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
                  : controller.text.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tempquestioncomments.length,
                              itemBuilder: (context, index) {
                                var communitynames = [];
                                var communityids = [];
                                if (tempquestioncommunity[index]
                                    .contains(',')) {
                                  final split =
                                      tempquestioncommunity[index].split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      tempquestioncommunityid[index].split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(tempquestioncommunity[index]);
                                  communityids
                                      .add(tempquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    QuestionCard(
                                        tempquestionlist[index],
                                        tempquestionprofileimageurl[index],
                                        tempquestionusername[index],
                                        communitynames,
                                        tempquestionpostedtime[index],
                                        tempquestionexpiringtitle[index],
                                        tempquestionexpiringtime[index],
                                        tempquestionviews[index].toString(),
                                        tempquestioncomments[index].toString(),
                                        tempquestionimageurl[index],
                                        tempquestionfileextension[index],
                                        tempquestionid[index],
                                        communityids,
                                        tempquestionlikescount[index],
                                        tempquestionisliked[index],
                                        tempquestionisreported[index],
                                        tempquestionreportedname[index],
                                        header,
                                        name,
                                        tempquestionuseridlist[index],
                                        3,
                                        ''),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        )
                      : _searchquestionlist.isEmpty
                          ? Padding(
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
                                  //key: UniqueKey(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _searchquestioncomments.length,
                                  itemBuilder: (context, index) {
                                    print('HI${_searchquestionlist.length}');
                                    print(
                                        'Hey${_searchquestioncomments.length}');
                                    var communitynames = [];
                                    var communityids = [];
                                    if (_searchquestioncommunity[index]
                                        .contains(',')) {
                                      final split =
                                          _searchquestioncommunity[index]
                                              .split(',');
                                      final Map<int, String> values = {
                                        for (int i = 0; i < split.length; i++)
                                          i: split[i]
                                      };
                                      final splitid =
                                          _searchquestioncommunityid[index]
                                              .split(',');
                                      final Map<int, String> valuesid = {
                                        for (int i = 0; i < splitid.length; i++)
                                          i: splitid[i]
                                      };
                                      for (int i = 0;
                                          i < valuesid.length;
                                          i++) {
                                        String trimmedvalue =
                                            valuesid[i]!.trim();
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
                                      communitynames
                                          .add(_searchquestioncommunity[index]);
                                      communityids.add(
                                          _searchquestioncommunityid[index]);
                                    }
                                    return Column(
                                      children: [
                                        QuestionCard(
                                            _searchquestionlist[index],
                                            _searchquestionprofileimageurl[
                                                index],
                                            _searchquestionusername[index],
                                            communitynames,
                                            _searchquestionpostedtime[index],
                                            _searchquestionexpiringtitle[index],
                                            _searchquestionexpiringtime[index],
                                            _searchquestionviews[index]
                                                .toString(),
                                            _searchquestioncomments[index]
                                                .toString(),
                                            _searchquestionimageurl[index],
                                            _searchquestionfileextension[index],
                                            _searchquestionid[index],
                                            communityids,
                                            _searchquestionlikescount[index],
                                            _searchquestionisliked[index],
                                            _searchquestionisreported[index],
                                            _searchquestionreportedname[index],
                                            header,
                                            name,
                                            _searchquestionuserid[index],
                                            3,
                                            ''),
                                        const SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    );
                                  }),
                            )
              : controller.text.isEmpty
                  ? completedquestioncomments.isEmpty
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
                              itemCount: completedquestioncomments.length,
                              itemBuilder: (context, index) {
                                var communitynames = [];
                                var communityids = [];
                                if (completedquestioncommunity[index]
                                    .contains(',')) {
                                  final split =
                                      completedquestioncommunity[index]
                                          .split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      completedquestioncommunityid[index]
                                          .split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(completedquestioncommunity[index]);
                                  communityids
                                      .add(completedquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    QuestionCard(
                                        completedquestionslist[index],
                                        completedquestionprofileimageurl[index],
                                        completedquestionusername[index],
                                        communitynames,
                                        completedquestionpostedtime[index],
                                        completedquestionexpiringtitle[index],
                                        completedquestionexpiringtime[index],
                                        completedquestionviews[index]
                                            .toString(),
                                        completedquestioncomments[index]
                                            .toString(),
                                        completedquestionimageurl[index],
                                        completedquestionfileextension[index],
                                        completedquestionid[index],
                                        communityids,
                                        completedquestionlikescount[index],
                                        completedquestionisliked[index],
                                        completedquestionisreported[index],
                                        completedquestionreportedname[index],
                                        header,
                                        name,
                                        completedquestionuserid[index],
                                        3,
                                        ''),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        )
                  : _searchquestionlist.isEmpty
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
                              //key: UniqueKey(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _searchquestioncomments.length,
                              itemBuilder: (context, index) {
                                print('HI${_searchquestionlist.length}');
                                print('Hey${_searchquestioncomments.length}');
                                var communitynames = [];
                                var communityids = [];
                                if (_searchquestioncommunity[index]
                                    .contains(',')) {
                                  final split = _searchquestioncommunity[index]
                                      .split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      _searchquestioncommunityid[index]
                                          .split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(_searchquestioncommunity[index]);
                                  communityids
                                      .add(_searchquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    QuestionCard(
                                        _searchquestionlist[index],
                                        _searchquestionprofileimageurl[index],
                                        _searchquestionusername[index],
                                        communitynames,
                                        _searchquestionpostedtime[index],
                                        _searchquestionexpiringtitle[index],
                                        _searchquestionexpiringtime[index],
                                        _searchquestionviews[index].toString(),
                                        _searchquestioncomments[index]
                                            .toString(),
                                        _searchquestionimageurl[index],
                                        _searchquestionfileextension[index],
                                        _searchquestionid[index],
                                        communityids,
                                        _searchquestionlikescount[index],
                                        _searchquestionisliked[index],
                                        _searchquestionisreported[index],
                                        _searchquestionreportedname[index],
                                        header,
                                        name,
                                        _searchquestionuserid[index],
                                        3,
                                        ''),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        );
    } else if (_selectedTabbar == 2) {
      return _enabled
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
                              3,
                              ''),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      );
                    }),
              ))
          : sortbycounter != 0
              ? tempquestionlist.isEmpty
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
                  : controller.text.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: tempquestionlist.length,
                              itemBuilder: (context, index) {
                                var communitynames = [];
                                var communityids = [];
                                if (tempquestioncommunity[index]
                                    .contains(',')) {
                                  final split =
                                      tempquestioncommunity[index].split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      tempquestioncommunityid[index].split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(tempquestioncommunity[index]);
                                  communityids
                                      .add(tempquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    DraftQuestionCard(
                                        tempquestionlist[index],
                                        tempquestionid[index],
                                        tempquestionimageurl[index],
                                        tempquestionfileextension[index],
                                        communitynames,
                                        communityids,
                                        tempquestionpostedtime[index]),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        )
                      : _searchquestionlist.isEmpty
                          ? Padding(
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
                                  //key: UniqueKey(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _searchquestionlist.length,
                                  itemBuilder: (context, index) {
                                    print('HI${_searchquestionlist.length}');
                                    print(
                                        'Hey${_searchquestioncommunity.length}');
                                    var communitynames = [];
                                    var communityids = [];
                                    if (_searchquestioncommunity[index]
                                        .contains(',')) {
                                      final split =
                                          _searchquestioncommunity[index]
                                              .split(',');
                                      final Map<int, String> values = {
                                        for (int i = 0; i < split.length; i++)
                                          i: split[i]
                                      };
                                      final splitid =
                                          _searchquestioncommunityid[index]
                                              .split(',');
                                      final Map<int, String> valuesid = {
                                        for (int i = 0; i < splitid.length; i++)
                                          i: splitid[i]
                                      };
                                      for (int i = 0;
                                          i < valuesid.length;
                                          i++) {
                                        String trimmedvalue =
                                            valuesid[i]!.trim();
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
                                      communitynames
                                          .add(_searchquestioncommunity[index]);
                                      communityids.add(
                                          _searchquestioncommunityid[index]);
                                    }
                                    return Column(
                                      children: [
                                        DraftQuestionCard(
                                            _searchquestionlist[index],
                                            _searchquestionid[index],
                                            _searchquestionimageurl[index],
                                            _searchquestionfileextension[index],
                                            communitynames,
                                            communityids,
                                            _searchquestionpostedtime[index]),
                                        const SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    );
                                  }),
                            )
              : controller.text.isEmpty
                  ? draftquestionslist.isEmpty
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
                              itemCount: draftquestionslist.length,
                              itemBuilder: (context, index) {
                                var communitynames = [];
                                var communityids = [];
                                if (draftquestioncommunity[index]
                                    .contains(',')) {
                                  final split =
                                      draftquestioncommunity[index].split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      draftquestioncommunityid[index]
                                          .split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(draftquestioncommunity[index]);
                                  communityids
                                      .add(draftquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    DraftQuestionCard(
                                        draftquestionslist[index],
                                        draftquestionid[index],
                                        draftquestionimageurl[index],
                                        draftquestionfileextension[index],
                                        communitynames,
                                        communityids,
                                        draftquestionpostedtime[index]),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        )
                  : _searchquestionlist.isEmpty
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
                              //key: UniqueKey(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _searchquestionlist.length,
                              itemBuilder: (context, index) {
                                print('HI${_searchquestionlist.length}');
                                print('Hey${_searchquestioncommunity.length}');
                                var communitynames = [];
                                var communityids = [];
                                if (_searchquestioncommunity[index]
                                    .contains(',')) {
                                  final split = _searchquestioncommunity[index]
                                      .split(',');
                                  final Map<int, String> values = {
                                    for (int i = 0; i < split.length; i++)
                                      i: split[i]
                                  };
                                  final splitid =
                                      _searchquestioncommunityid[index]
                                          .split(',');
                                  final Map<int, String> valuesid = {
                                    for (int i = 0; i < splitid.length; i++)
                                      i: splitid[i]
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
                                  communitynames
                                      .add(_searchquestioncommunity[index]);
                                  communityids
                                      .add(_searchquestioncommunityid[index]);
                                }
                                return Column(
                                  children: [
                                    DraftQuestionCard(
                                        _searchquestionlist[index],
                                        _searchquestionid[index],
                                        _searchquestionimageurl[index],
                                        _searchquestionfileextension[index],
                                        communitynames,
                                        communityids,
                                        _searchquestionpostedtime[index]),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                );
                              }),
                        );
    }
  }

  void cleardata() {
    openquestionreportedname = [];
    openquestionisreported = [];
    openquestionisliked = [];
    openquestionid = [];
    openquestionslist = [];
    openquestionimageurl = [];
    openquestioncommunity = [];
    openquestionusername = [];
    openquestionprofileimageurl = [];
    openquestionexpiringtitle = [];
    openquestionexpiringtime = [];
    openquestionpostedtime = [];
    openquestionviews = [];
    openquestioncomments = [];
    openquestionlikescount = [];
    openquestionfileextension = [];
    completedquestionreportedname = [];
    completedquestionisreported = [];
    completedquestionisliked = [];
    completedquestionid = [];
    completedquestionslist = [];
    completedquestionlikescount = [];
    completedquestionimageurl = [];
    completedquestioncommunity = [];
    completedquestionusername = [];
    completedquestionprofileimageurl = [];
    completedquestionexpiringtitle = [];
    completedquestionexpiringtime = [];
    completedquestionpostedtime = [];
    completedquestionviews = [];
    completedquestioncomments = [];
    completedquestionfileextension = [];
    draftquestioncommunity.clear();
    draftquestioncommunityid.clear();
    draftquestionfileextension.clear();
    draftquestionid.clear();
    draftquestionimageurl.clear();
    draftquestionpostedtime.clear();
    draftquestionslist.clear();
  }

  void maketempopenquestiondata() {
    setState(() {
      for (int i = 0; i < openquestioncomments.length; i++) {
        tempquestionreportedname.add(openquestionreportedname[i]);
        tempquestionisreported.add(openquestionisreported[i]);
        tempquestionisliked.add(openquestionisliked[i]);
        tempquestionlikescount.add(openquestionlikescount[i]);
        tempquestioncomments.add(openquestioncomments[i]);
        tempquestioncommunity.add(openquestioncommunity[i]);
        tempquestioncommunityid.add(openquestioncommunityid[i]);
        tempquestionexpiringtime.add(openquestionexpiringtime[i]);
        tempquestionexpiringtitle.add(openquestionexpiringtitle[i]);
        tempquestionfileextension.add(openquestionfileextension[i]);
        tempquestionid.add(openquestionid[i]);
        tempquestionimageurl.add(openquestionimageurl[i]);
        tempquestionlist.add(openquestionslist[i]);
        tempquestionpostedtime.add(openquestionpostedtime[i]);
        tempquestionprofileimageurl.add(openquestionprofileimageurl[i]);
        tempquestionuseridlist.add(openquestionuseridlist[i]);
        tempquestionusername.add(openquestionusername[i]);
        tempquestionviews.add(openquestionviews[i]);
        tempquestionuserid.add(openquestionuserid[i]);
      }
    });
  }

  void maketempcompletedquestiondata() {
    setState(() {
      for (int i = 0; i < completedquestioncomments.length; i++) {
        tempquestionreportedname.add(completedquestionreportedname[i]);
        tempquestionisreported.add(completedquestionisreported[i]);
        tempquestionisliked.add(completedquestionisliked[i]);
        tempquestionlikescount.add(completedquestionlikescount[i]);
        tempquestioncomments.add(completedquestioncomments[i]);
        tempquestioncommunity.add(completedquestioncommunity[i]);
        tempquestioncommunityid.add(completedquestioncommunityid[i]);
        tempquestionexpiringtime.add(completedquestionexpiringtime[i]);
        tempquestionexpiringtitle.add(completedquestionexpiringtitle[i]);
        tempquestionfileextension.add(completedquestionfileextension[i]);
        tempquestionid.add(completedquestionid[i]);
        tempquestionimageurl.add(completedquestionimageurl[i]);
        tempquestionlist.add(completedquestionslist[i]);
        tempquestionpostedtime.add(completedquestionpostedtime[i]);
        tempquestionprofileimageurl.add(completedquestionprofileimageurl[i]);
        tempquestionuseridlist.add(completedquestionuseridlist[i]);
        tempquestionusername.add(completedquestionusername[i]);
        tempquestionviews.add(completedquestionviews[i]);
        tempquestionuserid.add(completedquestionuserid[i]);
      }
    });
  }

  void maketempdraftquestiondata() {
    setState(() {
      for (int i = 0; i < draftquestionslist.length; i++) {
        tempquestioncommunity.add(draftquestioncommunity[i]);
        tempquestioncommunityid.add(draftquestioncommunityid[i]);
        tempquestionfileextension.add(draftquestionfileextension[i]);
        tempquestionid.add(draftquestionid[i]);
        tempquestionimageurl.add(draftquestionimageurl[i]);
        tempquestionlist.add(draftquestionslist[i]);
        tempquestionpostedtime.add(draftquestionpostedtime[i]);
      }
    });
  }

  void makesortbytempdraftquestiondata() {
    setState(() {
      for (int i = 0; i < tempquestionlist.length; i++) {
        sortbyquestioncommunity.add(tempquestioncommunity[i]);
        sortbyquestioncommunityid.add(tempquestioncommunityid[i]);
        sortbyquestionfileextension.add(tempquestionfileextension[i]);
        sortbyquestionid.add(tempquestionid[i]);
        sortbyquestionimageurl.add(tempquestionimageurl[i]);
        sortbyquestionlist.add(tempquestionlist[i]);
        sortbyquestionpostedtime.add(tempquestionpostedtime[i]);
      }
    });
  }

  void makesortbyquestiondata() {
    setState(() {
      for (int i = 0; i < tempquestionlist.length; i++) {
        sortbyquestionreportedname.add(tempquestionreportedname[i]);
        sortbyquestionisreported.add(tempquestionisreported[i]);
        sortbyquestionisliked.add(tempquestionisliked[i]);
        sortbyquestionlikescount.add(tempquestionlikescount[i]);
        sortbyquestioncommunity.add(tempquestioncommunity[i]);
        sortbyquestioncommunityid.add(tempquestioncommunityid[i]);
        sortbyquestionfileextension.add(tempquestionfileextension[i]);
        sortbyquestionid.add(tempquestionid[i]);
        sortbyquestionimageurl.add(tempquestionimageurl[i]);
        sortbyquestionlist.add(tempquestionlist[i]);
        sortbyquestionpostedtime.add(tempquestionpostedtime[i]);
        sortbyquestioncomments.add(tempquestioncomments[i]);
        sortbyquestionexpiringtime.add(tempquestionexpiringtime[i]);
        sortbyquestionexpiringtitle.add(tempquestionexpiringtitle[i]);
        sortbyquestionprofileimageurl.add(tempquestionprofileimageurl[i]);
        sortbyquestionuseridlist.add(tempquestionuseridlist[i]);
        sortbyquestionusername.add(tempquestionusername[i]);
        sortbyquestionviews.add(tempquestionviews[i]);
      }
    });
  }

  void cleartempdata(int j) {
    tempquestionreportedname.removeAt(j);
    tempquestionisreported.removeAt(j);
    tempquestionuserid.removeAt(j);
    tempquestionisliked.removeAt(j);
    tempquestioncomments.removeAt(j);
    tempquestioncommunity.removeAt(j);
    tempquestioncommunityid.removeAt(j);
    tempquestionexpiringtime.removeAt(j);
    tempquestionexpiringtitle.removeAt(j);
    tempquestionfileextension.removeAt(j);
    tempquestionid.removeAt(j);
    tempquestionimageurl.removeAt(j);
    tempquestionlist.removeAt(j);
    tempquestionlikescount.removeAt(j);
    tempquestionpostedtime.removeAt(j);
    tempquestionprofileimageurl.removeAt(j);
    tempquestionuseridlist.removeAt(j);
    tempquestionusername.removeAt(j);
    tempquestionviews.removeAt(j);
    tempquestionuserid.removeAt(j);
  }

  void clearsearchdata() {
    setState(() {
      _searchquestionreportedname.clear();
      _searchquestionuserid.clear();
      _searchquestionisreported.clear();
      _searchquestionisliked.clear();
      _searchquestioncomments.clear();
      _searchquestioncommunity.clear();
      _searchquestioncommunityid.clear();
      _searchquestionexpiringtime.clear();
      _searchquestionexpiringtitle.clear();
      _searchquestionfileextension.clear();
      _searchquestionid.clear();
      _searchquestionimageurl.clear();
      _searchquestionlist.clear();
      _searchquestionlikescount.clear();
      _searchquestionpostedtime.clear();
      _searchquestionprofileimageurl.clear();
      _searchquestionuseridlist.clear();
      _searchquestionusername.clear();

      _searchquestionviews.clear();
    });
  }

  void cleartempdraftdata(int j) {
    tempquestioncommunity.removeAt(j);
    tempquestioncommunityid.removeAt(j);
    tempquestionfileextension.removeAt(j);
    tempquestionid.removeAt(j);
    tempquestionimageurl.removeAt(j);
    tempquestionlist.removeAt(j);
    tempquestionpostedtime.removeAt(j);
  }

  void clearsortbydata(int j) {
    sortbyquestionreportedname.removeAt(j);
    sortbyquestionisreported.removeAt(j);
    sortbyquestionisliked.removeAt(j);
    sortbyquestionlikescount.removeAt(j);
    sortbyquestioncomments.removeAt(j);
    sortbyquestioncommunity.removeAt(j);
    sortbyquestioncommunityid.removeAt(j);
    sortbyquestionexpiringtime.removeAt(j);
    sortbyquestionexpiringtitle.removeAt(j);
    sortbyquestionfileextension.removeAt(j);
    sortbyquestionid.removeAt(j);
    sortbyquestionimageurl.removeAt(j);
    sortbyquestionlist.removeAt(j);
    sortbyquestionpostedtime.removeAt(j);
    sortbyquestionprofileimageurl.removeAt(j);
    sortbyquestionuseridlist.removeAt(j);
    sortbyquestionusername.removeAt(j);
    sortbyquestionviews.removeAt(j);
    sortbyquestionuserid.removeAt(j);
  }

  void clearsortbydraftdata(int j) {
    sortbyquestioncommunity.removeAt(j);
    sortbyquestioncommunityid.removeAt(j);
    sortbyquestionfileextension.removeAt(j);
    sortbyquestionid.removeAt(j);
    sortbyquestionimageurl.removeAt(j);
    sortbyquestionlist.removeAt(j);
    sortbyquestionpostedtime.removeAt(j);
  }

  void getprivatequestions() {
    if (_selectedTabbar == 0) {
      for (int i = 0; i < openquestioncomments.length; i++) {
        if (openquestioncommunity[i] == "Private") {
          tempquestionreportedname.add(openquestionreportedname[i]);
          tempquestionisreported.add(openquestionisreported[i]);
          tempquestionisliked.add(openquestionisliked[i]);
          tempquestionlikescount.add(openquestionlikescount[i]);
          tempquestioncomments.add(openquestioncomments[i]);
          tempquestioncommunity.add(openquestioncommunity[i]);
          tempquestioncommunityid.add(openquestioncommunityid[i]);
          tempquestionexpiringtime.add(openquestionexpiringtime[i]);
          tempquestionexpiringtitle.add(openquestionexpiringtitle[i]);
          tempquestionfileextension.add(openquestionfileextension[i]);
          tempquestionid.add(openquestionid[i]);
          tempquestionimageurl.add(openquestionimageurl[i]);
          tempquestionlist.add(openquestionslist[i]);
          tempquestionpostedtime.add(openquestionpostedtime[i]);
          tempquestionprofileimageurl.add(openquestionprofileimageurl[i]);
          tempquestionuseridlist.add(openquestionuseridlist[i]);
          tempquestionusername.add(openquestionusername[i]);
          tempquestionviews.add(openquestionviews[i]);
        }
      }
    } else if (_selectedTabbar == 1) {
      print('In Private completed');
      for (int i = 0; i < completedquestioncomments.length; i++) {
        if (completedquestioncommunity[i] == "Private") {
          tempquestionreportedname.add(completedquestionreportedname[i]);
          tempquestionisreported.add(completedquestionisreported[i]);
          tempquestionisliked.add(completedquestionisliked[i]);
          tempquestionlikescount.add(completedquestionlikescount[i]);
          tempquestioncomments.add(completedquestioncomments[i]);
          tempquestioncommunity.add(completedquestioncommunity[i]);
          tempquestioncommunityid.add(completedquestioncommunityid[i]);
          tempquestionexpiringtime.add(completedquestionexpiringtime[i]);
          tempquestionexpiringtitle.add(completedquestionexpiringtitle[i]);
          tempquestionfileextension.add(completedquestionfileextension[i]);
          tempquestionid.add(completedquestionid[i]);
          tempquestionimageurl.add(completedquestionimageurl[i]);
          tempquestionlist.add(completedquestionslist[i]);
          tempquestionpostedtime.add(completedquestionpostedtime[i]);
          tempquestionprofileimageurl.add(completedquestionprofileimageurl[i]);
          tempquestionuseridlist.add(completedquestionuseridlist[i]);
          tempquestionusername.add(completedquestionusername[i]);
          tempquestionviews.add(completedquestionviews[i]);
        }
      }
    } else if (_selectedTabbar == 2) {
      print('In Private outside');
      for (int i = 0; i < draftquestionslist.length; i++) {
        if (draftquestioncommunity[i] == "Private") {
          print('In Private');
          tempquestioncommunity.add(draftquestioncommunity[i]);
          tempquestioncommunityid.add(draftquestioncommunityid[i]);
          tempquestionfileextension.add(draftquestionfileextension[i]);
          tempquestionid.add(draftquestionid[i]);
          tempquestionimageurl.add(draftquestionimageurl[i]);
          tempquestionlist.add(draftquestionslist[i]);
          tempquestionpostedtime.add(draftquestionpostedtime[i]);
        }
      }
      print(tempquestionlist);
    }
  }

  void getcommunityquestions() {
    if (_selectedTabbar == 0) {
      for (int i = 0; i < openquestioncomments.length; i++) {
        if (openquestioncommunity[i] != "Private") {
          tempquestionreportedname.add(openquestionreportedname[i]);
          tempquestionisreported.add(openquestionisreported[i]);
          tempquestionisliked.add(openquestionisliked[i]);
          tempquestionlikescount.add(openquestionlikescount[i]);
          tempquestioncomments.add(openquestioncomments[i]);
          tempquestioncommunity.add(openquestioncommunity[i]);
          tempquestioncommunityid.add(openquestioncommunityid[i]);
          tempquestionexpiringtime.add(openquestionexpiringtime[i]);
          tempquestionexpiringtitle.add(openquestionexpiringtitle[i]);
          tempquestionfileextension.add(openquestionfileextension[i]);
          tempquestionid.add(openquestionid[i]);
          tempquestionimageurl.add(openquestionimageurl[i]);
          tempquestionlist.add(openquestionslist[i]);
          tempquestionpostedtime.add(openquestionpostedtime[i]);
          tempquestionprofileimageurl.add(openquestionprofileimageurl[i]);
          tempquestionuseridlist.add(openquestionuseridlist[i]);
          tempquestionusername.add(openquestionusername[i]);
          tempquestionviews.add(openquestionviews[i]);
        }
      }
    } else if (_selectedTabbar == 1) {
      for (int i = 0; i < completedquestioncomments.length; i++) {
        if (completedquestioncommunity[i] != "Private") {
          tempquestionreportedname.add(completedquestionreportedname[i]);
          tempquestionisreported.add(completedquestionisreported[i]);
          tempquestionisliked.add(completedquestionisliked[i]);
          tempquestionlikescount.add(completedquestionlikescount[i]);
          tempquestioncomments.add(completedquestioncomments[i]);
          tempquestioncommunity.add(completedquestioncommunity[i]);
          tempquestioncommunityid.add(completedquestioncommunityid[i]);
          tempquestionexpiringtime.add(completedquestionexpiringtime[i]);
          tempquestionexpiringtitle.add(completedquestionexpiringtitle[i]);
          tempquestionfileextension.add(completedquestionfileextension[i]);
          tempquestionid.add(completedquestionid[i]);
          tempquestionimageurl.add(completedquestionimageurl[i]);
          tempquestionlist.add(completedquestionslist[i]);
          tempquestionpostedtime.add(completedquestionpostedtime[i]);
          tempquestionprofileimageurl.add(completedquestionprofileimageurl[i]);
          tempquestionuseridlist.add(completedquestionuseridlist[i]);
          tempquestionusername.add(completedquestionusername[i]);
          tempquestionviews.add(completedquestionviews[i]);
        }
      }
      cleardata();
      _enabled = true;
      getuserdata();
    } else if (_selectedTabbar == 2) {
      print('In Private outside');
      for (int i = 0; i < draftquestionslist.length; i++) {
        if (draftquestioncommunity[i] != "Private") {
          print('In Private');
          tempquestioncommunity.add(draftquestioncommunity[i]);
          tempquestioncommunityid.add(draftquestioncommunityid[i]);
          tempquestionfileextension.add(draftquestionfileextension[i]);
          tempquestionid.add(draftquestionid[i]);
          tempquestionimageurl.add(draftquestionimageurl[i]);
          tempquestionlist.add(draftquestionslist[i]);
          tempquestionpostedtime.add(draftquestionpostedtime[i]);
        }
      }
      print(tempquestionlist);
      cleardata();
      _enabled = true;
      getuserdata();
    }
  }

  void getpostedbymequestions() {
    if (_selectedTabbar == 0) {
      for (int i = 0; i < openquestioncomments.length; i++) {
        if (openquestionuseridlist[i] == userid) {
          tempquestionreportedname.add(openquestionreportedname[i]);
          tempquestionisreported.add(openquestionisreported[i]);
          tempquestionisliked.add(openquestionisliked[i]);
          tempquestionlikescount.add(openquestionlikescount[i]);
          tempquestioncomments.add(openquestioncomments[i]);
          tempquestioncommunity.add(openquestioncommunity[i]);
          tempquestioncommunityid.add(openquestioncommunityid[i]);
          tempquestionexpiringtime.add(openquestionexpiringtime[i]);
          tempquestionexpiringtitle.add(openquestionexpiringtitle[i]);
          tempquestionfileextension.add(openquestionfileextension[i]);
          tempquestionid.add(openquestionid[i]);
          tempquestionimageurl.add(openquestionimageurl[i]);
          tempquestionlist.add(openquestionslist[i]);
          tempquestionpostedtime.add(openquestionpostedtime[i]);
          tempquestionprofileimageurl.add(openquestionprofileimageurl[i]);
          tempquestionuseridlist.add(openquestionuseridlist[i]);
          tempquestionusername.add(openquestionusername[i]);
          tempquestionviews.add(openquestionviews[i]);
        }
      }
    } else if (_selectedTabbar == 1) {
      for (int i = 0; i < completedquestioncomments.length; i++) {
        if (completedquestionuseridlist[i] == userid) {
          tempquestionreportedname.add(completedquestionreportedname[i]);
          tempquestionisreported.add(completedquestionisreported[i]);
          tempquestionisliked.add(completedquestionisliked[i]);
          tempquestionlikescount.add(completedquestionlikescount[i]);
          tempquestioncomments.add(completedquestioncomments[i]);
          tempquestioncommunity.add(completedquestioncommunity[i]);
          tempquestioncommunityid.add(completedquestioncommunityid[i]);
          tempquestionexpiringtime.add(completedquestionexpiringtime[i]);
          tempquestionexpiringtitle.add(completedquestionexpiringtitle[i]);
          tempquestionfileextension.add(completedquestionfileextension[i]);
          tempquestionid.add(completedquestionid[i]);
          tempquestionimageurl.add(completedquestionimageurl[i]);
          tempquestionlist.add(completedquestionslist[i]);
          tempquestionpostedtime.add(completedquestionpostedtime[i]);
          tempquestionprofileimageurl.add(completedquestionprofileimageurl[i]);
          tempquestionuseridlist.add(completedquestionuseridlist[i]);
          tempquestionusername.add(completedquestionusername[i]);
          tempquestionviews.add(completedquestionviews[i]);
        }
      }
      cleardata();
      _enabled = true;
      getuserdata();
    }
  }

  void cleartemplist() {
    tempquestionreportedname.clear();
    tempquestionisreported.clear();
    tempquestionisliked.clear();
    tempquestioncomments.clear();
    tempquestioncommunity.clear();
    tempquestioncommunityid.clear();
    tempquestionexpiringtime.clear();
    tempquestionexpiringtitle.clear();
    tempquestionfileextension.clear();
    tempquestionid.clear();
    tempquestionimageurl.clear();
    tempquestionlist.clear();
    tempquestionlikescount.clear();
    tempquestionpostedtime.clear();
    tempquestionprofileimageurl.clear();
    tempquestionuseridlist.clear();
    tempquestionusername.clear();
    tempquestionviews.clear();
    tempquestionuserid.clear();
  }
}
