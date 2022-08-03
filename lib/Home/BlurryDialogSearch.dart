import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants.dart';

class BlurryDialogSearch extends StatelessWidget {
  String title;
  TextEditingController searchcontroller =  TextEditingController();

  BlurryDialogSearch(this.title);
  TextStyle textStyle =const  TextStyle(color: Colors.black);

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
          content: TextField(
            controller: searchcontroller,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Enter a search term'),
            style: textStyle,
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
}
