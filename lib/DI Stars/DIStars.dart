import 'dart:convert';

import 'package:decideitfinal/DI%20Stars/DIStarCard.dart';
import 'package:decideitfinal/DI%20Stars/DIStarJson.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../PublicProfile/DIStarProfile.dart';

class DIStars extends StatefulWidget {
  @override
  _DIStarsState createState() => _DIStarsState();
}

class _DIStarsState extends State<DIStars> {
  bool _isInAsyncCall = false;
  bool _enabled = true;
  var header;
  List<String> username = [];
  List<int> questioncount = [];
  List<int> activequestioncount = [];
  List<String> profileimagelist = [];
  List<String> userid = [];
  List<Widget> list = [];
  List<int> counter = [1, 2, 3, 4, 5, 6, 7, 8];
  AppBar appbar = AppBar();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdistars();
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
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Decide',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'It',
                            style: TextStyle(
                                color: kOrangePrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' Stars',
                            style: TextStyle(
                                color: kOrangePrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text(
                      'DecideIt Stars is our recognition board for users that help drive the conversations and engagement in the public community forums of DecideIt. The Community features will go live in the coming months, and those who most actively contribute and respond will find themselves on our daily Stars leader boards. These members are also eligible for invitation to the DecideIt leadership forums, so keep an eye out for the launch of this great new feature.'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.013,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: kOrangePrimaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('More than 50 Answers'),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.013,
                          width: MediaQuery.of(context).size.width * 0.03,
                          color: kBluePrimaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('More than 15 Answers'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 120),
                      child: Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.013,
                            width: MediaQuery.of(context).size.width * 0.03,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text('Active Questions')
                        ],
                      ),
                    ),
                  ],
                ),
                _enabled
                    ? Shimmer.fromColors(
                        baseColor: Colors.black12,
                        highlightColor: Colors.white10,
                        enabled: _enabled,
                        child: Wrap(
                          children: [
                        for (var i in counter)
                          DIStarCard('', '', 30, 30, '', ''),
                          ],
                        ))
                    : Container(
                        child: displaydistars(),
                      )
              ],
            ),
          ),
        ));
  }

  void getdistars() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedtoken = prefs.getString('header') ?? '';
    setState(() {
      header = sharedtoken;
    });
    var body = {"flag": "decideit_stars", "star_limit": "100"};
    var response = await http.post(Uri.parse( '$apiurl/getHomeData'),
        body: json.encode(body),
        headers: {
          "Content-Type": "application/json",
          "Authorization": sharedtoken
        },
        encoding: Encoding.getByName("utf-8"));

    print(response.body);
    if (response.statusCode == 200) {
      DiStarJson diStarJson = diStarJsonFromJson(response.body);
      List<Datum> data = diStarJson.data;
      for (int i = 0; i < data.length; i++) {
        username.add(data[i].userName ?? "");
        userid.add(data[i].id);
        questioncount.add(data[i].commentsCount);
        activequestioncount.add(data[i].activeQuestionsCount);
        profileimagelist.add(data[i].profileImageUrl ?? "");
      }
    } else {
      print(response.statusCode);
    }
    setState(() {
      _isInAsyncCall = false;
      _enabled = false;
    });
  }

  displaydistars() {
    if (username.isEmpty) {
      list.add(const Text('There are no DI Stars yet.!!'));
    } else {
      for (int i = 0; i < username.length; i++) {
        print('List of usrename: ' + username.toString());
        list.add(GestureDetector(
          onTap: () {
            print('View Profile');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DIStarProfile(userid[i])));
          },
          child: DIStarCard(profileimagelist[i], username[i], questioncount[i],
              activequestioncount[i], userid[i], header),
        ));
      }
    }
    //print('List of usrename: ' + username.toString());
    if (list.length - username.length >= 1) {
      list.removeAt(0);
    }

    return Wrap(children: list);
    //return new Container(child: list[0],);
  }
}
