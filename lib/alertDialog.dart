import 'dart:ui';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';

class BlurryDialog extends StatelessWidget {
  String title;
  String content;

  BlurryDialog(this.title, this.content);
  TextStyle textStyle = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title:  Text(
            title,
            style: textStyle,
          ),
          content:  Text(
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
                    child: const Text("OK"),
                    onPressed: () {
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
                    child: const Text("Cancel"),
                    onPressed: () {
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
  }
}
