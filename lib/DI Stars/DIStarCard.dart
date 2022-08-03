import 'dart:async';

import 'package:flutter/material.dart';

import '../PublicProfile/DIStarProfile.dart';
import '../constants.dart';

class DIStarCard extends StatefulWidget {
  var username;
  var profileimage;
  var questioncount;
  var activequestioncount;
  var userid;
  var header;

  DIStarCard(this.profileimage, this.username, this.questioncount,
      this.activequestioncount, this.userid, this.header);

  @override
  _DIStarCardState createState() => _DIStarCardState();
}

class _DIStarCardState extends State<DIStarCard> {
  var imageheight, imagewidth, screenheight, screenwidth;
  bool showheight = false, showwidth = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DIStarProfile(widget.userid)));
      },
      child: Card(
        color: Colors.white.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        //color: Color(0xFFFFFFFF),
        child: Container(
          //height: MediaQuery.of(context).size.height * 0.48,
          width: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFF1F1F1),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          //To provide some space on sides
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.45,
                //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFF1F1F1),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: widget.profileimage == null || widget.profileimage == ''
                    ? Image.asset(
                        'images/user.jpg',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        '$imageapiurl/' + widget.profileimage,
                        fit: BoxFit.cover,
                      ),
                //width: 45,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                //height: MediaQuery.of(context).size.width * 0.15,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.username.toString() == ''
                            ? 'Undefined'
                            : widget.username.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.13,
                      height: MediaQuery.of(context).size.width * 0.06,
                      //padding: EdgeInsets.symmetric(horizontal: 30),
                      child: RaisedButton(
                        color: widget.questioncount > 50
                            ? kOrangePrimaryColor
                            : widget.questioncount > 15
                                ? kBluePrimaryColor
                                : Colors.grey,
                        onPressed: () {
                          print('Number');
                          print(widget.questioncount);
                        },
                        child: Text(
                          widget.questioncount == null ||
                                  widget.questioncount == ''
                              ? 'Undefined'
                              : widget.questioncount.toString(),
                          style: const TextStyle(
                              color: kBackgroundColor, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.13,
                      height: MediaQuery.of(context).size.width * 0.06,
                      child: RaisedButton(
                        color: Colors.grey,
                        onPressed: () {},
                        child: Text(
                          widget.activequestioncount == null ||
                                  widget.activequestioncount == ''
                              ? 'Undefined'
                              : widget.activequestioncount.toString(),
                          style: const TextStyle(color: kBackgroundColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getuserdata() async {
    if (widget.profileimage != null) {
      Completer<Size> completer = Completer();
      Image image = Image.network('$imageapiurl/' + widget.profileimage);
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;
            Size size =
                Size(myImage.width.toDouble(), myImage.height.toDouble());
            imageheight = size.height;
            imagewidth = size.width;
            completer.complete(size);
          },
        ),
      );
    } else {
      print('Image is not there');
    }
  }
}
