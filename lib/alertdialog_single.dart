import 'dart:ui';
import 'package:flutter/material.dart';

import 'constants.dart';

class BlurryDialogSingle extends StatelessWidget {
  String title;
  String content;

  BlurryDialogSingle(this.title, this.content);
  TextStyle textStyle = TextStyle(color: Colors.black);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  color: kBackgroundColor,
                  //width: double.maxFinite,
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: kBluePrimaryColor,
                    child: const Text(
                      "OK",
                      style: TextStyle(color: kBackgroundColor),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ));
  }
}
