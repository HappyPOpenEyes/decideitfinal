import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:decideitfinal/AddressBook/AddressBook.dart';
import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/Home/Drawer.dart';
import 'package:decideitfinal/Home/QuestionCard.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:decideitfinal/ProfileScreens/PersonalProfile.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import '../Plans/PlanDataAPI.dart';
import '../Plans/PlanDetails.dart';
import 'ChangePassword.dart';
import 'CommunityProfile.dart';
import 'ProfilePlanApi.dart';

class ProfilePlan extends StatefulWidget {
  @override
  _ProfilePlanState createState() => _ProfilePlanState();
}

class _ProfilePlanState extends State<ProfilePlan> {
  var email, name, imageurl, header, userid, planid;
  var selectedIndex = 3;
  var selectedplanid;
  var selectedplanname;
  var selectedplanamount;
  bool _enabled = true;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  TextEditingController _searchcontroller = TextEditingController();
  List<String> transactionidlist = [];
  List<String> transactionplananmes = [];
  List<String> transactionpricelist = [];
  List<String> transactiondatalist = [];
  Map<int, String> monthsInYear = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };
  late CroppedFile _pickedImage;
  bool _isInAsyncCall = false;
  String contactscount = "";
  String filename = "";
  String? nextpaymentdate,
      remainingquestions,
      downgradedplanname,
      downgradedplanamount;
  AppBar appbar = AppBar();
  bool isplandowngraded = false;

  @override
  void initState() {
    // Transparent status bar
    getuserdetails();
    super.initState();
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
                              width: MediaQuery.of(context).size.height * 0.12,
                              height: MediaQuery.of(context).size.height * 0.12,
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
                                                    AddressBook(2)));
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
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Calibri')),
                                          ],
                                        ),
                                      )),
                                ),
                                RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    color: kBluePrimaryColor,
                                    onPressed: () {
                                      print('Address');
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddressBook(2)));
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
                            ),
                          ),
                          label: const Text(''),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => CommunityProfile()));
                          },
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
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
                            itemCount: 1,
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
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                'Plan Information',
                                style: TextStyle(
                                    color: kBluePrimaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Questions Remaining: ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    remainingquestions ?? "",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            color: kBluePrimaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              selectedplanname,
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  color: kBackgroundColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              isplandowngraded
                                                  ? ' \$$downgradedplanamount changes to: $downgradedplanname'
                                                  : '\$' + selectedplanamount,
                                              style: const TextStyle(
                                                  color: kBackgroundColor,
                                                  //fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.27,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PlanList()));
                                          },
                                          color: kBackgroundColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: const BorderSide(
                                                  color: kBluePrimaryColor)),
                                          child: const Text(
                                            'Change Plan',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: kBluePrimaryColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Next Payment On: $nextpaymentdate',
                                              style: const TextStyle(
                                                  color: kBackgroundColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Payment History',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        transactionidlist.isEmpty
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: transactionidlist.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Card(
                                          elevation: 5,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  transactionplananmes[index],
                                                  style: const TextStyle(
                                                      color: kBluePrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  transactiondatalist[index],
                                                  style: const TextStyle(
                                                      color: kBluePrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  '\$${transactionpricelist[index]}',
                                                  style: const TextStyle(
                                                      color:
                                                          kOrangePrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
            ],
          ),
        ),
      ),
    );
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
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => PostQuestion()));
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
        String imagepath = _pickedImage.path;
        print(imagepath);
        print('Filename is given below');
        filename = _pickedImage.path.split('/').last;
        print(filename);
        updateprofilepic();
      });
    }
  }

  void getuserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedplanid = prefs.getString('planid');
    var sharedcontactscount = prefs.getString('totalcontactscount');
    var sharedtransactionstatus = prefs.getString('transacionstatus');

    if (sharedtransactionstatus != null) {
      BlurryDialogSingle alert =
          BlurryDialogSingle("Success", sharedtransactionstatus);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
      prefs.remove('transacionstatus');
    }
    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
      planid = sharedplanid;
      contactscount = sharedcontactscount!;
      getprofileplandata();
    });
    print('coming from shared preference $header$userid$name');
  }

  void getprofileplandata() async {
    var profileresponse = await http.get(
        Uri.parse('$apiurl/getProfileData/plan_details'),
        headers: {"Authorization": header});

    if (profileresponse.statusCode == 200) {
      ProfilePlanApi profilePlanApi =
          profilePlanApiFromJson(profileresponse.body);

      UserPlans userplans = profilePlanApi.userPlans;
      List<Transaction> transactions = userplans.transactions;
      List<PlanDowngradeStatus> subscriptions = userplans.subscriptionHistory;
      PlanDowngradeStatus? plandowngradestatus =
          profilePlanApi.planDowngradeStatus;
      print(profileresponse.body);
      print(transactions.length);
      setState(() {
        if (plandowngradestatus != null) {
          setState(() {
            isplandowngraded = true;
          });

          downgradedplanname = plandowngradestatus.plan!.name;
          downgradedplanamount = plandowngradestatus.plan!.amount;
        }
        for (int i = 0; i < transactions.length; i++) {
          nextpaymentdate = transactions[i].nextPaymentDate;
        }
        remainingquestions = profilePlanApi.questions.toString();
        for (int i = 0; i < subscriptions.length; i++) {
          transactionidlist.add(subscriptions[i].id.toString());
          Plan? plan = subscriptions[i].plan;
          transactionplananmes.add(plan!.name);
          //transactionpricelist.add(transactions[i].amount);
          transactionpricelist.add(plan.amount);
          transactiondatalist.add("");
          //transactiondatalist.add(transactions[i].paymentDate);
        }

        getplandata();
      });
    } else {
      print(profileresponse.statusCode);
      print(profileresponse.body);
    }
  }

  void getplandata() async {
    var body;
    body = {
      "limit": 15,
      "offset": 1,
      "searchData": {"status": "", "searchQuery": ""},
      "searchQuery": "",
      "status": "",
      "sortOrder":
          "[{field: 'amount', dir: 'asc'}] 0: {field: 'amount', dir: 'asc'}",
      "dir": "asc",
      "field": "amount"
    };
    var response = await http.post(Uri.parse('$apiurl/plan/getAll'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(transactiondatalist.length);
      PlanData planData = planDataFromJson(response.body);
      List<Datum> data = planData.data;
      setState(() {
        for (int i = 0; i < data.length; i++) {
          if (planid == data[i].id) {
            selectedplanid = data[i].id;
            selectedplanamount = data[i].amount;
            selectedplanname = data[i].name;
          }
        }
        _enabled = false;
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
      String imagepath = _pickedImage.path;
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

  showImage() {
    return imageurl == '' || imageurl == null
        ? const AssetImage('images/user.jpg')
        : NetworkImage('$imageapiurl/$imageurl');
  }
}
