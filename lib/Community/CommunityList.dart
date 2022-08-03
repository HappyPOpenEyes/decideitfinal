import 'package:decideitfinal/ProfileScreens/CommunityProfile.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../alertdialog_single.dart';
import 'CommunityListApiResponse.dart';
import 'CommunityListJSON.dart';

class CommunityList extends StatefulWidget {
  var header, imageurl, name, email, userid;

  @override
  _CommunityListState createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  var header, imageurl, name, email, userid;

  List<String> categoryname = [];
  List<String> communityicon = [];
  List<String> communityname = [];
  List<String> _searchResult = [];
  List<String> _searchResultimages = [];
  List<Widget> widgetlist = [];
  late List<CommunityListApi> communitylist;
  bool _enabled = true;
  int countercommunity = 0;
  int countercategoryname = 0;

  double _animatedHeight = 100.0;

  bool _isInAsyncCall = true;
  TextEditingController controller = TextEditingController();
  AppBar appbar = AppBar();

  @override
  void initState() {
    // TODO: implement initState
    getuserdata();
    super.initState();
    //widgetlist = [];
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
          onTap: () {
            print('Back button pressesd');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CommunityProfile()));
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Select a Community',
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.search),
                title: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                      hintText: 'Search', border: InputBorder.none),
                  onChanged: onSearchTextChanged,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _enabled
                ? Shimmer.fromColors(
                    baseColor: Colors.black12,
                    highlightColor: Colors.white10,
                    enabled: _enabled,
                    child: const Text('There are no communities to display'))
                : Expanded(
                    child: SizedBox(
                      height: 200,
                      child: controller.text.isNotEmpty
                          ? ListView.builder(
                              itemCount: _searchResult.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  onTap: () {
                                    print(_searchResult);
                                    addcommunity(_searchResult[i]);
                                    print(_searchResult);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.all(0.0),
                                    child: ListTile(
                                      title: Text(
                                        _searchResult[i],
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                      leading: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFF1F1F1),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          child: Image.network(
                                            '$imageapiurl/community-image/${_searchResultimages[i]}',
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                          )),
                                    ),
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: communitylist.length,
                              itemBuilder: (context, i) {
                                return ExpansionTile(
                                  title: Text(
                                    communitylist[i].name,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  children: <Widget>[
                                    Column(
                                      children: _buildExpandableContent(
                                          communitylist[i]),
                                    ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {});
      return;
    } else {
      List<String> demoicons = [];
      setState(() {
        _searchResult = communityname
            .where(
                (string) => string.toLowerCase().contains(text.toLowerCase()))
            .toList();
        _searchResultimages = communityicon
            .where((string) => string.contains(text.toLowerCase()))
            .toList();
        /*for (int i = 0; i < _searchResult.length; i++) {
          if (communityname.contains(_searchResult[i])) {
            int index = communityname.indexOf(communityname[i]);
            demoicons.add(communityicon[index]);
          }
        }*/
        //_searchResultimages = demoicons;
      });
    }
  }

  void getallcommunities() async {
    var communitiesresponse = await http.get(
        Uri.parse('$apiurl/getProfileData/communities'),
        headers: {"Authorization": header});

    if (communitiesresponse.statusCode == 200) {
      print(communitiesresponse.body);
      communitylist = communityListApiFromJson(communitiesresponse.body);
      for (int i = 0; i < communitylist.length; i++) {
        categoryname.add(communitylist[i].name);
        List<Community> communities = communitylist[i].communities;
        for (int j = 0; j < communities.length; j++) {
          communityicon.add(communities[j].communityThumbnailImage);
          communityname.add(communities[j].name);
          _searchResult.add(communities[j].name);
          _searchResultimages.add(communities[j].communityThumbnailImage);
        }
      }
      print(categoryname.length);
      print(communityicon.length);
      print(communityname.length);
      setState(() {
        _enabled = false;
        _isInAsyncCall = false;
      });
    } else {
      print('Commmunity Response${communitiesresponse.statusCode}');
      print(communitiesresponse.body);
    }
  }

  _buildExpandableContent(CommunityListApi community) {
    List<Widget> columnContent = [];

    for (Community listcommunity in community.communities) {
      columnContent.add(
        GestureDetector(
          onTap: () {
            print('Community Added');
            addcommunity(listcommunity.name);
          },
          child: ListTile(
            title: Text(
              listcommunity.name,
              style: const TextStyle(fontSize: 18.0),
            ),
            leading: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF1F1F1),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Image.network(
                  '$imageapiurl/community-image/${listcommunity.communityThumbnailImage}',
                  height: MediaQuery.of(context).size.width * 0.1,
                  width: MediaQuery.of(context).size.width * 0.1,
                )),
          ),
        ),
      );
    }

    return columnContent;
  }

  void addcommunity(String name) async {
    var communityid;
    print(name);
    for (int i = 0; i < communitylist.length; i++) {
      List<Community> communities = communitylist[i].communities;
      for (int j = 0; j < communities.length; j++) {
        if (name == communities[j].name) {
          communityid = communities[j].id;
        }
      }
    }
    setState(() {
      _isInAsyncCall = true;
    });
    print(communityid);
    var response = await http.get(
        Uri.parse('$apiurl/addUserCommunity/$communityid'),
        headers: {"Authorization": header});

    if (response.statusCode == 200) {
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

      setState(() {
        categoryname = [];
        communityicon = [];
        communityname = [];
        _searchResult = [];
        _searchResultimages = [];
        widgetlist = [];
        communitylist = [];
        _isInAsyncCall = false;
        getallcommunities();
      });
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      CommunityListResponse communityListResponse =
          communityListResponseFromJson(response.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle("Error", communityListResponse.message);
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
      getallcommunities();
    });
    print('coming from shared preference $email$userid$name');
    print(header);
  }
}
