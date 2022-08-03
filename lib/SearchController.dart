// ignore_for_file: must_be_immutable, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DropdownBloc.dart';
import 'SearchTextProvider.dart';

class SearchController extends StatelessWidget {
  String hintText;
  TextEditingController searchController = TextEditingController();
  final List<Categories> _searchResult = [];
  List<Categories> originalList = [];
  IndosNoBloc showDropDownBloc;
  SearchController(
      {Key? key,
      required this.hintText,
      required this.searchController,
      required this.originalList,
      required this.showDropDownBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      controller: searchController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          hintText: hintText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)))),
      onChanged: (value) {
        print(value);
        onSearchTextChanged(value, context);
      },
    );
  }

  onSearchTextChanged(String text, BuildContext context) async {
    List<String> newList =
        originalList.map((list) => list.name!.toLowerCase()).toList();
    _searchResult.clear();

    print(newList);

    for (var userDetail in newList) {
      if (userDetail.contains(text.toLowerCase())) {
        userDetail = userDetail[0].toUpperCase() + userDetail.substring(1);
        _searchResult.add(Categories(name: userDetail, type: ""));
      }
    }

    Provider.of<SearchChangeProvider>(context, listen: false).searchList =
        _searchResult;

    if (text.isNotEmpty && _searchResult.isEmpty) {
      Provider.of<SearchChangeProvider>(context, listen: false).noDataFound =
          true;
    } else if (text.isEmpty) {
      Provider.of<SearchChangeProvider>(context, listen: false).searchList =
          originalList;
      Provider.of<SearchChangeProvider>(context, listen: false).noDataFound =
          false;
    } else {
      Provider.of<SearchChangeProvider>(context, listen: false).noDataFound =
          false;
    }
    print(Provider.of<SearchChangeProvider>(context, listen: false).searchList);
    Provider.of<SearchChangeProvider>(context, listen: false).searchKeyword =
        text;

    showDropDownBloc.eventIndosNoSink.add(IndosNoAction.False);
    showDropDownBloc.eventIndosNoSink.add(IndosNoAction.True);
  }
}
