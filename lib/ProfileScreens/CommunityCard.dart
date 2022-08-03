import 'package:decideitfinal/Community/CommunityListApiResponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../alertDialog.dart';
import '../constants.dart';

class CommunityCard extends StatelessWidget {
  late var categoryName,
  categoryicon,
   header,
  communityid,
   imageurl, username, email, userid;
  late BuildContext context;
  late Function callback;

  CommunityCard(icon, name, header, communityid, context, imageurl, username,
      email, userid, this.callback, {Key? key}) : super(key: key) {
    categoryicon = icon;
    categoryName = name;
    header = header;
    communityid = communityid;
    context = context;
    imageurl = imageurl;
    username = username;
    email = email;
    userid = userid;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: const Color(0xFFFFFFFF),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFF1F1F1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 10), //To provide some space on sides
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center, //The change
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFF1F1F1),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    child: Image.network(
                      '$imageapiurl/community-image/' +
                          categoryicon,
                      height: 18,
                      width: 18,
                    )),
              ),
              Text(
                categoryName,
                style: const TextStyle(fontSize: 18),
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
                        removecommunity(communityid);
                        //this.callback(new CommunityProfile());
                      },
                      child: const ImageIcon(AssetImage('images/Cross.png')))),
              const SizedBox(
                width: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void removecommunity(communityid) async {
    var response = await http.get(
        Uri.parse( '$apiurl/removeUserCommunity/$communityid'),
        headers: {"Authorization": header});

    if (response.statusCode == 200) {
      print(response.body);
      CommunityListResponse communityListResponse =
          communityListResponseFromJson(response.body);

      BlurryDialog alert =
          BlurryDialog("Success", communityListResponse.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
      /*Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) =>
              CommunityProfile(imageurl, username, email, userid, header)));*/
      print(communityListResponse.message);
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }
}
