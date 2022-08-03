import 'dart:ui';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';

import 'LoginScreens/Login.dart';

class LoginDialog extends StatelessWidget {
  String title;
  String content;

  LoginDialog(this.title, this.content);
  TextStyle textStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: new Text(
            title,
            style: textStyle,
          ),
          content: new Text(
            content,
            style: textStyle,
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
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            fontSize: 15,
                            color: kBackgroundColor,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                new SizedBox(
                  width: 10,
                ),
                Container(
                  color: kBackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: RaisedButton(
                      color: kOrangePrimaryColor,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            fontSize: 15,
                            color: kBackgroundColor,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                new SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ));
  }
}
