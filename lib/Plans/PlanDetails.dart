import 'dart:convert';
import 'dart:ui';

import 'package:decideitfinal/Home/QuestionCard.dart';
import 'package:decideitfinal/LoginScreens/UserAPI.dart';
import 'package:decideitfinal/ProfileScreens/ProfilePlan.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:html/parser.dart';
import '../alertDialog.dart';
import 'PlanDataAPI.dart';

class PlanList extends StatefulWidget {
  @override
  _PlanListState createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  var imageurl, name, email, userid, header, planid, profileimage;
  List<String> stripeplanlist = [];
  List<String> planidlist = [];
  List<String> plannamelist = [];
  List<String> planpricelist = [];
  List<String> plandescriptionlist = [];
  List<String> planprivatequevalidity = [];
  List<String> planprivatenumberinvitations = [];
  List<String> planprivatenumcommunities = [];
  List<String> planprivatenumresponses = [];
  List<String> plancommunityquevalidity = [];
  List<String> plancommunitynumberinvitations = [];
  List<String> plancommunitynumcommunities = [];
  List<String> plancommunitynumresponses = [];
  List<int> tempplanprice = [];
  List<Widget> displaycards = [];
  bool _enabled = true;
  List<Color> backgroundcolor = [];
  List<Color> textcolor = [];
  List<Color> buttoncolor = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late PaymentMethod _paymentMethod;
  bool _isInAsyncCall = false;
  var apiresponse;
  var stripe;
  late String _error;
  AppBar appbar = AppBar();

  void setError(dynamic error) {
    print(error.toString());
    /*_scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));*/
    setState(() {
      _error = error.toString();
      print(_error);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
    Stripe.publishableKey =
        "pk_test_51IIyVYBZvxpI65J8Fn74aREuSJpddySUmMOx6TR9KemniQNXI0M60uTuB0pq62JNMMTgkxYs8mXGei7BtrP1y7m700r6URgFCz";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
            height: appbar.preferredSize.height * 0.8,
            child: Image.asset('logos/DI_Logo.png')),
        centerTitle: true,
        backgroundColor: kBluePrimaryColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProfilePlan()));
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Upgrade ',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Membership',
                            style: TextStyle(
                                color: kOrangePrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                    'Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown typesetter in the 15th century who is thought to have scrambled parts of Cicero\'s De Finibus Bonorum et Malorum for use in a type specimen book.'),
              ),
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
                                      1,
                                      ''),
                                  const SizedBox(
                                    height: 5,
                                  )
                                ],
                              );
                            }),
                      ))
                  : getplanlist()
            ],
          ),
        ),
      ),
    );
  }

  void getuserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedplanid = prefs.getString('planid');

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
      planid = sharedplanid;
      getplandata();
    });
    print('coming from shared preference $email$userid$name');
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
      print(response.body);
      setState(() {
        print(planid);
        PlanData planData = planDataFromJson(response.body);
        List<Datum> data = planData.data;
        for (int i = 0; i < data.length; i++) {
          backgroundcolor.add(kBackgroundColor);
          textcolor.add(Colors.black);
          buttoncolor.add(kBluePrimaryColor);
        }
        for (int i = 0; i < data.length; i++) {
          stripeplanlist.add(data[i].stripePlan ?? "");
          planidlist.add(data[i].id);
          plannamelist.add(data[i].name);
          planpricelist.add(data[i].amount);
          plandescriptionlist.add(data[i].description);
          planprivatequevalidity.add(data[i].questionValidity.toString());
          planprivatenumberinvitations
              .add(data[i].numberOfInvitations.toString());
          planprivatenumcommunities.add(data[i].numberOfCommunities.toString());
          planprivatenumresponses.add(data[i].numberOfResponses.toString());
          plancommunityquevalidity
              .add(data[i].communityQuestionValidity.toString());
          plancommunitynumberinvitations
              .add(data[i].communityQuestionNumberOfInvitations.toString());
          plancommunitynumcommunities
              .add(data[i].communityQuestionNumberOfCommunities.toString());
          plancommunitynumresponses
              .add(data[i].communityQuestionNumberOfResponses.toString());
          if (planid == data[i].id) {
            backgroundcolor[i] = kBluePrimaryColor;
            textcolor[i] = kBackgroundColor;
            buttoncolor[i] = kBackgroundColor;
          }
        }
        print('Plan ids');
        print(planidlist);
        for (int i = 0; i < plandescriptionlist.length; i++) {
          final document = parse(plandescriptionlist[i]);
          plandescriptionlist[i] =
              parse(document.body!.text).documentElement!.text;
        }
        displaycards.clear();
        _enabled = false;
        _isInAsyncCall = false;
        for (int i = 0; i < planpricelist.length; i++) {
          var a = double.parse(planpricelist[i]) * 100;
          tempplanprice.add(a.toInt());
        }

        print(tempplanprice);
      });
    } else {
      print(response.statusCode);
      print(response.body);
    }
  }

  getplanlist() {
    print(planpricelist);
    displaycards.clear();
    print(displaycards.length);
    for (int i = 0; i < planidlist.length; i++) {
      displaycards.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // elevation: 5,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(10),
          //   ),
          // ),
          color: backgroundcolor[i],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'PLAN',
                        style: TextStyle(
                          color: textcolor[i],
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'PRICE/VALIDITY',
                        style: TextStyle(
                          color: textcolor[i],
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      plannamelist[i],
                      style: TextStyle(
                          color: textcolor[i],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '\$${planpricelist[i]}/ Month',
                      style: TextStyle(
                          color: textcolor[i] != kBackgroundColor
                              ? kOrangePrimaryColor
                              : kBackgroundColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: MediaQuery.of(context).size.width * 0.364,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showdetails(i);
                      },
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: textcolor[i],
                          fontSize: 12,
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (planid == planidlist[i]) {
                          BlurryDialog alert = BlurryDialog("Error",
                              'The plan you wish to purchase is already active');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              var height = MediaQuery.of(context).size.height;
                              var width = MediaQuery.of(context).size.width;
                              return alert;
                            },
                          );
                        } else {
                          try {
                            var apibody1 = {
                              'returnPaymentIntent': 1.toString(),
                              'amount': planpricelist[i].toString(),
                            };
                            print(apibody1);
                            setState(() {
                              _isInAsyncCall = true;
                            });
                            var apiresponse1 = await http.post(
                                Uri.parse('$apiurl/transaction/createPayment'),
                                body: apibody1,
                                headers: {"Authorization": header},
                                encoding: Encoding.getByName("utf-8"));
                            print(apiresponse1.statusCode);
                            print(apiresponse1.body);
                            var paymentMehtod = await Stripe.instance
                                .createPaymentMethod(
                                    const PaymentMethodParams.card(
                                        paymentMethodData:
                                            PaymentMethodData()));

                            var apibody = {
                              'returnPaymentIntent': 0.toString(),
                              'amount': planpricelist[i].toString(),
                              'stripe_plan': stripeplanlist[i],
                              'payment_method': paymentMehtod.id,
                              'plan_id': planidlist[i],
                              'plan_name': plannamelist[i],
                            };
                            print(apibody);
                            var apiresponse = await http.post(
                                Uri.parse('$apiurl/transaction/createPayment'),
                                body: apibody,
                                headers: {"Authorization": header},
                                encoding: Encoding.getByName("utf-8"));
                            print(apiresponse.statusCode);
                            print(apiresponse.body);
                            if (apiresponse.statusCode == 200) {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.setString('transacionstatus',
                                  'Transaction Successful!!');
                              cleardata();
                              calluserdata();
                              setState(() {
                                _isInAsyncCall = false;
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfilePlan()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Transaction Failed api error!!')));
                            }
                          } on PlatformException catch (err) {
                            setState(() {
                              _isInAsyncCall = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(getPlatformExceptionError(err))));
                          } catch (err) {
                            setState(() {
                              _isInAsyncCall = false;
                            });
                            print(err.toString());
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Transaction Failed: ${err.toString()}')));
                          }
                        }
                      },
                      color: buttoncolor[i],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: kBluePrimaryColor)),
                      child: Text(
                        'Purchase Plan',
                        style: TextStyle(color: backgroundcolor[i]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ));

      displaycards.add(const SizedBox(
        height: 5,
      ));
    }

    return Column(
      children: displaycards,
    );
  }

  void showdetails(int i) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Wrap(
            children: [
              Container(
                //height: MediaQuery.of(context).size.height * 0.8,
                color: const Color(0xFF737373),
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        decoration: const BoxDecoration(
                            color: kOrangePrimaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      'images/Cross.png',
                                      color: kBackgroundColor,
                                      height: 16,
                                      width: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Text(
                                plannamelist[i],
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: kBackgroundColor),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '\$${planpricelist[i]}/ Month',
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: kBackgroundColor),
                            )
                          ],
                        )),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[300],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Center(child: Text(plandescriptionlist[i]))),
                      ),
                    ),
                    Container(
                      color: kBackgroundColor,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                                child: Text(
                              'Private Questions',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kBluePrimaryColor),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Question Validity',
                                    style: TextStyle(fontSize: 18)),
                                const Spacer(),
                                Text(
                                  '${planprivatequevalidity[i]} hours',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Number of invitations',
                                    style: TextStyle(fontSize: 18)),
                                const Spacer(),
                                Text(planprivatenumberinvitations[i],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Number of communities',
                                    style: TextStyle(fontSize: 18)),
                                const Spacer(),
                                Text(planprivatenumcommunities[i],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Number of Responses',
                                    style: TextStyle(fontSize: 18)),
                                const Spacer(),
                                Text(planprivatenumresponses[i],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          const Center(
                              child: Text(
                            'Community Questions',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kBluePrimaryColor),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Question Validity',
                                    style: TextStyle(fontSize: 18)),
                                const Spacer(),
                                Text(
                                  '${plancommunityquevalidity[i]} hours',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Number of invitations',
                                    style: TextStyle(fontSize: 18)),
                                const Spacer(),
                                Text(plancommunitynumberinvitations[i],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Text('Number of communities',
                                    style: TextStyle(fontSize: 18)),
                                const Spacer(),
                                Text(plancommunitynumcommunities[i],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                              top: 8.0,
                              bottom: 45.0,
                            ),
                            child: Row(
                              children: [
                                const Text('Number of Responses',
                                    style: TextStyle(fontSize: 18)),
                                const Spacer(),
                                Text(plancommunitynumresponses[i],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  purchaseplan() {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Text(
            'Enter Details',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            children: [
              Container(
                color: Colors.grey,
                child: Column(
                  children: [
                    const Text(
                      'DecideIt',
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Container(
              color: kBackgroundColor,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: RaisedButton(
                color: kBluePrimaryColor,
                child: const Text("OK",
                style: TextStyle(color: kBackgroundColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ));
  }

  getPlatformExceptionError(PlatformException err) {
    String message = "Something went Wrong";
    if (err.code == 'cancelled') {
      message = "Transaction Cancelled";
    }

    return message;
  }

  void userdetailapi() async {
    var userresponse = await http.get(
      Uri.parse('$apiurl/user'),
      headers: {"Content-Type": "application/json", "Authorization": header},
    );

    if (userresponse.statusCode == 200) {
      UserApi userAPI = userApiFromJson(userresponse.body);
      name = userAPI.userName;
      userid = userAPI.id;
      profileimage = userAPI.profileImageUrl;
      Plan? plan = userAPI.plan;
      planid = plan!.id;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('header', header);
      prefs.setString('email', email);
      prefs.setString('userid', userid);
      prefs.setString('name', name);
      prefs.setString('imageurl', profileimage);
      prefs.setString('planid', planid);
      print('In user aPI call');
      print(planid);
      cleardata();

      print(displaycards.length);
      getplandata();
    }
  }

  void cleardata() {
    displaycards.clear();
    for (int i = 0; i < planidlist.length; i++) {
      backgroundcolor[i] = kBackgroundColor;
      textcolor[i] = Colors.black;
      buttoncolor[i] = kBluePrimaryColor;
    }

    planidlist = [];
    plannamelist = [];
    planpricelist = [];
    plandescriptionlist = [];
    planprivatequevalidity = [];
    planprivatenumberinvitations = [];
    planprivatenumcommunities = [];
    planprivatenumresponses = [];
    plancommunityquevalidity = [];
    plancommunitynumberinvitations = [];
    plancommunitynumcommunities = [];
    plancommunitynumresponses = [];
    tempplanprice = [];
  }

  void calluserdata() async {
    var userresponse = await http.get(
      Uri.parse('$apiurl/user'),
      headers: {"Content-Type": "application/json", "Authorization": header},
    );
    if (userresponse.statusCode == 200) {
      UserApi userAPI = userApiFromJson(userresponse.body);
      name = userAPI.userName;
      userid = userAPI.id;
      profileimage = userAPI.profileImageUrl;
      email = userAPI.email;
      Plan? plan = userAPI.plan;
      String planid = plan!.id;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('header', header);
      prefs.setString('email', email);
      prefs.setString('userid', userid);
      prefs.setString('name', name);
      prefs.setString('imageurl', profileimage);
      prefs.setString('planid', planid);
    }
  }
}
