import 'package:flutter/material.dart';

import '../constants.dart';


class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required Key key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.056, 
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.lightBlue[900],
        onPressed: (){},
        child: Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.045, 
            color: kBackgroundColor,
          ),
        ),
      ),
    );
  }
}
