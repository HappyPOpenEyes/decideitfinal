import 'dart:convert';
import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:decideitfinal/AddressBook/AddressBook.dart';
import 'package:decideitfinal/AddressBook/DeleteContactAPI.dart';
import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/Home/Drawer.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:decideitfinal/ProfileScreens/APIResponse.dart';
import 'package:decideitfinal/ProfileScreens/PersonalProfile.dart';
import 'package:decideitfinal/ProfileScreens/ProfilePlan.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CommunityProfile.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'dart:convert' as convert;

class ChangePassword extends StatefulWidget {
  var imageurl;
  var name;
  var email;
  var userid;
  var header;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var imageurl;
  var name;
  var email;
  var userid;
  var header;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController currentpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController _searchcontroller = TextEditingController();
  int selectedIndex = 3;
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  var oldpassword, newpassword, confirmpassword;
  bool _isInAsyncCall = true;
  CroppedFile? _pickedImage;
  bool profileprivateisSelected = false;
  late int isprofileprivate;
  String contactscount = "";
  String switchactivetext = "Private";
  String switchinactivetext = "Public";
  String filename = "";
  AppBar appbar = AppBar();

  @override
  void initState() {
    super.initState();
    // Transparent status bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kBluePrimaryColor,
    ));
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
        body: ModalProgressHUD(
          inAsyncCall: _isInAsyncCall,
          // demo of some additional parameters
          opacity: 0.5,
          progressIndicator: const CircularProgressIndicator(),
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
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
                                      shape: CircleBorder(),
                                      color: Colors.white),
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
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddressBook(3)));
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
                                                      AddressBook(3)));
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
                                        builder: (context) =>
                                            PersonalProfile()));
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
                                  color: kBluePrimaryColor,
                                ),
                              ),
                              label: const Text(''),
                              onPressed: () {},
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
                                ),
                              ),
                              label: const Text(''),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CommunityProfile()));
                              },
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Text(
                          'Profile Privacy',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Calibri'),
                        ),
                      ),
                      FlutterSwitch(
                        height: 30,
                        width: 100,
                        showOnOff: true,
                        inactiveText: switchinactivetext,
                        activeText: switchactivetext,
                        activeTextColor: kBackgroundColor,
                        inactiveTextColor: kBluePrimaryColor,
                        inactiveTextFontWeight: FontWeight.bold,
                        activeTextFontWeight: FontWeight.bold,
                        value: profileprivateisSelected,
                        onToggle: (val) {
                          setState(() {
                            profileprivateisSelected = val;
                            print('Active Text: $switchactivetext');
                            print('INActive Text: $switchinactivetext');
                            _isInAsyncCall = true;
                            makeprofileprivatepublic();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      'Change Password',
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
                  Form(
                      key: _formKey,
                      child: Container(
                          color: kBackgroundColor,
                          child: Column(
                            children: [
                              buildoldpasswordfield(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildnewPasswordField(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildConformPassFormField(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildupdatebuttonfield(),
                            ],
                          )))
                ],
              ),
            ),
          ),
        ));
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
    XFile? picked = await ImagePicker.platform.getImage(source: source);
    if (picked != null) {
      _cropImage(picked);
    }
    Navigator.pop(context);
  }

  _cropImage(XFile picked) async {
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
        print('In image change');
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

  getbottomnavigation() {
    return BottomNavyBar(
      showElevation: true,
      selectedIndex: selectedIndex,
      onItemSelected: (index) {
        setState(() {
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

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  buildoldpasswordfield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          obscureText: true,
          cursorColor: Colors.black,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Calibri',
          ),
          onSaved: (newValue) => oldpassword = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPassNullError);
            } else if (value.length >= 8) {
              removeError(error: kShortPassError);
            }
            oldpassword = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return kPassNullError;
              //addError(error: kPassNullError);

            } else if (value.length < 8) {
              return kShortPassError;
              //addError(error: kShortPassError);

            }
            return null;
          },
          decoration: const InputDecoration(
              //labelText: "Password",
              contentPadding: EdgeInsets.all(8.0),
              hintText: "Old Password",
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'Calibri',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  buildnewPasswordField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          obscureText: true,
          cursorColor: Colors.black,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Calibri',
          ),
          onSaved: (newValue) => newpassword = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPassNullError);
            } else if (value.length >= 8) {
              removeError(error: kShortPassError);
            }
            newpassword = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return kPassNullError;
              //addError(error: kPassNullError);

            } else if (value.length < 8) {
              return kShortPassError;
            }
            return null;
          },
          decoration: const InputDecoration(
              //labelText: "Password",
              contentPadding: EdgeInsets.all(8.0),
              hintText: "New Password",
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'Calibri',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  buildConformPassFormField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          obscureText: true,
          onSaved: (newValue) => confirmpassword = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPassNullError);
            } else if (value.isNotEmpty && newpassword == confirmpassword) {
              removeError(error: kMatchPassError);
            }
            confirmpassword = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return kPassNullError;
              //addError(error: kPassNullError);

            } else if ((newpassword != value)) {
              return kMatchPassError;
            }
            return null;
          },
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
              hintText: "Confirm Password",
              hintStyle: TextStyle(
                color: Colors.black,
                fontFamily: 'Calibri',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  buildupdatebuttonfield() {
    return Center(
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: kBluePrimaryColor,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              updatepassword();
            }
          },
          child: RichText(
            text: const TextSpan(
                text: 'UPDATE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Calibri')),
          )),
    );
  }

  void updatepassword() async {
    var url = Uri.parse('$apiurl/change-password');
    var body = {
      'old_password': oldpassword,
      'password': newpassword,
      'password_confirmation': confirmpassword,
    };

    setState(() {
      _isInAsyncCall = true;
    });
    var response = await http.post(url,
        body: json.encode(body),
        headers: {'Content-type': 'application/json', "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      if (_pickedImage != null) {
        var body1 = {
          "user_id": userid,
          "profile_image": filename,
          "profile_image_file": _pickedImage
        };
        var imageresponse = await http.post(Uri.parse('$apiurl/upload-image'),
            body: json.encode(body1),
            headers: {
              'Content-type': 'application/json',
              "Authorization": header
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
            _isInAsyncCall = false;
          });
        } else {
          print(imageresponse.statusCode);
          print(imageresponse.body);
          setState(() {
            _isInAsyncCall = false;
          });
        }
      } else {
        setState(() {
          _isInAsyncCall = false;
        });
        BlurryDialogSingle alert =
            BlurryDialogSingle("Success", 'Your password has been changed');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return alert;
          },
        );
      }
      print('Updated');
      print(response.body);
    } else {
      GetResponse getResponse = getResponseFromJson(response.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle("Error", getResponse.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
      setState(() {
        _isInAsyncCall = false;
      });
      print(response.statusCode);
      print(response.body);
    }
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedisprivate = prefs.getInt('isprofileprivate');
    var sharedcontactscount = prefs.getString('totalcontactscount');
    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
      isprofileprivate = sharedisprivate!;
      contactscount = sharedcontactscount!;
      if (isprofileprivate == 1) {
        profileprivateisSelected = true;
      }
      _isInAsyncCall = false;
    });
    print('coming from shared preference $email$userid$name');
    print(imageurl);
  }

  Future<bool> addImage(Map<String, String> body, String filepath) async {
    print('Inside Add Image');
    String addimageUrl = '$apiurl/upload-image';
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    var request = http.MultipartRequest('POST', Uri.parse(addimageUrl))
      ..fields.addAll(body)
      ..headers.addAll(headers)
      ..files.add(await http.MultipartFile.fromPath('image', filepath));
    var response = await request.send();
    print('The response from form data');
    print(response.statusCode);
    print(response.reasonPhrase);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  void updateprofilepic() async {
    var imageresponse;
    List<int> imageBytes = File(_pickedImage!.path).readAsBytesSync();
    String base64Image = convert.base64Encode(imageBytes);
    var imagebytes = _pickedImage!.readAsBytes();
    var imageextension = p.extension(_pickedImage!.path);

    print('The Extension of image is');
    print(imageextension);

    print('In upload image function');
    print('In bytes');
    print(imagebytes.toString());
    print(base64Image);
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
        _isInAsyncCall = true;
      });
      print('Calling image add function');
      String imageheader = header;
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

  void makeprofileprivatepublic() async {
    var profileresponse = await http.get(Uri.parse('$apiurl/profilePrivacy'),
        headers: {"Authorization": header});
    if (profileresponse.statusCode == 200) {
      print(profileresponse.body);
      DeleteContactAPI deleteContactAPI =
          deleteContactAPIFromJson(profileresponse.body);
      if (isprofileprivate == 0) {
        isprofileprivate = 1;
      } else {
        isprofileprivate = 0;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('isprofileprivate', isprofileprivate);
      BlurryDialogSingle alert =
          BlurryDialogSingle('Success', deleteContactAPI.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
    } else {
      print(profileresponse.statusCode);
      print(profileresponse.body);
      DeleteContactAPI deleteContactAPI =
          deleteContactAPIFromJson(profileresponse.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle('Success', deleteContactAPI.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
    }

    setState(() {
      _isInAsyncCall = false;
    });
  }

  showImage() {
    return imageurl == '' || imageurl == null
        ? _pickedImage != null
            ? FileImage(File(_pickedImage!.path))
            : const AssetImage('images/user.jpg')
        : _pickedImage != null
            ? FileImage(File(_pickedImage!.path))
            : NetworkImage('$imageapiurl/$imageurl');
  }
}
