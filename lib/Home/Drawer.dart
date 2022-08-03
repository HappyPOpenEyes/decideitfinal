import 'package:decideitfinal/ContactUS/ContactUs.dart';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/ProfileScreens/PersonalProfile.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  var header, email, name, userid, imageurl = "";
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        userid == null
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 45, bottom: 10),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.height * 0.03,
                  child: RaisedButton.icon(
                    //padding: EdgeInsets.symmetric(horizontal: 5),
                    icon: const Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: kBluePrimaryColor)),
                    color: kBluePrimaryColor,
                    label: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                color: kBackgroundColor,
                height: (MediaQuery.of(context).size.height * 0.23),
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.width * 0.095,
                                width:
                                    MediaQuery.of(context).size.width * 0.095,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Theme.of(context).primaryColor,
                                  image: DecorationImage(
                                      fit: BoxFit.fill, image: showImage()),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 25,
                                      color: Colors.black.withOpacity(0.2),
                                      offset: const Offset(0, 10),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                //height:
                                //MediaQuery.of(context).size.width * 0.19,
                                //width: MediaQuery.of(context).size.width * 0.5,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name ?? 'name',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: kBluePrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.465,
                                      child: Text(
                                        email ?? 'email',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (userid == null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              } else {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PersonalProfile()));
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 45.0),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 12,
                                  ),
                                  Text(
                                    'View Profile',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ),
        Container(
          //height: MediaQuery.of(context).size.height * 0.35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: kBackgroundColor,
          child: Wrap(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  'Get In Touch',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
                child: Row(
                  children: [
                    const Icon(Icons.mail_outline),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ContactUs()));
                          // // Update the state of the app.
                          // ...
                        },
                        child: const Text('Contact Us')),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.article_outlined),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          print('Tap');
                          await launch('https://decideit.com/termsConditions',
                              forceSafariVC: false);
                        },
                        child: const Text('Terms and Conditions')),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.policy_outlined),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        print('Tap');
                        await launch('https://decideit.com/privacyPolicy',
                            forceSafariVC: false);
                      },
                      child: const Text(
                        'Privacy Policy',
                      ),
                    ),
                  ],
                ),
              ),
              userid == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: RaisedButton.icon(
                        //padding: EdgeInsets.symmetric(horizontal: 5),
                        icon: Icon(
                          email == null ? Icons.login : Icons.logout,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('email');
                          prefs.remove('userid');
                          prefs.remove('imageurl');
                          prefs.remove('name');
                          prefs.remove('header');
                          prefs.remove('isprofileprivate');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: kBluePrimaryColor)),
                        color: kBluePrimaryColor,
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          color: kBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: GestureDetector(
                  onTap: () async {
                    String fbProtocolUrl;
                    fbProtocolUrl = 'fb://profile/445065920224741';

                    String fallbackUrl =
                        'https://www.facebook.com/DecideItCommunity';

                    try {
                      print('In try');
                      bool launched =
                          await launch(fbProtocolUrl, forceSafariVC: false);

                      if (!launched) {
                        await launch(fallbackUrl, forceSafariVC: false);
                      } else {
                        print('Launched error');
                      }
                    } catch (e) {
                      print('HI');
                      print(e.toString());
                    }
                  },
                  child: const Image(
                      color: Colors.grey,
                      image: AssetImage(
                        'logos/facebook.png',
                      )),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                height: 20,
                width: 20,
                child: GestureDetector(
                    onTap: () async {
                      const url = 'https://twitter.com/decideit';
                      if (await canLaunch(url)) {
                        await launch(url, forceSafariVC: false);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Image(
                        color: Colors.grey,
                        image: AssetImage('logos/twitter.png'))),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                  height: 20,
                  width: 20,
                  child: GestureDetector(
                    onTap: () async {
                      const url =
                          'https://www.instagram.com/decideitcommunity/';
                      if (await canLaunch(url)) {
                        await launch(url, forceSafariVC: false);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Image(
                        color: Colors.grey,
                        image: const AssetImage('logos/instagram.png')),
                  )),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                  height: 20,
                  width: 20,
                  child: GestureDetector(
                      onTap: () async {
                        String linkedinurl =
                            'https://www.linkedin.com/company/decidecommunity/about/';
                        if (await canLaunch(linkedinurl)) {
                          await launch(linkedinurl);
                        } else {
                          throw 'Could not open the url.';
                        }
                      },
                      child: const Image(
                          color: Colors.grey,
                          image: AssetImage('logos/linkedin.png')))),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          color: kBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: RichText(
            text: const TextSpan(
              text: 'Copyright © 2021  ',
              style: const TextStyle(color: Colors.black, fontSize: 15),
              children: <TextSpan>[
                const TextSpan(
                    text: 'Decide',
                    style: TextStyle(
                        color: kBluePrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                const TextSpan(
                    text: 'It',
                    style: TextStyle(
                        color: kOrangePrimaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        )
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
      imageurl = sharedimageurl!;
      name = sharedname;
      header = sharedtoken;
    });
    print('coming from shared preference $email$userid$name');
  }

  showImage() {
    return imageurl.isEmpty
        ? const AssetImage('images/user.jpg')
        : NetworkImage('$imageapiurl/$imageurl');
  }
}
