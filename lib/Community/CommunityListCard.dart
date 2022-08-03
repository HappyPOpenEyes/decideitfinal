import 'package:flutter/material.dart';

class CommunityListCard extends StatelessWidget {
  var CategoryName;
  var categoryicon;

  CommunityListCard(icon, name) {
    this.categoryicon = icon;
    this.CategoryName = name;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      color: Color(0xFFFFFFFF),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xFFF1F1F1),
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10), //To provide some space on sides
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start, //The change
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0xFFF1F1F1),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Image.network(
                      'https://api.decideit.devbyopeneyes.com/public/community-image/' +
                          categoryicon,
                      height: 25,
                      width: 25,
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.06,
              ),
              Text(
                CategoryName,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                width: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
