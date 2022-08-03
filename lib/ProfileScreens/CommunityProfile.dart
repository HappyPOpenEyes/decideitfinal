import 'dart:convert';
import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:decideitfinal/AddressBook/AddressBook.dart';
import 'package:decideitfinal/Community/CommunityListApiResponse.dart';
import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/Home/Drawer.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:decideitfinal/ProfileScreens/ChangePassword.dart';
import 'package:decideitfinal/ProfileScreens/GetUserCommunity.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Community/CommunityList.dart';
import 'PersonalProfile.dart';
import 'package:shimmer/shimmer.dart';

import 'ProfilePlan.dart';

class CommunityProfile extends StatefulWidget {
  var imageurl;
  var name;
  var email;
  var userid;
  var token;
  var flag;

  @override
  _CommunityProfileState createState() => _CommunityProfileState();
}

class _CommunityProfileState extends State<CommunityProfile> {
  var imageurl;
  var name;
  var email;
  var userid;
  var token;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int selectedIndex = 3;
  int cardcounter = 0;
  List<String> communityiconlist = [];
  List<String> communityname = [];
  List<Widget> list = [];
  bool _isInAsyncCall = true;
  bool _enabled = true;
  CroppedFile? _pickedImage;
  List<String> communityidlist = [];
  String contactscount = "";
  String filename = "";
  AppBar appbar = AppBar();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
    //getcommunites();
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
        body: ModalProgressHUD(
          inAsyncCall: false,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .08,
                          color: kBluePrimaryColor,
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .03,
                          right: 0.0,
                          left: 6.0),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.12,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                decoration: const ShapeDecoration(
                                    shape: CircleBorder(), color: Colors.white),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                              GestureDetector(
                                  onTap: () {
                                    _showPickOptionsDialog(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: kBackgroundColor,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: const Icon(
                                      Icons.create,
                                      color: kBluePrimaryColor,
                                    ),
                                  )),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Text(
                                  name ?? "",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Calibri'),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                      6.0,
                                    ),
                                    child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        color: kOrangePrimaryColor,
                                        onPressed: () {
                                          print('Contacts');
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddressBook(4)));
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Total Contacts: ',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: contactscount,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Calibri')),
                                            ],
                                          ),
                                        )),
                                  ),
                                  RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      color: kBluePrimaryColor,
                                      onPressed: () {
                                        print('Address');
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddressBook(4)));
                                      },
                                      child: RichText(
                                        text: const TextSpan(
                                            text: 'ADDRESS BOOK',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri')),
                                      ))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.025,
                        0,
                        MediaQuery.of(context).size.width * 0.025,
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.2375,
                          child: RaisedButton.icon(
                            color: Colors.white,
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'images/personal.png',
                              ),
                            ),
                            label: const Text(''),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => PersonalProfile()));
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.2375,
                          child: RaisedButton.icon(
                            color: Colors.white,
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'images/plan.png',
                              ),
                            ),
                            label: const Text(''),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ProfilePlan()));
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.2375,
                          child: RaisedButton.icon(
                            color: Colors.white,
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'images/password.png',
                              ),
                            ),
                            label: const Text(''),
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ChangePassword()));
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.1,
                          width: MediaQuery.of(context).size.width * 0.2375,
                          child: RaisedButton.icon(
                            color: Colors.white,
                            icon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'images/Community.png',
                                color: kBluePrimaryColor,
                              ),
                            ),
                            label: const Text(''),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  color: kBackgroundColor,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text(
                    'My Communities',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Calibri'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _enabled
                    ? Shimmer.fromColors(
                        baseColor: Colors.black12,
                        highlightColor: Colors.white10,
                        enabled: _enabled,
                        child: Container(
                          child: displaycommunities(),
                        ))
                    : Container(
                        child: displaycommunities(),
                      )
              ],
            ),
          ),
        ));
  }

  checkimage() {
    if (imageurl == null) {
      return const AssetImage('images/user.jpg');
    } else {
      return NetworkImage(imageurl);
    }
  }

  getcommunites() async {
    print('Token is' + token + email + userid);
    var response = await http.get(
        Uri.parse('$apiurl/getProfileData/user_communities'),
        headers: {"Authorization": token});
    setState(() {
      _isInAsyncCall = false;
      _enabled = false;
    });
    //print(token);
    communityiconlist = [];
    communityname = [];
    communityidlist = [];
    list = [];
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        List<GetUserCommunity> getusercommunity =
            getUserCommunityFromJson(response.body);

        print(getusercommunity.length);
        if (getusercommunity.isEmpty) {
          print('Community');
          communityiconlist = [];
          communityname = [];
          communityidlist = [];
        } else {
          for (int i = 0; i < getusercommunity.length; i++) {
            communityiconlist
                .add(getusercommunity[i].community.communityThumbnailImage);
            communityname.add(getusercommunity[i].community.name);
            communityidlist.add(getusercommunity[i].id);
          }
        }
      });
    }

    print(communityname);
  }

  displaycommunities() {
    list = [];
    if (communityiconlist.isEmpty) {
      list.add(GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CommunityList()));
        },
        child: Card(
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFF1F1F1),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: const Icon(
                            Icons.add,
                            size: 15,
                          ))),
                  const Text(
                    'Add Community',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    } else {
      for (var i = 0; i < communityiconlist.length; i++) {
        list.add(Card(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFF1F1F1),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Image.network(
                          '$imageapiurl/community-image/${communityiconlist[i]}',
                          height: 18,
                          width: 18,
                        )),
                  ),
                  Text(
                    communityname[i],
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        print('Removed Community');

                        print(communityidlist[i]);
                        print(communityname[i]);
                        removecommunity(communityidlist[i], i);
                      },
                      child: const SizedBox(
                          height: 14,
                          width: 14,
                          child: ImageIcon(AssetImage('images/Cross.png')))),
                  const SizedBox(
                    width: 3,
                  ),
                ],
              ),
            ),
          ),
        ));
      }
      list.add(GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => CommunityList()));
        },
        child: Card(
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFF1F1F1),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: const Icon(
                            Icons.add,
                            size: 15,
                          ))),
                  const Text(
                    'Add Community',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    print(list.length);
    if (list.length - communityiconlist.length > 1) {
      list.removeAt(0);
    }
    return Wrap(children: list);
  }

  void _showPickOptionsDialog(BuildContext context) {
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
    PickedFile? picked = await ImagePicker.platform.pickImage(source: source);
    if (picked != null) {
      _cropImage(picked);
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
        _pickedImage = cropped;
        print('In image change');
        print('File path is given below');
        String imagepath = _pickedImage!.path;
        print(imagepath);
        print('Filename is given below');
        filename = _pickedImage!.path.split('/').last;
        print(filename);
        updateprofilepic();
      });
    }
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 5),
              child: const Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void removecommunity(communityid, int index) async {
    setState(() {
      list = [];
      _enabled = true;
    });
    print(communityid);
    var response = await http.get(
        Uri.parse('$apiurl/removeUserCommunity/$communityid'),
        headers: {"Authorization": token});

    if (response.statusCode == 200) {
      print(response.body);
      CommunityListResponse communityListResponse =
          communityListResponseFromJson(response.body);
      if (_pickedImage != null) {
        var body1 = {
          "user_id": userid,
          "profile_image": FileImage(File(_pickedImage!.path)),
          "profile_image_file": _pickedImage
        };
        var imageresponse = await http.post(
            Uri.parse(
                'https://api.decideit.uatbyopeneyes.com/public/api/upload-image'),
            body: json.encode(body1),
            headers: {
              'Content-type': 'application/json',
              "Authorization": token
            },
            encoding: Encoding.getByName("utf-8"));
        if (imageresponse.statusCode == 200) {
          print(imageresponse.body);
          BlurryDialogSingle alert =
              BlurryDialogSingle("Success", 'Your profile has been updated');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return alert;
            },
          );
          setState(() {
            list = [];
            _isInAsyncCall = false;
          });
        } else {
          print(imageresponse.statusCode);
          print(imageresponse.body);
          setState(() {
            list = [];
            _isInAsyncCall = false;
          });
        }
      } else {
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
      }

      communityiconlist.removeAt(index);
      communityidlist.removeAt(index);
      communityname.removeAt(index);

      // communityiconlist = [];
      // communityname = [];
      // list = [];
      //await getcommunites();

      setState(() {
        _enabled = false;
      });
      print(communityListResponse.message);
    } else {
      print(response.statusCode);
      print(response.body);
      setState(() {
        _enabled = false;
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
    var sharedcontactscount = prefs.getString('totalcontactscount');

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      token = sharedtoken;
      contactscount = sharedcontactscount!;
      list = [];
    });
    await getcommunites();
    print('coming from shared preference $email$userid$name');
    print(imageurl);
  }

  getbottomnavigation() {
    return BottomNavyBar(
      showElevation: true,
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        setState(() {
          list = [];
          selectedIndex = index;
          if (selectedIndex == 2) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Dashboard()));
          } else if (selectedIndex == 1) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => PostQuestion()));
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

  void updateprofilepic() async {
    var imageresponse;

    if (_pickedImage != null) {
      print('Image app code');

      print('Image is chosen');
      String imageuserid = userid;
      String imagefilename = filename;
      String imagepath = _pickedImage!.path;
      var body1 = {
        "user_id": imageuserid,
        "profile_image": imagefilename,
      };
      print('Body is accepted');
      print(body1);
      setState(() {
        list = [];
        _isInAsyncCall = true;
      });
      print('Calling image add function');
      String imageheader = token;
      String addimageUrl = '$apiurl/upload-image';
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        "Authorization": imageheader
      };
      var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
        ..fields.addAll(body1)
        ..headers.addAll(headers)
        ..files.add(
            await http.MultipartFile.fromPath('profile_image_file', imagepath));
      var response = await request.send();
      setState(() {
        list = [];
        _isInAsyncCall = false;
      });
      print('The response from form data');
      print(response.statusCode);
      print(response.reasonPhrase);
      if (response.statusCode == 200) {
        BlurryDialogSingle alert = BlurryDialogSingle(
            "Success", 'Your profile picture has been updated');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return alert;
          },
        );
        print('Succuess');
      } else {
        BlurryDialogSingle alert =
            BlurryDialogSingle("Error", 'Something went wrong');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return alert;
          },
        );
        print('Failed');
      }
    } else {
      BlurryDialogSingle alert = BlurryDialogSingle(
          "Error", 'Your profile picture has not been updated$imageresponse');
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

  showImage() {
    return imageurl == '' || imageurl == null
        ? const AssetImage('images/user.jpg')
        : NetworkImage('$imageapiurl/$imageurl');
  }
}
