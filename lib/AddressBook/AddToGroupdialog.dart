import 'dart:convert';
import 'dart:ui';

import 'package:decideitfinal/AddressBook/AddressBook.dart';
import 'package:decideitfinal/AddressBook/AddtoGroupValid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'PostNewGroupDataAPI.dart';

class AddToGroupDialog extends StatefulWidget {
  late List<String> groupnames, groupids, addressbookid;
  var header, userid;
  late int id;

  AddToGroupDialog(this.groupnames, this.groupids, this.addressbookid,
      this.userid, this.header, this.id);
  @override
  _AddToGroupDialogState createState() => _AddToGroupDialogState(
      groupnames, groupids, addressbookid, userid, header, id);
}

class _AddToGroupDialogState extends State<AddToGroupDialog> {
  int _groupValue = 0;
  TextEditingController groupnamecontroller = TextEditingController();
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  late List<String> groupnames, groupids, addressbookid;
  var header, userid;
  int groupcounter = 0;
  bool isdropdownerror = false;
  bool isloading = false;
  late int id;

  _AddToGroupDialogState(this.groupnames, this.groupids, this.addressbookid,
      this.userid, this.header, this.id);

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isloading
        ? const Center(child: CircularProgressIndicator())
        : BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Add Contact to Group',
                    style: TextStyle(color: kBluePrimaryColor),
                  ),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      child: Row(
                        children: [
                          Radio(
                              value: 0,
                              groupValue: _groupValue,
                              onChanged: (newValue) => setState(() {
                                    _groupValue =
                                        int.parse(newValue.toString());
                                  })),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _groupValue = 0;
                                });
                              },
                              child: const Text('New')),
                          Radio(
                              value: 1,
                              groupValue: _groupValue,
                              onChanged: (newValue) => setState(() {
                                    _groupValue =
                                        int.parse(newValue.toString());
                                  })),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  _groupValue = 1;
                                });
                              },
                              child: const Text('Existing')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _groupValue == 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                  controller: groupnamecontroller,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      removeError(
                                          error: 'Please enter a group name');
                                    }
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a group name';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'Enter your group name',
                                      hintStyle: TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ))),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.height * 0.04,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    value: groupcounter == 0
                                        ? groupnames[0]
                                        : groupnames[groupcounter],
                                    items: groupnames.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    hint: const Text(
                                      "Choose existing group",
                                      style:
                                          TextStyle(color: kBluePrimaryColor),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        print(value);
                                        groupcounter = groupnames
                                            .indexOf(value.toString());
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            isdropdownerror
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      '* Please select group',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                ],
              ),
              actions: <Widget>[
                Row(
                  children: [
                    Container(
                      color: kBackgroundColor,
                      //width: double.maxFinite,
                      alignment: Alignment.center,
                      child: RaisedButton(
                        color: kBluePrimaryColor,
                        child: const Text(
                          "ADD",
                          style: TextStyle(color: kBackgroundColor),
                        ),
                        onPressed: () async {
                          print(_groupValue);
                          print(_formKey.currentState!.validate());
                          if (_groupValue == 0) {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() {
                                isloading = true;
                              });
                              List<NewDetail> detaillist = [];
                              for (int i = 0; i < addressbookid.length; i++) {
                                detaillist.add(
                                    NewDetail(addressBookId: addressbookid[i]));
                              }

                              var body = {
                                "details": detaillist,
                                "userId": userid,
                                "group_name_available": "1",
                                "group_name": groupnamecontroller.text
                              };
                              print(body);
                              // var response = await http.post(
                              //     Uri.parse(
                              //         '$apiurl/user-group/add-contact-group'),
                              //     body: json.encode(body),
                              //     headers: {
                              //       "Content-Type": "application/json",
                              //       "Authorization": header
                              //     },
                              //     encoding: Encoding.getByName("utf-8"));

                              setState(() {
                                isloading = false;
                              });

                              // if (response.statusCode == 200) {
                              //   print('Success');
                              //   AddContacttoGroupValid addContacttoGroupValid =
                              //       addContacttoGroupValidFromJson(
                              //           response.body);
                              //   SharedPreferences prefs =
                              //       await SharedPreferences.getInstance();
                              //   prefs.setString('contactadded',
                              //       addContacttoGroupValid.message);
                              //   print(response.body);
                              // } else {
                              //   print(response.statusCode);
                              //   print(response.body);
                              // }
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => AddressBook(id)));
                            }
                          } else {
                            if (groupcounter == 0) {
                              setState(() {
                                isdropdownerror = true;
                              });
                            } else {
                              List<NewDetail> detaillist = [];
                              for (int i = 0; i < addressbookid.length; i++) {
                                detaillist.add(
                                    NewDetail(addressBookId: addressbookid[i]));
                              }
                              setState(() {
                                isloading = true;
                              });

                              var body = {
                                "details": detaillist,
                                "userId": userid,
                                "group_name_available": "0",
                                "group_name_id": groupids[groupcounter]
                              };
                              print(body);

                              setState(() {
                                isloading = true;
                              });
                              var response = await http.post(
                                  Uri.parse(
                                      '$apiurl/user-group/add-contact-group'),
                                  body: json.encode(body),
                                  headers: {
                                    "Content-Type": "application/json",
                                    "Authorization": header
                                  },
                                  encoding: Encoding.getByName("utf-8"));

                              setState(() {
                                isloading = false;
                              });

                              if (response.statusCode == 200) {
                                print('Success');
                                AddContacttoGroupValid addContacttoGroupValid =
                                    addContacttoGroupValidFromJson(
                                        response.body);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('contactadded',
                                    addContacttoGroupValid.message);
                                print(response.body);
                              } else {
                                print(response.statusCode);
                                print(response.body);
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddressBook(id)));
                            }
                          }
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: kBackgroundColor),
                          ),
                        )),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                )
              ],
            ));
  }
}
