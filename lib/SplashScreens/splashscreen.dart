import 'package:decideitfinal/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../Home/homescreen.dart';
import '../LoginScreens/Login.dart';
import '../Registration/Signup.dart';
import 'SocialMediaList.dart';
import 'VideoPlayer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("images/splash_background.png"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.05), BlendMode.dstATop),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Image.asset('logos/DI_Logo.png')),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset("images/Background.png", fit: BoxFit.cover),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.16,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: RaisedButton(
                        elevation: 5.0,
                        padding: const EdgeInsets.all(11.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: kBluePrimaryColor,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                        },
                        child: Text(
                          'Login',
                          //maxLines: 2,
                          style: TextStyle(
                              color: kBackgroundColor,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.32,
                      child: RaisedButton(
                        elevation: 5.0,
                        color: kOrangePrimaryColor,
                        padding: const EdgeInsets.all(11.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Signup()));
                        },
                        child: Text(
                          'Register',
                          //maxLines: 2,
                          style: TextStyle(
                              color: kBackgroundColor,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              GestureDetector(
                onTap: () => print('Sign Up Button Pressed'),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print('here');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                          },
                        text: 'Continue without Login >>',
                        style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: kBluePrimaryColor,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold),
                        text: 'About Decide',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openvideo();
                          }),
                    TextSpan(
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: kOrangePrimaryColor,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold),
                        text: 'It',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            openvideo();
                          }),
                  ],
                ),
              )
            ],
          ),

          //Image.asset('images/decideit_text.png'),
        ],
      ),
    );
  }

  openvideo() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => VideoPlayerApp()));
  }
}
