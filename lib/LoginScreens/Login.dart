// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:ui';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/LoginScreens/GetLoginToken.dart';
import 'package:decideitfinal/LoginScreens/ResendEmail.dart';
import 'package:decideitfinal/LoginScreens/SocialMediaList.dart';
import 'package:decideitfinal/LoginScreens/linkedindata.dart';
import 'package:decideitfinal/ProfileScreens/PersonalProfile.dart';
import 'package:decideitfinal/QuestionDetail/QuestionDetail.dart';
import 'package:decideitfinal/Registration/Signup.dart';
import 'package:decideitfinal/SplashScreens/splashscreen.dart';
import 'package:decideitfinal/alertDialog.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:linkedin_login/linkedin_login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import '../ForgotPasswordScreens/ForgotPassword.dart';
import 'LoginValidate.dart';
import 'UserAPI.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

late GoogleSignIn _googleSignIn;

class _LoginScreenState extends State<LoginScreen> {
  bool isLoggedIn = false;
  var profileData;
  var facebookLogin = FacebookLogin();
  bool isAuth = false;
  late bool _canCheckBiometrics;
  final String _authorized = "Not Authorized";
  final bool _rememberMe = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  int emcounter = 0;
  int pascounter = 0;
  int _groupValue = 0;
  List<String> emaillist = [];
  List<String> passlist = [];
  final String clientId = '77luhum7k34pkd';
  final String clientSecret = 'Zt0jtIwkk2bGDbRb';
  final String redirecturl = 'https://oauth.io/auth';
  var profileimage = "HOWDY";
  var name;
  var email;
  var firstname;
  var lastname;
  var number;
  var userid;
  Color selectedemailcolor = kBluePrimaryColor;
  Color selectedphonecolor = Colors.black;
  Color selectedusernamecolor = Colors.black;
  late GoogleSignInAccount _currentUser;
  bool isFacebook = false;
  bool isLinkedin = false;
  bool isTwitter = false;
  bool isGoogle = false;
  bool isApple = false;
  var header;
  late SharedPreferences userdetails;
  var shared;
  bool _isInAsyncCall = false;
  bool obscuretext = true;

  bool emailspace = false, passwordspace = false, isquestiondetail = false;
  AppBar appbar = AppBar();
  late int facebookid, twitterid, linkedinid, appleid, googleid, isemail;
  late String questionid;
  late String password;
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var logged = prefs.getString('isloggedin');
    print(logged);
  }

  @override
  void initState() {
    // ignore: missing_required_param

    getlist();
    //getuserDeatils();
    _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'profile',
        //'https://www.googleapis.com/auth/contacts.readonly'
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      key: _scaffoldkey,
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: Stack(
          children: [
            Container(
              //height: MediaQuery.of(context).size.height,
              //width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("images/Login-Bg.png"),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8), BlendMode.dstATop),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                /*Navigator.push(
                                    context,
                                    BouncyPageRoute(
                                        widget: SplashScreen(),
                                        alignment: Alignment.topLeft));*/
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SplashScreen()));
                              },
                              child: const Icon(Icons.arrow_back_ios)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.32,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.13,
                              child: Image.asset('logos/DI_Logo.png'))
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Join/Sign in through your social media: ',
                      style: TextStyle(
                        color: kBluePrimaryColor,
                        fontFamily: 'OpenSans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  //SizedBox(height: 10.0),
                  _buildSocialBtnRow(),
                  const SizedBox(
                    height: 25,
                  ),
                  const Center(child: Text('OR')),
                  const SizedBox(
                    height: 25,
                  ),
                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Enter your details:',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold),
                    ),
                  ),*/
                  /*Container(
                    //color: kBackgroundColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: buildoptionsforsignin(),
                  ),*/
                  Container(
                    //color: kBackgroundColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 15.0),
                          _buildEmailTF(),
                          const SizedBox(height: 20.0),
                          _buildPasswordTF(),
                          _buildForgotPasswordBtn(),
                          _buildLoginBtn(),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildSignupBtn(),
                          const SizedBox(
                            height: 5,
                          ),
                          _buildRegisterText(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildoptionsforsignin() {
    return InkWell(
      child: Row(
        children: [
          Radio(
              value: 0,
              groupValue: _groupValue,
              onChanged: (newValue) {
                setState(() {
                  _groupValue = int.parse(newValue.toString());
                  selectedemailcolor = kBluePrimaryColor;
                  selectedphonecolor = Colors.black;
                  selectedusernamecolor = Colors.black;
                });
              }),
          GestureDetector(
            onTap: () {
              setState(() {
                _groupValue = 0;
                selectedemailcolor = kBluePrimaryColor;
                selectedphonecolor = Colors.black;
                selectedusernamecolor = Colors.black;
              });
            },
            child: Text(
              'Email',
              style: TextStyle(
                color: selectedemailcolor,
              ),
            ),
          ),
          Radio(
              value: 2,
              groupValue: _groupValue,
              onChanged: (newValue) {
                setState(() {
                  _groupValue = int.parse(newValue.toString());
                  selectedemailcolor = Colors.black;
                  selectedphonecolor = Colors.black;
                  selectedusernamecolor = kBluePrimaryColor;
                });
              }),
          GestureDetector(
            onTap: () {
              setState(() {
                _groupValue = 2;
                selectedemailcolor = Colors.black;
                selectedphonecolor = Colors.black;
                selectedusernamecolor = kBluePrimaryColor;
              });
            },
            child: Text(
              'Username',
              style: TextStyle(
                color: selectedusernamecolor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailTF() {
    if (_groupValue == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Email Adress/Username',
            style: const TextStyle(
              color: kBluePrimaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  emailspace = true;
                  passwordspace = false;
                });
              },
              child: TextFormField(
                cursorColor: kBluePrimaryColor,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => email = newValue,
                style: const TextStyle(
                  color: kBluePrimaryColor,
                  fontFamily: 'OpenSans',
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    removeError(
                        error: 'Please enter your email address or username');
                  } else if (value.contains('@') &&
                      emailValidatorRegExp.hasMatch(value)) {
                    removeError(error: kInvalidEmailError);
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email address or username';
                    //addError(error: kEmailNullError);

                  } else if (value.contains('@') &&
                      !emailValidatorRegExp.hasMatch(value)) {
                    return kInvalidEmailError;
                    //addError(error: kInvalidEmailError);

                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 14.0),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kBluePrimaryColor),
                  ),
                  hintText: 'Enter your Email/Username',
                  hintStyle: TextStyle(
                    color: kBluePrimaryColor,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
          ),
          emailspace
              ? SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                )
              : const SizedBox(),
        ],
      );
    } else if (_groupValue == 2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Username',
            style: TextStyle(
              color: kBluePrimaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  emailspace = true;
                  passwordspace = false;
                });
              },
              child: TextField(
                cursorColor: kBluePrimaryColor,
                controller: emailController,
                //keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: kBluePrimaryColor,
                  fontFamily: 'OpenSans',
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 14.0),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kBluePrimaryColor),
                  ),
                  hintText: 'Enter your Username',
                  hintStyle: TextStyle(
                    color: kBluePrimaryColor,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ),
          ),
          emailspace
              ? SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                )
              : const SizedBox(),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: const TextStyle(
            color: kBluePrimaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          //height: 60.0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                emailspace = false;
                passwordspace = true;
              });
            },
            child: TextFormField(
              controller: passwordController,
              cursorColor: kBluePrimaryColor,
              obscureText: obscuretext,
              onSaved: (newValue) => password = newValue!,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kPassNullError);
                } else if (value.length >= 8) {
                  removeError(error: kShortPassError);
                }
                password = value;
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
              style: const TextStyle(
                color: kBluePrimaryColor,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 14.0),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: kBluePrimaryColor),
                ),
                suffixIcon: obscuretext
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            obscuretext = false;
                          });
                        },
                        child: Image.asset(
                          'images/invisible.png',
                          //fit: BoxFit.cover,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            obscuretext = true;
                          });
                        },
                        child: Image.asset(
                          'images/eye.png',
                          //fit: BoxFit.cover,
                        ),
                      ),
                hintText: 'Enter your Password',
                hintStyle: const TextStyle(
                  color: kBluePrimaryColor,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ),
        passwordspace
            ? SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Container(
          alignment: Alignment.centerRight,
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ForgotPassword()));
            },
            padding: const EdgeInsets.only(right: 0.0),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: kOrangePrimaryColor,
                //fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton(
          elevation: 5.0,
          onPressed: validateLogin,
          padding: const EdgeInsets.all(11.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: kBluePrimaryColor,
          child: const Text(
            'SIGN IN',
            style: TextStyle(
              color: kBackgroundColor,
              //letterSpacing: 1.5,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          isFacebook
              ? GestureDetector(
                  onTap: initiateFacebookLogin,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'logos/facebook.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          isGoogle
              ? GestureDetector(
                  onTap: initiateGoogleLogin,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'logos/google.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          isLinkedin
              ? GestureDetector(
                  onTap: initiatelinkedinlogin,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'logos/linkedin.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          isTwitter
              ? GestureDetector(
                  onTap: initiatetwitterlogin,
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'logos/twitter.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          isApple
              ? GestureDetector(
                  onTap: () {
                    print('Apple Login');
                    initiateAppleLogin();
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'logos/apple.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Future<void> initiatetwitterlogin() async {
    final twitterLogin = TwitterLogin(
      apiKey: 'aicqQQQ2qBmbvrt9OPH6thus3',
      apiSecretKey: 'ctLSZTMSQtppaYm1A6cwWWYFwQkdGkgRrpn4LcYplxXlcbUEQ9',
      redirectURI: 'twitterkit-aicqQQQ2qBmbvrt9OPH6thus3://',
    );
    print('Twitter');
    final authResult = await twitterLogin.login();
    switch (authResult.status!) {
      case TwitterLoginStatus.loggedIn:
        name = authResult.user!.name;
        email = authResult.user!.email;
        profileimage = authResult.user!.thumbnailImage;
        var url = Uri.parse('$apiurl/login');
        var body = {
          'user_email_mobile': email,
          'password': "",
          'social_network_id': twitterid,
          'user_name': name,
          'provider_user_id': authResult.authToken.toString()
          /*'profileimageurl': filename*/
        };

        var response1 = await http.post(url,
            body: json.encode(body),
            headers: {"Content-Type": "application/json"},
            encoding: Encoding.getByName("utf-8"));

        if (response1.statusCode == 200) {
          showSnackBar("Login Successful");
          GetLoginToken getLoginToken = getLoginTokenFromJson(response1.body);
          header = "${getLoginToken.tokenType} ${getLoginToken.accessToken}";

          isemail = getLoginToken.emailAvailable;

          var userresponse = await http.get(
            Uri.parse('$apiurl/user'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": header
            },
          );

          if (userresponse.statusCode == 200) {
            UserApi userAPI = userApiFromJson(userresponse.body);
            name = userAPI.userName;
            userid = userAPI.id;
            profileimage = userAPI.profileImageUrl ?? "";
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('header', header);
            prefs.setString('email', email);
            prefs.setString('userid', userid);
            prefs.setString('name', name);
            prefs.setString('imageurl', profileimage);
            prefs.setInt('isemail', isemail);
            if (isemail == 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PersonalProfile()));
            } else {
              if (isquestiondetail) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String> searchlist = [];

                List<String> sourcelist = [];
                var sharedsearchlist = prefs.getStringList('searchword');
                var sharedsourcelist = prefs.getStringList('communitysource');

                if (sharedsourcelist != null) {
                  sourcelist = sharedsourcelist;
                  searchlist = sharedsearchlist!;
                }
                searchlist.add(questionid);
                sourcelist.add(1.toString());
                prefs.setStringList('communitysource', sourcelist);
                prefs.setStringList('searchword', searchlist);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QuestionDetail(questionid)));
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }
            }
          } else {
            print(response1.statusCode);
            ValidateLogin validatelogin = validateLoginFromJson(response1.body);
            var mesage = validatelogin.message;
            BlurryDialog alert = BlurryDialog("Error", mesage);
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
        // success

        break;
      case TwitterLoginStatus.cancelledByUser:
        // cancel
        print('Cancekked by user');
        break;
      case TwitterLoginStatus.error:
        // error
        print(authResult.errorMessage);
        break;
    }
    print('Helllllllo Twitter');
  }

  void initiatelinkedinlogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LinkedInUserWidget(
          appBar: AppBar(
            title: const Text('Linkedin Login'),
          ),
          redirectUrl: redirecturl,
          clientId: clientId,
          clientSecret: clientSecret,
          onGetUserProfile: (linkedInUser) async {
            Map<String, dynamic> postJson = {
              "user_id": linkedInUser.user.userId,
              "email": linkedInUser.user.email!.elements!.isEmpty
                  ? null
                  : linkedInUser
                      .user.email!.elements![0].handleDeep!.emailAddress,
              "name":
                  '${linkedInUser.user.firstName!.localized!.label} ${linkedInUser.user.lastName!.localized!.label}',
              "token": linkedInUser.user.token.accessToken,
              "expires_in": linkedInUser.user.token.expiresIn
            };
            LinkedinData linkedinData = LinkedinData.fromJson(postJson);
            print(linkedinData.email);
            name = linkedinData.name;
            email = linkedinData.email;
            firstname = linkedInUser.user.firstName!.localized!.label;
            lastname = linkedInUser.user.lastName!.localized!.label;
            var url = Uri.parse('$apiurl/login');
            var body = {
              'user_email_mobile': email,
              'password': "",
              'social_network_id': linkedinid,
              'user_name': name,
              'provider_user_id': linkedinData.user_id
              /*'profileimageurl': filename*/
            };

            var response1 = await http.post(url,
                body: json.encode(body),
                headers: {"Content-Type": "application/json"},
                encoding: Encoding.getByName("utf-8"));

            if (response1.statusCode == 200) {
              isLoggedIn = true;
              showSnackBar("Login Successful");
              GetLoginToken getLoginToken =
                  getLoginTokenFromJson(response1.body);
              header =
                  "${getLoginToken.tokenType} ${getLoginToken.accessToken}";

              isemail = getLoginToken.emailAvailable;

              var userresponse = await http.get(
                Uri.parse('$apiurl/user'),
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": header
                },
              );

              if (userresponse.statusCode == 200) {
                UserApi userAPI = userApiFromJson(userresponse.body);
                name = userAPI.userName;
                userid = userAPI.id;
                profileimage = userAPI.profileImageUrl ?? "";
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('header', header);
                prefs.setString('email', email);
                prefs.setString('userid', userid);
                prefs.setString('name', name);
                prefs.setString('imageurl', profileimage);
                prefs.setInt('isemail', isemail);
                if (isemail == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PersonalProfile()));
                } else {
                  if (isquestiondetail) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    List<String> searchlist = [];

                    List<String> sourcelist = [];
                    var sharedsearchlist = prefs.getStringList('searchword');
                    var sharedsourcelist =
                        prefs.getStringList('communitysource');
                    print('Coming from question card');
                    print(searchlist);
                    print(questionid);
                    if (sharedsourcelist != null) {
                      sourcelist = sharedsourcelist;
                      searchlist = sharedsearchlist!;
                    }
                    searchlist.add(questionid);
                    sourcelist.add(1.toString());
                    print('Source List items');
                    print(sourcelist);
                    prefs.setStringList('communitysource', sourcelist);
                    prefs.setStringList('searchword', searchlist);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QuestionDetail(questionid)));
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                }
              } else {
                print(response1.statusCode);
                ValidateLogin validatelogin =
                    validateLoginFromJson(response1.body);
                var mesage = validatelogin.message;
                BlurryDialog alert = BlurryDialog("Error", mesage);
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
          },
          onError: (error) {
            print('Error description: ${error.exception}');
          },
        ),
        fullscreenDialog: true,
      ),
    );
  }

  Future<void> initiateGoogleLogin() async {
    try {
      _currentUser = (await _googleSignIn.signIn())!;
      print(_currentUser);
      profileimage = _currentUser.photoUrl!;
      name = _currentUser.displayName;
      email = _currentUser.email;
      print(_currentUser);
      var url = Uri.parse('$apiurl/login');
      var body = {
        'user_email_mobile': email,
        'password': "",
        'social_network_id': googleid,
        'provider_user_id': _currentUser.id,
        'user_name': name
        /*'profileimageurl': filename*/
      };

      var response = await http.post(url,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"},
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        isLoggedIn = true;
        showSnackBar("Login Successful");
        GetLoginToken getLoginToken = getLoginTokenFromJson(response.body);
        header = "${getLoginToken.tokenType} ${getLoginToken.accessToken}";

        isemail = getLoginToken.emailAvailable;

        var userresponse = await http.get(
          Uri.parse('$apiurl/user'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": header
          },
        );

        if (userresponse.statusCode == 200) {
          UserApi userAPI = userApiFromJson(userresponse.body);
          name = userAPI.userName;
          userid = userAPI.id;
          profileimage = userAPI.profileImageUrl ?? "";
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('header', header);
          prefs.setString('email', email);
          prefs.setString('userid', userid);
          prefs.setString('name', name);
          prefs.setString('imageurl', profileimage);
          prefs.setInt('isemail', isemail);
          if (isemail == 0) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PersonalProfile()));
          } else {
            if (isquestiondetail) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              List<String> searchlist = [];

              List<String> sourcelist = [];
              var sharedsearchlist = prefs.getStringList('searchword');
              var sharedsourcelist = prefs.getStringList('communitysource');
              print('Coming from question card');
              print(searchlist);
              print(questionid);
              if (sharedsourcelist != null) {
                sourcelist = sharedsourcelist;
                searchlist = sharedsearchlist!;
              }
              searchlist.add(questionid);
              sourcelist.add(1.toString());
              print('Source List items');
              print(sourcelist);
              prefs.setStringList('communitysource', sourcelist);
              prefs.setStringList('searchword', searchlist);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuestionDetail(questionid)));
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          }
        }

        print(header);
      } else {
        print(response.statusCode);
        print(response);
        ValidateLogin validatelogin = validateLoginFromJson(response.body);
        var mesage = validatelogin.message;
        BlurryDialog alert = BlurryDialog("Error", mesage);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            return alert;
          },
        );
      }
    } catch (error) {
      print(error);
    }
  }

  void initiateFacebookLogin() async {
    var facebookLoginResult = await facebookLogin.logIn(permissions: [
      FacebookPermission.email,
    ]);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancel:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.success:
        var graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(400)&access_token=${facebookLoginResult.accessToken!.token}'));

        var profile = json.decode(graphResponse.body);
        print(profile.toString());
        profileimage = profile['picture']['data']['url'];
        name = profile['name'];
        email = profile['email'];
        var url = Uri.parse('$apiurl/login');
        var body = {
          'user_email_mobile': email,
          'password': "",
          'social_network_id': facebookid,
          'provider_user_id': profile['id'],
          'first_name': profile['first_name'],
          'last_name': profile['last_name'],
          'user_name': profile['name']
          /*'profileimageurl': filename*/
        };

        var response = await http.post(url,
            body: json.encode(body),
            headers: {"Content-Type": "application/json"},
            encoding: Encoding.getByName("utf-8"));

        if (response.statusCode == 200) {
          isLoggedIn = true;
          showSnackBar("Login Successful");
          GetLoginToken getLoginToken = getLoginTokenFromJson(response.body);
          header = "${getLoginToken.tokenType} ${getLoginToken.accessToken}";
          isemail = getLoginToken.emailAvailable;

          var userresponse = await http.get(
            Uri.parse('$apiurl/user'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": header
            },
          );

          if (userresponse.statusCode == 200) {
            UserApi userAPI = userApiFromJson(userresponse.body);
            name = userAPI.userName;
            userid = userAPI.id;
            profileimage = userAPI.profileImageUrl ?? "";
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('header', header);
            prefs.setString('email', email);
            prefs.setString('userid', userid);
            prefs.setString('name', name);
            prefs.setString('imageurl', profileimage);
            prefs.setInt('isemail', isemail);
            if (isemail == 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PersonalProfile()));
            } else {
              if (isquestiondetail) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String> searchlist = [];

                List<String> sourcelist = [];
                var sharedsearchlist = prefs.getStringList('searchword');
                var sharedsourcelist = prefs.getStringList('communitysource');
                print('Coming from question card');
                print(searchlist);
                print(questionid);
                if (sharedsourcelist != null) {
                  sourcelist = sharedsourcelist;
                  searchlist = sharedsearchlist!;
                }
                searchlist.add(questionid);
                sourcelist.add(1.toString());
                print('Source List items');
                print(sourcelist);
                prefs.setStringList('communitysource', sourcelist);
                prefs.setStringList('searchword', searchlist);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QuestionDetail(questionid)));
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }
            }
          } else {
            print(userresponse.statusCode);
          }
        } else {
          print(response.statusCode);
          print(response);
          ValidateLogin validatelogin = validateLoginFromJson(response.body);
          var mesage = validatelogin.message;
          BlurryDialog alert = BlurryDialog("Error", mesage);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return alert;
            },
          );
        }
        print(profileimage);
        onLoginStatusChanged(true, profileData: profile);

        break;
    }
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                //fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Signup()));
              },
            text: 'Register',
            style: const TextStyle(
              color: kOrangePrimaryColor,
              fontSize: 16.0,
            ),
          ),
          const TextSpan(
            text: ' with ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          const TextSpan(
            text: 'Decide',
            style: TextStyle(
              color: kBluePrimaryColor,
              fontSize: 16.0,
            ),
          ),
          const TextSpan(
            text: 'It ',
            style: TextStyle(
              color: kOrangePrimaryColor,
              fontSize: 16.0,
            ),
          ),
          const TextSpan(
            text: 'now',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              //fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void showSnackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
    ));
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

  Future<void> validateLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isInAsyncCall = true;
      });
      //try {
        var url = Uri.parse('$apiurl/login');
        var body = {
          'user_email_mobile': emailController.text,
          'password': passwordController.text,
          'social_network_id': 1,
          /*'profileimageurl': filename*/
        };

        var response = await http.post(url,
            body: json.encode(body),
            headers: {"Content-Type": "application/json"},
            encoding: Encoding.getByName("utf-8"));

        if (response.statusCode == 200) {
          isLoggedIn = true;
          showSnackBar("Login Successful");
          GetLoginToken getLoginToken = getLoginTokenFromJson(response.body);
          header = "${getLoginToken.tokenType} ${getLoginToken.accessToken}";
          isemail = getLoginToken.emailAvailable;

          var userresponse = await http.get(
            Uri.parse('$apiurl/user'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": header
            },
          );

          setState(() {
            _isInAsyncCall = false;
          });

          int isprofileprivate = 0;
          if (userresponse.statusCode == 200) {
            UserApi userAPI = userApiFromJson(userresponse.body);
            name = userAPI.userName;
            userid = userAPI.id;
            profileimage = userAPI.profileImageUrl ?? "";
            isprofileprivate = userAPI.isProfilePrivate;
            email = userAPI.email;
            Plan? plan = userAPI.plan;
            String? planid = "";
            if(plan != null){
              planid = plan.id;
            }
            
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('header', header);
            prefs.setString('email', email);
            prefs.setString('userid', userid);
            prefs.setString('name', name);
            prefs.setString('imageurl', profileimage);
            prefs.setString('planid', planid);
            prefs.setInt('isprofileprivate', isprofileprivate);
            prefs.setInt('isemail', isemail);
            if (isemail == 0) {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PersonalProfile()));
            } else {
              if (isquestiondetail) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                List<String> searchlist = [];

                List<String> sourcelist = [];
                var sharedsearchlist = prefs.getStringList('searchword');
                var sharedsourcelist = prefs.getStringList('communitysource');
                print('Coming from question card');
                print(searchlist);
                print(questionid);
                if (sharedsourcelist != null) {
                  sourcelist = sharedsourcelist;
                  searchlist = sharedsearchlist!;
                }
                searchlist.add(questionid);
                sourcelist.add(1.toString());
                print('Source List items');
                print(sourcelist);
                prefs.setStringList('communitysource', sourcelist);
                prefs.setStringList('searchword', searchlist);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => QuestionDetail(questionid)));
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              }
            }
          }

          print(header);
        } else if (response.statusCode == 401) {
          ResendEmail resendEmail = resendEmailFromJson(response.body);
          Data data = resendEmail.data;
          var message = resendEmail.message;
          showactivationdialog(message, data.userId);
        } else {
          print(response.statusCode);
          print(response.body);
          setState(() {
            _isInAsyncCall = false;
          });
          ValidateLogin validatelogin = validateLoginFromJson(response.body);
          var mesage = validatelogin.message;
          BlurryDialogSingle alert = BlurryDialogSingle("Error", mesage);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return alert;
            },
          );
        }
      // } catch (err) {
      //   print(err.toString());
      // }
    }
  }

  Future<void> getlist() async {
    SharedPreferences userprefs = await SharedPreferences.getInstance();
    var sharedregister = userprefs.getString('Registration');
    var sharedpassword = userprefs.getString('ForgotPassword');
    var sharedresetpassword = userprefs.getString('ResetPassword');
    var sharedreport = userprefs.getString('ReportQuestion');
    var sharedlogin = userprefs.getString('LoginValidate');
    var sharedanswer = userprefs.getString('AnswerwithoutLogin');
    var sharedemailchanged = userprefs.getString('emailchanged');
    if (sharedemailchanged != null) {
      showSnackBar(sharedemailchanged);
      userprefs.remove('emailchanged');
    }
    if (sharedanswer != null) {
      print('In shared answer');
      questionid = userprefs.getString('QuestionID')!;
      isquestiondetail = true;
      showSnackBar(sharedanswer);
      userprefs.remove('AnswerwithoutLogin');
    }
    if (sharedregister != null) {
      showSnackBar(sharedregister);
      userprefs.remove('Registration');
    }
    if (sharedlogin != null) {
      showSnackBar(sharedlogin);
      userprefs.remove('LoginValidate');
    }
    if (sharedresetpassword != null) {
      showSnackBar(sharedresetpassword);
      userprefs.remove('ResetPassword');
    }
    if (sharedpassword != null) {
      showSnackBar(sharedpassword);
      userprefs.remove('ForgotPassword');
    }
    if (sharedreport != null) {
      showSnackBar(sharedreport);
      userprefs.remove('ReportQuestion');
    }
    setState(() {
      _isInAsyncCall = true;
    });
    print('Url is');
    print(apiurl);
    var response = await http.get(Uri.parse('$apiurl/social-network'));
    print(response.body);
    setState(() {
      _isInAsyncCall = false;
    });
    SocialMediaList list = socialMediaListFromJson(response.body);
    List<Datum> sociallist = list.data;
    List<String> namelist = [];
    List<int> idlist = [];
    for (int i = 0; i < sociallist.length; i++) {
      namelist.add(sociallist[i].name);
      idlist.add(sociallist[i].id);
    }
    var temp;
    if (namelist.contains('facebook')) {
      temp = namelist.indexOf('facebook');
      facebookid = idlist[temp];
      isFacebook = true;
    }
    if (namelist.contains('twitter')) {
      temp = namelist.indexOf('twitter');
      twitterid = idlist[temp];
      isTwitter = true;
    }
    if (namelist.contains('linkedin')) {
      temp = namelist.indexOf('linkedin');
      linkedinid = idlist[temp];
      isLinkedin = true;
    }
    if (namelist.contains('google')) {
      temp = namelist.indexOf('google');
      googleid = idlist[temp];
      isGoogle = true;
    }
    if (namelist.contains('apple')) {
      temp = namelist.indexOf('apple');
      appleid = idlist[temp];
      isApple = true;
    }
    setState(() {
      print(isFacebook);
      _buildSocialBtnRow();
    });
  }

  void getuserDeatils() async {
    SharedPreferences userprefs = await SharedPreferences.getInstance();
    name = userprefs.getString('UserName');
    number = userprefs.getString('Number');
    email = userprefs.getString('Email');
  }

  void initiateAppleLogin() async {
    print('Calling url');
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            //AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
            clientId: 'com.openeyes.decideit.sid',
            redirectUri: Uri.parse(
              'https://decideit-305606.firebaseapp.com/__/auth/handler',
            ),
          ));
      print('Apple ID credentials');
      print(credential);
      //email = credential.email;
      name = credential.givenName;
      String provideruesrid = credential.userIdentifier!;
      print(credential.authorizationCode);

      if (credential.authorizationCode == 'canceled') {
        print('Cancelled');
      }

      var url = Uri.parse('$apiurl/login');
      var body = {
        'user_email_mobile': "",
        'password': "",
        'social_network_id': appleid,
        'user_name': name,
        'provider_user_id': provideruesrid
      };

      var response1 = await http.post(url,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"},
          encoding: Encoding.getByName("utf-8"));

      if (response1.statusCode == 200) {
        showSnackBar("Login Successful");
        GetLoginToken getLoginToken = getLoginTokenFromJson(response1.body);
        header = "${getLoginToken.tokenType} ${getLoginToken.accessToken}";
        int isemail = getLoginToken.emailAvailable;

        var userresponse = await http.get(
          Uri.parse('$apiurl/user'),
          headers: {
            "Content-Type": "application/json",
            "Authorization": header
          },
        );

        if (userresponse.statusCode == 200) {
          UserApi userAPI = userApiFromJson(userresponse.body);
          name = userAPI.userName;
          userid = userAPI.id;
          profileimage = userAPI.profileImageUrl ?? "";
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('header', header);
          prefs.setString('email', email);
          prefs.setString('userid', userid);
          prefs.setString('name', name);
          prefs.setString('imageurl', profileimage);
          prefs.setInt('isemail', isemail);
          if (isemail == 0) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PersonalProfile()));
          } else {
            if (isquestiondetail) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              List<String> searchlist = [];

              List<String> sourcelist = [];
              var sharedsearchlist = prefs.getStringList('searchword');
              var sharedsourcelist = prefs.getStringList('communitysource');
              print('Coming from question card');
              print(searchlist);
              print(questionid);
              if (sharedsourcelist != null) {
                sourcelist = sharedsourcelist;
                searchlist = sharedsearchlist!;
              }
              searchlist.add(questionid);
              sourcelist.add(1.toString());
              print('Source List items');
              print(sourcelist);
              prefs.setStringList('communitysource', sourcelist);
              prefs.setStringList('searchword', searchlist);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuestionDetail(questionid)));
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            }
          }
        } else {
          print(response1.statusCode);
          ValidateLogin validatelogin = validateLoginFromJson(response1.body);
          var mesage = validatelogin.message;
          BlurryDialog alert = BlurryDialog("Error", mesage);
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
    } catch (e) {
      String error = e.toString();
      var split = error.split('(');
      var errorsplit = split[1].split(',');
      if (errorsplit[0] == "AuthorizationErrorCode.canceled") {
        print('Cancelled');
      } else {
        BlurryDialogSingle alert = BlurryDialogSingle("Error", e.toString());
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
  }

  void showactivationdialog(String message, String userId) {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(const Radius.circular(10)),
          ),
          title: const Text(
            'Error',
            style: const TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: kBackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: kBluePrimaryColor,
                    child: const Text("YES",
                    style: TextStyle(color: kBackgroundColor),
                    ),
                    onPressed: () async {
                      var body = {'user_id': userId};
                      var response = await http.post(
                          Uri.parse('$apiurl/email-verification-resend'),
                          body: json.encode(body),
                          headers: {"Content-Type": "application/json"},
                          encoding: Encoding.getByName("utf-8"));
                      print(response.statusCode);
                      print(response.body);
                      showSnackBar(
                          'Your activation link has been sent successfully');
                      setState(() {
                        _isInAsyncCall = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  color: kBackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: kOrangePrimaryColor,
                    child: const Text("NO",
                    style: TextStyle(color: kBackgroundColor),
                    ),
                    onPressed: () {
                      setState(() {
                        _isInAsyncCall = false;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ));
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

class BlurryDialog_Login extends StatelessWidget {
  String title;
  String content;

  BlurryDialog_Login(this.title, this.content);
  TextStyle textStyle = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: Text(
            title,
            style: textStyle,
          ),
          content: Text(
            content,
            style: textStyle,
          ),
          actions: <Widget>[
            Container(
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
}
