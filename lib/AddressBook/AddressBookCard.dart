
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';

class AddressBookCard extends StatefulWidget {
  var contactname, contactemail, contactnumber, selectedindex, showeditoptions;

  AddressBookCard(name, email, number, this.selectedindex, this.showeditoptions) {
    contactname = name;
    contactemail = email;
    contactnumber = number;
  }

  @override
  _AddressBookCardState createState() => _AddressBookCardState(
      contactname, contactemail, contactnumber, selectedindex, showeditoptions);
}

class _AddressBookCardState extends State<AddressBookCard> {
  var contactname, contactemail, contactnumber, selectedindex, showeditoptions;

  _AddressBookCardState(name, email, number, selectedindex, showeditoptions) {
    contactname = name;
    contactemail = email;
    contactnumber = number;
    this.selectedindex = selectedindex;
    this.showeditoptions = showeditoptions;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: widget.selectedindex == 0
          ? widget.showeditoptions == 1
              ? Color(0xFFFFFFFF).withOpacity(1)
              : Color(0xFFFFFFFF)
          : kBluePrimaryColor,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFF1F1F1),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.showeditoptions == 1
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: widget.selectedindex == 1
                                    ? kBackgroundColor.withOpacity(0.5)
                                    : kOrangePrimaryColor.withOpacity(0.5),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              widget.contactname == null
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                                  .withOpacity(0.5)
                                              : kBluePrimaryColor
                                                  .withOpacity(0.5),
                                          fontSize: 18))
                                  : Text(widget.contactname,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                                  .withOpacity(0.5)
                                              : kBluePrimaryColor
                                                  .withOpacity(0.5),
                                          fontSize: 18)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: widget.selectedindex == 1
                                    ? kBackgroundColor.withOpacity(0.5)
                                    : kOrangePrimaryColor.withOpacity(0.5),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              widget.contactemail == null
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                                  .withOpacity(0.5)
                                              : kBluePrimaryColor
                                                  .withOpacity(0.5),
                                          fontSize: 18))
                                  : Text(widget.contactemail,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: widget.selectedindex == 1
                                            ? kBackgroundColor.withOpacity(0.5)
                                            : kBluePrimaryColor
                                                .withOpacity(0.5),
                                      ))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: widget.selectedindex == 1
                                    ? kBackgroundColor.withOpacity(0.5)
                                    : kOrangePrimaryColor.withOpacity(0.5),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              widget.contactnumber == null
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                                  .withOpacity(0.5)
                                              : kBluePrimaryColor
                                                  .withOpacity(0.5),
                                          fontSize: 18))
                                  : Text(widget.contactnumber,
                                      style: TextStyle(
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                                  .withOpacity(0.5)
                                              : kBluePrimaryColor
                                                  .withOpacity(0.5),
                                          fontSize: 18))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          new Container(
                              height: MediaQuery.of(context).size.height * 0.08,
                              decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(20.0),
                                      topRight: const Radius.circular(20.0))),
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
                                            setState(() {
                                              showeditoptions = 0;
                                            });
                                          },
                                          child: Image.asset(
                                            'images/Cross.png',
                                            color: kBluePrimaryColor,
                                            height: 16,
                                            width: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Center(
                                    child: new Text(
                                      'Choose Option',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: kBluePrimaryColor),
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      color: kBluePrimaryColor,
                                      onPressed: () {
                                        print('Import Contacts');
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                            text: 'Edit',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri')),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      color: kOrangePrimaryColor,
                                      onPressed: () {
                                        print('Import Contacts');
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                            text: 'Delete',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Calibri')),
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: widget.selectedindex == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              widget.contactname == null
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 18))
                                  : Text(widget.contactname,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 18)),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: widget.selectedindex == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              widget.contactemail == null
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 18))
                                  : Text(widget.contactemail,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: widget.selectedindex == 1
                                            ? kBackgroundColor
                                            : kBluePrimaryColor,
                                      ))
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: widget.selectedindex == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              widget.contactnumber == null
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 18))
                                  : Text(widget.contactnumber,
                                      style: TextStyle(
                                          color: widget.selectedindex == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 18))
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
