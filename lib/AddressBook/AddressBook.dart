import 'dart:convert';
import 'dart:ui';

import 'package:decideitfinal/AddressBook/AddContact.dart';
import 'package:decideitfinal/AddressBook/AddContactValidAPI.dart';
import 'package:decideitfinal/AddressBook/AddressBookAPI.dart';
import 'package:decideitfinal/AddressBook/AddressBookCard.dart';
import 'package:decideitfinal/AddressBook/DeleteContactAPI.dart';
import 'package:decideitfinal/AddressBook/GoogleContactsApi.dart';
import 'package:decideitfinal/AddressBook/GroupDataAPI.dart';
import 'package:decideitfinal/ProfileScreens/ChangePassword.dart';
import 'package:decideitfinal/ProfileScreens/CommunityProfile.dart';
import 'package:decideitfinal/ProfileScreens/PersonalProfile.dart';
import 'package:decideitfinal/ProfileScreens/ProfilePlan.dart';
import 'package:decideitfinal/alertDialog.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../constants.dart';
import 'AddToGroupdialog.dart';
import 'PostGoogleContacts.dart';

class AddressBook extends StatefulWidget {
  late int id;

  AddressBook(int id) {
    this.id = id;
  }

  @override
  _AddressBookState createState() => _AddressBookState(id);
}

class _AddressBookState extends State<AddressBook> {
  late GoogleSignInAccount _currentUser;
  var name, email, imageurl, userid, header;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController controller = TextEditingController();
  TextEditingController pagecontroller = TextEditingController();
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  final _pageFormKey = GlobalKey<FormState>();
  bool _enabled = true;
  List<String> contactname = [];
  List<String> contactemail = [];
  List<String> contactphone = [];
  List<String> contactisactive = [];
  List<String> tempcontactname = [];
  List<String> tempcontactemail = [];
  List<String> tempcontactphone = [];
  List<String> tempcontactisactive = [];
  List<String> tempcontactaddressbookid = [];
  List<String> contactaddressbookid = [];
  List<String> _searchResult = [];
  final List<String> _searchcontactname = [];
  final List<String> _searchcontactemail = [];
  final List<String> _searchcontactphone = [];
  final List<String> _searchcontactisactive = [];
  final List<String> _searchcontactaddressbookid = [];
  List<String> searchlist = [];
  List<String> groupnames = ["Choose existing group"];
  List<String> groupids = ["Demo"];
  TextEditingController groupnamecontroller = TextEditingController();
  List<int> selectedindex = [];
  final List<int> _searchselectedindex = [];
  List<int> showeditoptions = [];
  final List<int> _searchshoweditoptions = [];
  late GoogleSignIn _googleSignIn;
  List<String> googlephonenumbers = [];
  List<String> googlefullname = [];
  List<String> googlefirstname = [];
  List<String> googlelastname = [];
  List<String> googleemails = [];
  late int id, totalListCount;
  int offset = 0;
  AppBar appbar = AppBar();
  bool oneAlreadySelected = false;
  String searchQuery = "";
  _AddressBookState(this.id);

  Future getUserContacts(int status) async {
    const host = "https://people.googleapis.com";
    const endpoint =
        "/v1/people/me/connections?personFields=names,emailAddresses,phoneNumbers";
    final contactheader = await _currentUser.authHeaders;
    print(contactheader);
    var response =
        await http.get(Uri.parse("$host$endpoint"), headers: contactheader);

    if (response.statusCode == 200) {
      googleemails.clear();
      googlefirstname.clear();
      googlefullname.clear();
      googlelastname.clear();
      googlephonenumbers.clear();
      print('Contacts Got');
      print(response.body);
      GoogleContacts googleContacts = googleContactsFromJson(response.body);
      List<Connection> connections = googleContacts.connections;
      List<Name> names;
      print('Connectiosn length:');
      print(connections.length);
      for (int i = 0; i < connections.length; i++) {
        List<EmailAddress>? phoneNumbers = connections[i].phoneNumbers;
        List<EmailAddress>? emailAddresses = connections[i].emailAddresses;
        names = connections[i].names!;
        if (connections[22].names == null) {
          print('In here');
        }
        if (connections[i].phoneNumbers == null) {
          googlephonenumbers.add("");
        } else {
          googlephonenumbers.add(phoneNumbers![0].value);
        }
        if (connections[i].names == null) {
          googlefullname.add("");
        } else {
          googlefullname.add(names[0].displayNameLastFirst);
        }

        if (connections[i].emailAddresses == null) {
          googleemails.add("");
        } else {
          googleemails.add(emailAddresses![0].value);
        }
      }
      // print('Lengths');
      // print(googleemails.length);
      // print('Full name');
      // print(googlefullname.length);
      // print('Phone numbers: ');
      // print(googlephonenumbers.length);
      // print(names.length);
      // print(names);

      for (int i = 0; i < googlefullname.length; i++) {
        if (connections[i].names == null) {
          googlelastname.add("");
        } else {
          print(i);
          if (connections[i].names![0].familyName == null) {
            googlelastname.add("");
          } else {
            googlelastname.add(connections[i].names![0].familyName ?? '');
          }
        }
      }

      for (int i = 0; i < googlefullname.length; i++) {
        if (connections[i].names == null) {
          googlefirstname.add("");
        } else {
          if (connections[i].names![0].givenName == null) {
            googlefirstname.add("");
          } else {
            googlefirstname.add(connections[i].names![0].givenName);
          }
        }

        /*if (googlefullname[i] == null) {
          googlefirstname.add(null);
          googlelastname.add(null);
        } else {
          final split = googlefullname[i].split(',');
          final Map<int, String> values = {
            for (int j = 0; j < split.length; j++) j: split[j]
          };
          if (values.length != 2) {
            googlefirstname.add(values[0]);
            googlelastname.add(null);
          }
          for (int k = 0; k < values.length; k++) {
            String trimmedvalue = values[k].trim();
            if (k == 0) {
              googlelastname.add(trimmedvalue);
            } else {
              googlefirstname.add(trimmedvalue);
            }
          }
        }*/
      }

      print(googlefirstname.length);
      print(googlelastname.length);
      List<ImportContact> importContact = [];
      for (int i = 0; i < googleemails.length; i++) {
        importContact.add(ImportContact(
            contactEmail: googleemails[i],
            contactFirstName: googlefirstname[i],
            contactLastName: googlelastname[i],
            contactPhone: googlephonenumbers[i]));
      }
      var body = {
        "UserId": userid,
        "status": status,
        "importContact": importContact
      };

      setState(() {
        _enabled = true;
        Navigator.of(context).pop();
      });
      var postreponse = await http.post(
          Uri.parse('$apiurl/user-address-book/add-importcontact'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Authorization": header
          },
          encoding: Encoding.getByName("utf-8"));

      if (postreponse.statusCode == 200) {
        print(postreponse.body);
        AddContactValidApi addContactValidApi =
            addContactValidApiFromJson(postreponse.body);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(addContactValidApi.message)));

        cleardata();
        getuserdetails();
      } else {
        print(postreponse.statusCode);
        print(postreponse.body);
      }

      print(googleemails);
      print(googlefullname);
      print(googlephonenumbers);
    } else {
      print('Contacts Not Got');
      print(response.statusCode);
      print(response.body);
    }
  }

  @override
  void initState() {
    super.initState();
    // Transparent status bar
    _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'profile',
        'https://www.googleapis.com/auth/contacts.readonly'
      ],
    );
    pagecontroller.text = "1";
    getuserdetails();
  }

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
            height: appbar.preferredSize.height * 0.8,
            child: Image.asset('logos/DI_Logo.png')),
        centerTitle: true,
        backgroundColor: kBluePrimaryColor,
        leading: GestureDetector(
            onTap: () {
              print(id);
              if (id == 1) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => PersonalProfile()));
              } else if (id == 2) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ProfilePlan()));
              } else if (id == 3) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              } else if (id == 4) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => CommunityProfile()));
              }
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Address ',
                  style: TextStyle(
                      color: kBluePrimaryColor,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Book',
                        style: TextStyle(
                            color: kOrangePrimaryColor,
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextFormField(
                      controller: controller,
                      textInputAction: TextInputAction.go,
                      decoration: const InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      //onChanged: onSearchTextChanged,
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          _enabled = true;
                          cleardata();
                          searchQuery = value;
                          offset = 0;
                          pagecontroller.text = "1";
                          getaddressbookdata();
                          //onSearchTextChanged(value);
                          // if all are valid then go to success screen
                        }
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(
                              error: 'Please enter your search keyword');
                        }
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your search keyword';
                          //addError(error: kPassNullError);
                          return "";
                        }
                        return null;
                      },
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        controller.clear();
                        _enabled = true;
                        searchQuery = "";
                        clearsearchdata();
                        cleardata();
                        getuserdetails();
                        //onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 5.0,
                children: [
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: kBluePrimaryColor,
                      onPressed: () {
                        print('Import Contacts');
                        showgoogledialog();
                        //initiateGoogleLogin();
                      },
                      child: RichText(
                        text: const TextSpan(
                            text: 'IMPORT CONTACTS',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Calibri')),
                      )),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: kBluePrimaryColor,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                AddContact('', '', '', '', '', 0, id)));
                      },
                      child: RichText(
                        text: const TextSpan(
                            text: 'ADD CONTACT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Calibri')),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: kBluePrimaryColor,
                        onPressed: () {
                          addcontacttogroup();
                        },
                        child: RichText(
                          text: const TextSpan(
                              text: 'ADD CONTACT TO GROUP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Calibri')),
                        )),
                  ),
                ],
              ),
            ),
            _enabled
                ? Shimmer.fromColors(
                    baseColor: Colors.black12,
                    highlightColor: Colors.white10,
                    enabled: _enabled,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                AddressBookCard('', '', '', '', ''),
                                const SizedBox(
                                  height: 5,
                                )
                              ],
                            );
                          }),
                    ))
                : contactemail.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: kBackgroundColor,
                            child: Column(
                              children: [
                                Image.asset(
                                  'images/no_found.png',
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'No Contacts Found For Your Selection',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: kBluePrimaryColor),
                                ),
                                const SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contactemail.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      if (selectedindex[index] == 0) {
                                        selectedindex[index] = 1;
                                      }
                                    });
                                  },
                                  onTap: () {
                                    setState(() {
                                      if (!oneAlreadySelected) {
                                        if (selectedindex[index] == 1) {
                                          selectedindex[index] = 0;
                                        } else if (selectedindex.contains(1)) {
                                          selectedindex[index] = 1;
                                        } else {
                                          showeditoptions[index] = 1;
                                          oneAlreadySelected = true;
                                        }
                                      }
                                    });
                                  },
                                  child: showaddresscard(
                                      contactname[index],
                                      contactemail[index],
                                      contactphone[index],
                                      index)),
                              const SizedBox(
                                height: 5,
                              )
                            ],
                          );
                        },
                      ),
            // : _searchResult.isEmpty
            //     ? Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Card(
            //             shape: const RoundedRectangleBorder(
            //                 borderRadius:
            //                     BorderRadius.all(Radius.circular(20))),
            //             color: kBackgroundColor,
            //             child: Column(
            //               children: [
            //                 Image.asset(
            //                   'images/no_found.png',
            //                   fit: BoxFit.cover,
            //                 ),
            //                 const SizedBox(
            //                   height: 10,
            //                 ),
            //                 const Text(
            //                   'No Contacts Found For Your Selection',
            //                   style: TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                       fontSize: 18,
            //                       color: kBluePrimaryColor),
            //                 ),
            //                 const SizedBox(
            //                   height: 15,
            //                 )
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //     : ListView.builder(
            //         scrollDirection: Axis.vertical,
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: _searchcontactemail.length,
            //         itemBuilder: (context, index) {
            //           return Column(
            //             children: [
            //               GestureDetector(
            //                 onLongPress: () {
            //                   setState(() {
            //                     if (_searchselectedindex[index] == 0) {
            //                       _searchselectedindex[index] = 1;
            //                     }
            //                   });
            //                 },
            //                 onTap: () {
            //                   setState(() {
            //                     if (_searchselectedindex[index] == 1) {
            //                       _searchselectedindex[index] = 0;
            //                     } else if (_searchselectedindex
            //                         .contains(1)) {
            //                       _searchselectedindex[index] = 1;
            //                     } else {
            //                       _searchshoweditoptions[index] = 1;
            //                     }
            //                   });
            //                 },
            //                 child: showsearchaddresscard(
            //                     _searchcontactname[index],
            //                     _searchcontactemail[index],
            //                     _searchcontactphone[index],
            //                     index),
            //               ),
            //               const SizedBox(
            //                 height: 5,
            //               )
            //             ],
            //           );
            //         },
            //       ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () {
                        if (offset != 0) {
                          setState(() {
                            _enabled = true;
                            offset--;
                            pagecontroller.text = (offset + 1).toString();
                            cleardata();
                            getaddressbookdata();
                          });
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: kBluePrimaryColor,
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Form(
                        key: _pageFormKey,
                        child: TextFormField(
                          controller: pagecontroller,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textInputAction: TextInputAction.go,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                          onFieldSubmitted: (value) {
                            if (value.isNotEmpty &&
                                int.parse(value) < totalListCount) {
                              setState(() {
                                _enabled = true;
                                offset = int.parse(value) - 1;
                                cleardata();
                                getaddressbookdata();
                              });
                            } else {
                              pagecontroller.text = (offset + 1).toString();
                              BlurryDialogSingle alert = BlurryDialogSingle(
                                  'Error',
                                  'Your contact list has only $totalListCount pages');

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  var height =
                                      MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;
                                  return alert;
                                },
                              );
                            }
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty &&
                                int.parse(value) < totalListCount) {
                              removeError(
                                  error:
                                      'Your contact list has only $totalListCount pages');
                            }
                          },
                          validator: (value) {
                            if (value!.isEmpty &&
                                int.parse(value) > totalListCount) {
                              return 'Your contact list has only $totalListCount pages';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          _enabled = true;
                          offset++;
                          pagecontroller.text = (offset + 1).toString();
                          cleardata();
                          getaddressbookdata();
                        });
                      },
                      child: const Icon(Icons.arrow_forward_ios,
                          color: kBluePrimaryColor)),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  // onSearchTextChanged(String text) async {
  //   if (text.isEmpty) {
  //     setState(() {});
  //     return;
  //   } else {
  //     setState(() {
  //       clearsearchdata();
  //       _searchResult = searchlist
  //           .where(
  //               (string) => string.toLowerCase().contains(text.toLowerCase()))
  //           .toList();
  //       print(_searchResult);
  //       for (int i = 0; i < _searchResult.length; i++) {
  //         for (int j = 0; j < tempcontactemail.length; j++) {
  //           if (_searchResult[i] == tempcontactname[j] ||
  //               _searchResult[i] == tempcontactemail[j] ||
  //               _searchResult[i] == tempcontactphone[j]) {
  //             _searchcontactemail.add(tempcontactemail[j]);
  //             _searchcontactname.add(tempcontactname[j]);
  //             _searchcontactphone.add(tempcontactphone[j]);
  //             _searchcontactisactive.add(tempcontactisactive[j]);
  //             _searchcontactaddressbookid.add(tempcontactaddressbookid[j]);
  //             _searchselectedindex.add(0);
  //             _searchshoweditoptions.add(0);
  //             removetempdata(j);
  //           }
  //         }
  //       }
  //       print(_searchcontactemail.length);
  //       print(_searchcontactname);
  //       cleardata();
  //       getuserdetails();
  //     });
  //   }
  // }

  void getuserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');
    var sharedcontactdata = prefs.getString('contactadded');

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
      if (sharedcontactdata != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(sharedcontactdata)));
        prefs.remove('contactadded');
      }
      getaddressbookdata();
    });
  }

  void getaddressbookdata() async {
    var useridarray = [];
    useridarray.add(userid);
    if (contactemail.isEmpty) {
      var body = {
        "limit": 15,
        "offset": offset,
        "searchData": {"status": "", "searchQuery": searchQuery},
        "sortOrder": [
          {"field": "id", "dir": "asc"}
        ],
        "user_id": useridarray
      };

      print(body);

      var response = await http.post(
          Uri.parse('$apiurl/user-address-book/get-all'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Authorization": header
          },
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        print(response.body);
        AddressBookApi addressBookApi = addressBookApiFromJson(response.body);
        List<Datums> datum = addressBookApi.data;
        setState(() {
          totalListCount = ((addressBookApi.count) ~/ 15) + 1;

          for (int i = 0; i < datum.length; i++) {
            contactemail.add(datum[i].contactEmail ?? '');
            if (datum[i].contactFirstName == null &&
                datum[i].contactLastName == null) {
              contactname.add("");
            } else {
              contactname.add(
                  datum[i].contactFirstName + ' ' + datum[i].contactLastName);
              searchlist.add(
                  datum[i].contactFirstName + ' ' + datum[i].contactLastName);
            }
            contactisactive.add(datum[i].isActive.toString());
            contactphone.add(datum[i].contactPhone ?? '');
            contactaddressbookid.add(datum[i].id);
            if (datum[i].contactEmail != null) {
              searchlist.add(datum[i].contactEmail ?? '');
            }
            if (datum[i].contactPhone != null) {
              searchlist.add(datum[i].contactPhone ?? '');
            }
          }

          for (int i = 0; i < contactname.length; i++) {
            tempcontactemail.add(contactemail[i]);
            tempcontactname.add(contactname[i]);
            tempcontactphone.add(contactphone[i]);
            tempcontactisactive.add(contactisactive[i]);
            tempcontactaddressbookid.add(contactaddressbookid[i]);
            selectedindex.add(0);
            showeditoptions.add(0);
          }
          _enabled = false;
        });
      } else {
        print(response.statusCode);
        print(response.body);
      }

      var groupresponse = await http.post(
          Uri.parse('$apiurl/user-group-name/get-group'),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Authorization": header
          },
          encoding: Encoding.getByName("utf-8"));

      if (groupresponse.statusCode == 200) {
        print(groupresponse.body);
        GroupDataApi groupDataApi = groupDataApiFromJson(groupresponse.body);
        List<DatumGroup> data = groupDataApi.data;
        for (int i = 0; i < data.length; i++) {
          groupids.add(data[i].id);
          groupnames.add(data[i].name);
        }
      } else {
        print(groupresponse.statusCode);
        print(groupresponse.body);
      }
    }
  }

  void cleardata() {
    contactname = [];
    contactemail = [];
    contactphone = [];
    contactisactive = [];
    contactaddressbookid = [];
    tempcontactemail.clear();
    tempcontactname.clear();
    tempcontactphone.clear();
    tempcontactisactive.clear();
    tempcontactaddressbookid.clear();
  }

  void removetempdata(int j) {
    tempcontactname.removeAt(j);
    tempcontactemail.removeAt(j);
    tempcontactphone.removeAt(j);
    tempcontactisactive.removeAt(j);
    tempcontactaddressbookid.removeAt(j);
  }

  void clearsearchdata() {
    _searchcontactemail.clear();
    _searchcontactname.clear();
    _searchcontactphone.clear();
    _searchcontactisactive.clear();
    _searchcontactaddressbookid.clear();
    _searchselectedindex.clear();
    _searchshoweditoptions.clear();
  }

  Future<void> addcontacttogroup() async {
    int flagcounter = 0;
    List<String> tempaddressbookid = [];
    if (selectedindex.contains(1)) {
      flagcounter = 1;
    }

    if (flagcounter == 1) {
      for (int i = 0; i < selectedindex.length; i++) {
        if (selectedindex[i] == 1) {
          tempaddressbookid.add(contactaddressbookid[i]);
        }
      }
      AddToGroupDialog alert = AddToGroupDialog(
          groupnames, groupids, tempaddressbookid, userid, header, id);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sharedcontactdata = prefs.getString('contactadded');
      if (sharedcontactdata != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(sharedcontactdata)));
        prefs.remove('contactadded');
      }
    } else {
      print('Select contact to add to group');
      BlurryDialog alert = BlurryDialog(
          'Error', 'Please select one or more contacts to create a group.');
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

  showaddresscard(String conname, String conemail, String conphone, int index) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: selectedindex[index] == 0
          ? showeditoptions[index] == 1
              ? const Color(0xFFFFFFFF).withOpacity(1)
              : const Color(0xFFFFFFFF)
          : kBluePrimaryColor,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFF1F1F1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: showeditoptions[index] == 1
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: selectedindex[index] == 1
                                      ? kBackgroundColor.withOpacity(0.5)
                                      : kOrangePrimaryColor.withOpacity(0.5),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                conname.isEmpty
                                    ? Text('-',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedindex[index] == 1
                                                ? kBackgroundColor
                                                    .withOpacity(0.5)
                                                : kBluePrimaryColor
                                                    .withOpacity(0.5),
                                            fontSize: 18))
                                    : Text(conname,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedindex[index] == 1
                                                ? kBackgroundColor
                                                    .withOpacity(0.5)
                                                : kBluePrimaryColor
                                                    .withOpacity(0.5),
                                            fontSize: 16)),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  color: selectedindex[index] == 1
                                      ? kBackgroundColor.withOpacity(0.5)
                                      : kOrangePrimaryColor.withOpacity(0.5),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                conemail.isEmpty
                                    ? Text('-',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedindex[index] == 1
                                                ? kBackgroundColor
                                                    .withOpacity(0.5)
                                                : kBluePrimaryColor
                                                    .withOpacity(0.5),
                                            fontSize: 18))
                                    : Text(conemail,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectedindex[index] == 1
                                              ? kBackgroundColor
                                                  .withOpacity(0.5)
                                              : kBluePrimaryColor
                                                  .withOpacity(0.5),
                                        )),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: selectedindex[index] == 1
                                      ? kBackgroundColor.withOpacity(0.5)
                                      : kOrangePrimaryColor.withOpacity(0.5),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                conphone.isEmpty
                                    ? Text('-',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selectedindex[index] == 1
                                                ? kBackgroundColor
                                                    .withOpacity(0.5)
                                                : kBluePrimaryColor
                                                    .withOpacity(0.5),
                                            fontSize: 18))
                                    : Text(conphone,
                                        style: TextStyle(
                                            color: selectedindex[index] == 1
                                                ? kBackgroundColor
                                                    .withOpacity(0.5)
                                                : kBluePrimaryColor
                                                    .withOpacity(0.5),
                                            fontSize: 16))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showeditoptions[index] = 0;
                                        oneAlreadySelected = false;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.1,
                                            child: Image.asset(
                                              'images/Cross.png',
                                              color: kBluePrimaryColor,
                                              height: 16,
                                              width: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                const Center(
                                  child: Text(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: kBluePrimaryColor,
                                  onPressed: () {
                                    if (controller.text.isEmpty) {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => AddContact(
                                                  conname,
                                                  conemail,
                                                  conphone,
                                                  contactisactive[index],
                                                  contactaddressbookid[index],
                                                  1,
                                                  id)));
                                    } else {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) => AddContact(
                                                  conname,
                                                  conemail,
                                                  conphone,
                                                  _searchcontactisactive[index],
                                                  _searchcontactaddressbookid[
                                                      index],
                                                  1,
                                                  id)));
                                    }
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                        text: 'Edit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Calibri')),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: kOrangePrimaryColor,
                                  onPressed: () async {
                                    String id = "";
                                    if (controller.text.isEmpty) {
                                      id = contactaddressbookid[index];
                                    } else {
                                      id = _searchcontactaddressbookid[index];
                                    }
                                    setState(() {
                                      _enabled = true;
                                      showeditoptions[index] = 0;
                                    });
                                    var response = await http.get(
                                      Uri.parse(
                                          '$apiurl/user-address-book/delete/$id'),
                                      headers: {
                                        "Content-Type": "application/json",
                                        "Authorization": header
                                      },
                                    );
                                    if (response.statusCode == 200) {
                                      DeleteContactAPI addContactValidApi =
                                          deleteContactAPIFromJson(
                                              response.body);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  addContactValidApi.message)));
                                      print(response.body);
                                      setState(() {
                                        cleardata();
                                        getuserdetails();
                                      });
                                    } else {
                                      print(response.statusCode);
                                      print(response.body);
                                    }
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                        text: 'Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Calibri')),
                                  )),
                            ],
                          ),
                        )
                      ],
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
                                color: selectedindex[index] == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              conname.isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedindex[index] == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 18))
                                  : Text(conname,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedindex[index] == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 16)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: selectedindex[index] == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              conemail.isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedindex[index] == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 18))
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.75,
                                      child: Text(conemail,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: selectedindex[index] == 1
                                                ? kBackgroundColor
                                                : kBluePrimaryColor,
                                          )),
                                    )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: selectedindex[index] == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              conphone.isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: selectedindex[index] == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 18))
                                  : Text(conphone,
                                      style: TextStyle(
                                          color: selectedindex[index] == 1
                                              ? kBackgroundColor
                                              : kBluePrimaryColor,
                                          fontSize: 16))
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

  showsearchaddresscard(
      String conname, String conemail, String conphone, int index) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: _searchselectedindex[index] == 0
          ? _searchshoweditoptions[index] == 1
              ? const Color(0xFFFFFFFF).withOpacity(1)
              : const Color(0xFFFFFFFF)
          : kBluePrimaryColor,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFF1F1F1),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _searchshoweditoptions[index] == 1
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
                                color: _searchselectedindex[index] == 1
                                    ? kBackgroundColor.withOpacity(0.5)
                                    : kOrangePrimaryColor.withOpacity(0.5),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              contactname[index].isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _searchselectedindex[index] == 1
                                                  ? kBackgroundColor
                                                      .withOpacity(0.5)
                                                  : kBluePrimaryColor
                                                      .withOpacity(0.5),
                                          fontSize: 18))
                                  : Text(conname,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _searchselectedindex[index] == 1
                                                  ? kBackgroundColor
                                                      .withOpacity(0.5)
                                                  : kBluePrimaryColor
                                                      .withOpacity(0.5),
                                          fontSize: 18)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: _searchselectedindex[index] == 1
                                    ? kBackgroundColor.withOpacity(0.5)
                                    : kOrangePrimaryColor.withOpacity(0.5),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              conemail.isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _searchselectedindex[index] == 1
                                                  ? kBackgroundColor
                                                      .withOpacity(0.5)
                                                  : kBluePrimaryColor
                                                      .withOpacity(0.5),
                                          fontSize: 18))
                                  : Text(conemail,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _searchselectedindex[index] == 1
                                            ? kBackgroundColor.withOpacity(0.5)
                                            : kBluePrimaryColor
                                                .withOpacity(0.5),
                                      ))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: _searchselectedindex[index] == 1
                                    ? kBackgroundColor.withOpacity(0.5)
                                    : kOrangePrimaryColor.withOpacity(0.5),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              conphone.isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _searchselectedindex[index] == 1
                                                  ? kBackgroundColor
                                                      .withOpacity(0.5)
                                                  : kBluePrimaryColor
                                                      .withOpacity(0.5),
                                          fontSize: 18))
                                  : Text(conphone,
                                      style: TextStyle(
                                          color:
                                              _searchselectedindex[index] == 1
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
                    Column(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0))),
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
                                            _searchshoweditoptions[index] = 0;
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
                                const Center(
                                  child: Text(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: kBluePrimaryColor,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => AddContact(
                                                conname,
                                                conemail,
                                                conphone,
                                                _searchcontactisactive[index],
                                                _searchcontactaddressbookid[
                                                    index],
                                                1,
                                                id)));
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                        text: 'Edit',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Calibri')),
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: kOrangePrimaryColor,
                                  onPressed: () async {
                                    setState(() {
                                      _enabled = true;
                                      showeditoptions[index] = 0;
                                    });
                                    var response = await http.get(
                                      Uri.parse(
                                          '$apiurl/user-address-book/delete/${_searchcontactaddressbookid[index]}'),
                                      headers: {
                                        "Content-Type": "application/json",
                                        "Authorization": header
                                      },
                                    );
                                    if (response.statusCode == 200) {
                                      DeleteContactAPI addContactValidApi =
                                          deleteContactAPIFromJson(
                                              response.body);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  addContactValidApi.message)));
                                      print(response.body);
                                      setState(() {
                                        cleardata();
                                        getuserdetails();
                                      });
                                    } else {
                                      print(response.statusCode);
                                      print(response.body);
                                    }
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                        text: 'Delete',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Calibri')),
                                  )),
                            ],
                          ),
                        )
                      ],
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
                                color: _searchselectedindex[index] == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              conname.isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _searchselectedindex[index] == 1
                                                  ? kBackgroundColor
                                                  : kBluePrimaryColor,
                                          fontSize: 18))
                                  : Text(conname,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _searchselectedindex[index] == 1
                                                  ? kBackgroundColor
                                                  : kBluePrimaryColor,
                                          fontSize: 18)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: _searchselectedindex[index] == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              conemail.isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _searchselectedindex[index] == 1
                                                  ? kBackgroundColor
                                                  : kBluePrimaryColor,
                                          fontSize: 18))
                                  : Text(conemail,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: _searchselectedindex[index] == 1
                                            ? kBackgroundColor
                                            : kBluePrimaryColor,
                                      ))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: _searchselectedindex[index] == 1
                                    ? kBackgroundColor
                                    : kOrangePrimaryColor,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              conphone.isEmpty
                                  ? Text('-',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _searchselectedindex[index] == 1
                                                  ? kBackgroundColor
                                                  : kBluePrimaryColor,
                                          fontSize: 18))
                                  : Text(conphone,
                                      style: TextStyle(
                                          color:
                                              _searchselectedindex[index] == 1
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

  Future<void> initiateGoogleLogin(int status) async {
    try {
      _currentUser = (await _googleSignIn.signIn())!;
      print(_currentUser);
      name = _currentUser.displayName;
      email = _currentUser.email;
      print(_currentUser);
      if (_currentUser != null) {
        getUserContacts(status);
      }
    } catch (error) {
      print(error);
    }
  }

  void showgoogledialog() {
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Stack(
          children: [
            AlertDialog(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                title: Container(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Import Contacts From',
                        style: TextStyle(color: kBluePrimaryColor),
                      ),
                    ),
                  ),
                ),
                content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: FlatButton(
                            onPressed: showconfirmationdialog,
                            padding: const EdgeInsets.all(0.0),
                            child: Image.asset('logos/Google_AddressBook.png',
                                fit: BoxFit.fill)))
                    /*RaisedButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      onPressed: () {
                        print('Google');
                        showconfirmationdialog();
                        //Navigator.of(context).pop();
                      },
                      icon: Image.asset(
                        'logos/google.png',
                        height: 30,
                      ),
                      label: Text(
                        'Google',
                        style: TextStyle(fontSize: 18),
                      )),*/
                    )),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
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
            ),
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

  void showconfirmationdialog() {
    print('In show confirmation');
    var alert = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            title: Container(
              child: const Icon(Icons.error),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                    'You have chosen to import contacts from Google. If any of the contacts imported form Google already exists in your address book, what do you want to do?'),
                const SizedBox(
                  height: 5,
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: kBluePrimaryColor,
                    onPressed: () {
                      initiateGoogleLogin(1);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: const TextSpan(
                            text: 'REPLACE ADDRESS BOOK CONTACT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Calibri')),
                      ),
                    )),
                const SizedBox(
                  height: 5,
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: kBluePrimaryColor,
                    onPressed: () {
                      initiateGoogleLogin(0);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: const TextSpan(
                            text: 'ADD DUPLICATE ADDRESS BOOK CONTACT',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Calibri')),
                      ),
                    )),
              ],
            )));

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
