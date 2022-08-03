import 'package:flutter/material.dart';

class CustomAppBarProfile extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  _CustomAppBarProfileState createState() => _CustomAppBarProfileState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _CustomAppBarProfileState extends State<CustomAppBarProfile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          height: MediaQuery.of(context).size.height * 0.23,
          top: 0,
          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Container(
              color: Color(0xff002060),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: new Container(
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        padding: new EdgeInsets.all(7.0),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: Center(
                        child: Image.asset('logos/DI_Logo.png'),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.16,
          left: MediaQuery.of(context).size.width * 0.03,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.height * 0.14,
                height: MediaQuery.of(context).size.height * 0.14,
                decoration:
                    ShapeDecoration(shape: CircleBorder(), color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/a/a0/Bill_Gates_2018.jpg',
                            ))),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: Text(
                      'Bill Gates',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.24,
          left: MediaQuery.of(context).size.height * 0.165,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.08,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              'Bill Gates welcomes you. Welcome to Microsoft. It gives me immense pleasure to announce Ankit Mehta as it\'s new CEO.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
