import 'dart:convert';
import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:decideitfinal/AddressBook/AddressBook.dart';
import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/Home/Drawer.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:decideitfinal/ProfileScreens/ChangePassword.dart';
import 'package:decideitfinal/ProfileScreens/CommunityProfile.dart';
import 'package:decideitfinal/ProfileScreens/ProfilePlan.dart';
import 'package:decideitfinal/ProfileScreens/UpdateProfileAPI.dart';
import 'package:decideitfinal/Registration/OTPDialog.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../logindialog.dart';
import 'GetPersonalData.dart';

class PersonalProfile extends StatefulWidget {
  @override
  _PersonalProfileState createState() => _PersonalProfileState();
}

class _PersonalProfileState extends State<PersonalProfile> {
  var imageurl;
  var name;
  var email;
  var firstname;
  var lastname;
  String? mobile;
  var userid;
  var header;
  final _formKey = GlobalKey<FormState>();
  late int isemail;

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController _searchcontroller = TextEditingController();
  int selectedIndex = 3;
  CroppedFile? _pickedImage;
  final List<String> errors = [];
  bool _isInAsyncCall = true;
  String contactscount = "";
  late int isprofileprivate;
  AppBar appbar = AppBar();
  String filename = "";

  @override
  void initState() {
    super.initState();
    // Transparent status bar
    getuserdetails();
    print('Hello');
    print(imageurl);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kBluePrimaryColor,
    ));
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
                                height:
                                    MediaQuery.of(context).size.height * .08,
                                color: kBluePrimaryColor,
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .03,
                                right: 0.0,
                                left: 4.1),
                            child: Row(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.12,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.12,
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
                                                  image: showImage())),
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
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                      padding:
                                          const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        name ?? '',
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6.0, left: 4),
                                      child: Row(
                                        children: [
                                          RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              color: kOrangePrimaryColor,
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddressBook(
                                                                        1)));
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                  text: 'Total Contacts: ',
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: contactscount
                                                                .isEmpty
                                                            ? '0'
                                                            : contactscount,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Calibri')),
                                                  ],
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              color: kBluePrimaryColor,
                                              onPressed: () {
                                                print('Address');
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddressBook(
                                                                        1)));
                                              },
                                              child: RichText(
                                                text: const TextSpan(
                                                    text: 'ADDRESS BOOK',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Calibri')),
                                              ))
                                        ],
                                      ),
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
                                width:
                                    MediaQuery.of(context).size.width * 0.2375,
                                child: RaisedButton.icon(
                                  color: Colors.white,
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'images/personal.png',
                                      color: kBluePrimaryColor,
                                    ),
                                  ),
                                  label: const Text(''),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.1,
                                width:
                                    MediaQuery.of(context).size.width * 0.2375,
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
                                    isemail == 0
                                        ? ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Please complete profile information'),
                                          ))
                                        : Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePlan()));
                                  },
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.1,
                                width:
                                    MediaQuery.of(context).size.width * 0.2375,
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
                                    isemail == 0
                                        ? ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Please complete profile information'),
                                          ))
                                        : Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangePassword()));
                                  },
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.width * 0.1,
                                width:
                                    MediaQuery.of(context).size.width * 0.2375,
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
                                    isemail == 0
                                        ? ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Please complete profile information'),
                                          ))
                                        : Navigator.of(context).pushReplacement(
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Text(
                          'Personal Information',
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
                              buildfirstnamefield(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildlastnamefield(),
                              const SizedBox(
                                height: 10,
                              ),
                              biuldemailfield(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildphonefield(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildaboutmefield(),
                              const SizedBox(
                                height: 10,
                              ),
                              buildupdatebuttonfield(),
                            ],
                          ),
                        ),
                      ),
                    ])),
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
          if (selectedIndex == 2) {
            isemail == 0
                ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please complete profile information'),
                  ))
                : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Dashboard()));
          } else if (selectedIndex == 1) {
            isemail == 0
                ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please complete profile information'),
                  ))
                : Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => PostQuestion()));
          } else if (selectedIndex == 0) {
            isemail == 0
                ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please complete profile information'),
                  ))
                : Navigator.of(context).pushReplacement(
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

  void getuserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedisemail = prefs.getInt('isemail');

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
      isemail = sharedisemail!;
      if (userid == null) {
        showlogindialog();
      } else {
        getprofiledata();
      }
    });
    print('coming from shared preference $header$userid$name');
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

  void showAlertDialog(BuildContext context) {
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
  }

  void updateprofile() async {
    bool ismobilechanged = false, isemailchanged = false;
    print('What is updated email');
    if (emailController.text != email && email != null) {
      isemailchanged = true;
    } else if (emailController.text != "" && email == null) {
      isemailchanged = true;
    }
    if (phoneController.text != mobile && mobile != null) {
      print('1');
      ismobilechanged = true;
    } else if (phoneController.text != "" && mobile == null) {
      print('2');
      ismobilechanged = true;
    }
    print(phoneController.text);
    var url = Uri.parse('$apiurl/userProfileUpdate');
    var body = {
      'email': emailController.text,
      'user_id': userid,
      'phone': phoneController.text,
      'first_name': firstnameController.text,
      'last_name': lastnameController.text,
      'user_profile': aboutController.text,
    };
    print(body);

    setState(() {
      _isInAsyncCall = true;
    });
    var response = await http.post(url,
        body: json.encode(body),
        headers: {'Content-type': 'application/json', "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      _isInAsyncCall = false;
    });
    if (response.statusCode == 200) {
      if (isemail == 0) {
        setState(() {
          isemail = 1;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('isemail', isemail);
      }
      print(response.body);
      print('Profile Updated');
      if (ismobilechanged) {
        OTPDialog alert = OTPDialog(
            'Verify One Time Password',
            'Enter your One Time Password to verify your mobile number',
            userid,
            phoneController.text,
            0);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return alert;
          },
        );
      } else if (isemailchanged) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('emailchanged',
            'Your profile has been updated. Please check you mail to activate the email.');
        prefs.remove('email');
        prefs.remove('userid');
        prefs.remove('imageurl');
        prefs.remove('name');
        prefs.remove('header');
        prefs.remove('isprofileprivate');
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
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
      }
    } else if (response.statusCode == 401) {
      BlurryDialogSingle alert = BlurryDialogSingle(
          "Error", 'Email or phone number or username already used.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      UpdateProfileApi updateProfileApi =
          updateProfileApiFromJson(response.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle("Error", updateProfileApi.message);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
      print(response.statusCode);
      print(response.body);
    }
    print(userid);
    print(header);
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  buildfirstnamefield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          controller: firstnameController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: 'Please enter your First Name');
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your name';
              //addError(error: kNamelNullError);

            }
            return null;
          },
          decoration: const InputDecoration(
              //labelText: "Name",
              hintText: 'First Name',
              hintStyle: TextStyle(color: Colors.black),
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

  buildlastnamefield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          controller: lastnameController,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: 'Please enter your Last Name');
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your Last name';
              //addError(error: kNamelNullError);

            }
            return null;
          },
          decoration: const InputDecoration(
              //labelText: "Name",
              hintText: 'Last Name',
              hintStyle: TextStyle(color: Colors.black),
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

  biuldemailfield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: 'Please enter your email');
            } else if (emailValidatorRegExp.hasMatch(value)) {
              removeError(error: kInvalidEmailError);
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your email';
            } else if (!emailValidatorRegExp.hasMatch(value)) {
              return kInvalidEmailError;
              //addError(error: kInvalidEmailError);

            }
            return null;
          },
          decoration: const InputDecoration(
              //labelText: "Name",
              hintText: 'Email Address',
              hintStyle: TextStyle(color: Colors.black),
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

  buildphonefield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              //labelText: "Name",
              hintText: 'Phone Number',
              hintStyle: TextStyle(color: Colors.black),
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

  buildaboutmefield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextField(
        cursorColor: Colors.black,
        maxLines: 4,
        maxLength: 255,
        controller: aboutController,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Calibri',
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: EdgeInsets.all(8.0),
          hintText: 'About Yourself',
          hintStyle: TextStyle(
            color: Colors.black,
            fontFamily: 'Calibri',
          ),
        ),
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
              updateprofile();
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

  void getprofiledata() async {
    var profileresponse = await http.get(
        Uri.parse('$apiurl/getProfileData/personal_details'),
        headers: {"Authorization": header});

    if (profileresponse.statusCode == 200) {
      GetPersonalData getPersonalData =
          getPersonalDataFromJson(profileresponse.body);
      setState(() {
        name = getPersonalData.userName;
        email = getPersonalData.email;
        imageurl = getPersonalData.profileImageUrl;
        firstname = getPersonalData.firstName;
        lastname = getPersonalData.lastName;
        userid = getPersonalData.id;
        mobile = getPersonalData.mobile;
        emailController.text = email;
        firstnameController.text = firstname;
        lastnameController.text = lastname;
        phoneController.text = mobile ?? "";
        aboutController.text = getPersonalData.userProfile ?? "";

        contactscount = getPersonalData.contactsCount.toString();
        isprofileprivate = getPersonalData.isProfilePrivate;
        print('Mobile no is');
        print(mobile);

        _isInAsyncCall = false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('isprofileprivate', isprofileprivate);
      prefs.setString('totalcontactscount', contactscount);
      print(profileresponse.body);
      setuserdetails();
    } else {
      print(profileresponse.statusCode);
      BlurryDialogSingle alert =
          BlurryDialogSingle('Error', 'Something went wrong');
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

  void setuserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('imageurl', imageurl ?? "");
    prefs.setString('name', name);
    prefs.setString('userid', userid);
    prefs.setString('header', header);
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
