import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/GlobalSearch/GlobalSearchAPI.dart';
import 'package:decideitfinal/Home/Drawer.dart';
import 'package:decideitfinal/Home/QuestionCard.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class GlobalSearch extends StatefulWidget {
  var searchtext;
  GlobalSearch(this.searchtext, {Key? key});
  @override
  _GlobalSearchState createState() => _GlobalSearchState(searchtext);
}

class _GlobalSearchState extends State<GlobalSearch> {
  var imageurl, name, userid, header, email, searchtext;

  _GlobalSearchState(this.searchtext);
  int selectedIndex = 1;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController controller = TextEditingController();
  List<String> searchquestionid = [];
  List<String> searchquestionslist = [];
  List<String> searchquestionimageurl = [];
  List<String> searchquestioncommunity = [];
  List<String> searchquestioncommunityid = [];
  List<String> searchquestionusername = [];
  List<String> searchquestionreportedname = [];
  List<String> searchquestionprofileimageurl = [];
  List<String> searchquestionexpiringtitle = [];
  List<String> searchquestionexpiringtime = [];
  List<String> searchquestionpostedtime = [];
  List<int> searchquestionviews = [];
  List<int> searchquestioncomments = [];
  List<String> searchquestioncommunityimage = [];
  List<String> searchquestionfileextension = [];
  List<String> searchquestionuserid = [];
  List<String> searchquestionlikescount = [];
  List<String> searchquestionisliked = [];
  List<String> searchquestionisreported = [];
  String tempcommlist = "";
  String tempcommidlist = "";
  bool _enabled = true;
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  AppBar appbar = AppBar();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: <Widget>[
              Center(
                child: Image.asset(
                  'images/BG.png',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: const Text(
                    "Search for keywords across all questions",
                    style: TextStyle(
                      color: kBackgroundColor,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextFormField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      //onChanged: onSearchTextChanged,
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // if all are valid then go to success screen
                          setState(() {
                            searchtext = controller.text;
                            _enabled = true;
                            cleardata();
                            getsearchdata();
                          });
                        }
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(
                              error: 'Please enter your search keyword');
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your search keyword';
                          //addError(error: kPassNullError);

                        }
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        controller.clear();
                        searchtext = "";
                        //onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
            ),
            searchtext == ""
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchtext,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Text('Search Results')
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
                                    2,
                                    ''),
                                const SizedBox(
                                  height: 5,
                                )
                              ],
                            );
                          }),
                    ))
                : searchquestioncomments.isEmpty
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
                            itemCount: searchquestioncomments.length,
                            itemBuilder: (context, index) {
                              var communitynames = [];
                              var communityids = [];
                              if (searchquestioncommunity[index]
                                  .contains(',')) {
                                final split = searchquestioncommunity[index]
                                    .split(',');
                                final Map<int, String> values = {
                                  for (int i = 0; i < split.length; i++)
                                    i: split[i]
                                };
                                final splitid =
                                    searchquestioncommunity[index]
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
                                    .add(searchquestioncommunity[index]);
                                communityids
                                    .add(searchquestioncommunityid[index]);
                              }
                              return Column(
                                children: [
                                  QuestionCard(
                                      searchquestionslist[index],
                                      searchquestionprofileimageurl[index],
                                      searchquestionusername[index],
                                      communitynames,
                                      searchquestionpostedtime[index],
                                      searchquestionexpiringtitle[index],
                                      searchquestionexpiringtime[index],
                                      searchquestionviews[index].toString(),
                                      searchquestioncomments[index]
                                          .toString(),
                                      searchquestionimageurl[index],
                                      searchquestionfileextension[index],
                                      searchquestionid[index],
                                      communityids,
                                      searchquestionlikescount[index],
                                      searchquestionisliked[index],
                                      searchquestionisreported[index],
                                      searchquestionreportedname[index],
                                      header,
                                      name,
                                      searchquestionuserid,
                                      2,
                                      searchtext),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                            }),
                      )
          ],
        ),
      ),
    );
  }

  getbottomnavigation() {
    return BottomNavyBar(
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        setState(() {
          selectedIndex = index;
          if (selectedIndex == 4) {
            if (userid == null) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()))
                  .whenComplete(initState);
            } else {
              // Navigator.of(context)
              //     .push(MaterialPageRoute(
              //         builder: (context) => PersonalProfile()))
              //     .whenComplete(initState);
            }
          } else if (selectedIndex == 2) {
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => PostQuestion()))
            //     .whenComplete(initState);
          } else if (selectedIndex == 3) {
            if (userid == null) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()))
                  .whenComplete(initState);
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Dashboard()))
                  .whenComplete(initState);
            }
          } else if (selectedIndex == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()))
                .whenComplete(initState);
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

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
      getsearchdata();
    });
    print('coming from shared preference $email$userid$name');
  }

  void getsearchdata() async {
    controller.text = searchtext;
    var body = {"search": searchtext};
    var response = await http.post(Uri.parse( '$apiurl/globalSearch'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      List<GlobalSearchApi> globalSearchApi =
          globalSearchApiFromJson(response.body);

      for (int i = 0; i < globalSearchApi.length; i++) {
        searchquestionreportedname.add(globalSearchApi[i].userName);
        searchquestioncomments.add(globalSearchApi[i].comments);
        searchquestionexpiringtime.add(globalSearchApi[i].expireTime);
        searchquestionexpiringtitle.add(globalSearchApi[i].expireTitle);
        searchquestionlikescount.add(globalSearchApi[i].likes.toString());
        searchquestionfileextension.add(globalSearchApi[i].fileExtention);
        searchquestionid.add(globalSearchApi[i].id);
        searchquestionimageurl.add(globalSearchApi[i].imageVideoUrl);
        searchquestionpostedtime.add(globalSearchApi[i].postedTime);
        searchquestionprofileimageurl.add(globalSearchApi[i].profileImageUrl ?? "");
        searchquestionslist.add(globalSearchApi[i].questionText);
        searchquestionusername.add(globalSearchApi[i].displayName);
        searchquestionviews.add(globalSearchApi[i].views);
        searchquestionuserid.add(globalSearchApi[i].userId);
        searchquestionisliked.add(globalSearchApi[i].isLike);
        searchquestionisreported.add(globalSearchApi[i].isAbused);
        List<Community> community = globalSearchApi[i].community;
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
        searchquestioncommunity.add(tempcommlist);
        searchquestioncommunityid.add(tempcommidlist);
      }

      setState(() {
        _enabled = false;
      });
    }
  }

  void cleardata() {
    searchquestionreportedname = [];
    searchquestionid = [];
    searchquestionslist = [];
    searchquestionimageurl = [];
    searchquestioncommunity = [];
    searchquestioncommunityid = [];
    searchquestionusername = [];
    searchquestionprofileimageurl = [];
    searchquestionexpiringtitle = [];
    searchquestionexpiringtime = [];
    searchquestionpostedtime = [];
    searchquestionviews = [];
    searchquestioncomments = [];
    searchquestioncommunityimage = [];
    searchquestionfileextension = [];
    searchquestionuserid = [];
    searchquestionlikescount = [];
    searchquestionisliked = [];
    searchquestionisreported = [];
    tempcommlist = "";
    tempcommidlist = "";
  }
}
