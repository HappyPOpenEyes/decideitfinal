import 'package:decideitfinal/DropdownBloc.dart';
import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:decideitfinal/SearchController.dart';
import 'package:decideitfinal/SearchTextProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrodpownContainer extends StatefulWidget {
  String title, searchHint;
  IndosNoBloc showDropDownBloc;
  List<Categories> originalList;
  bool showSearch = true;

  void onClear() {}

  DrodpownContainer(
      {Key? key,
      required this.title,
      required this.searchHint,
      required this.showDropDownBloc,
      required this.originalList,
      this.showSearch = true})
      : super(key: key);

  @override
  State<DrodpownContainer> createState() => _DrodpownContainerState();
}

class _DrodpownContainerState extends State<DrodpownContainer> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    searchController.text =
        Provider.of<SearchChangeProvider>(context, listen: false).searchKeyword;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 45,
          minWidth: double.infinity,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Text(
                      widget.title,
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      setState(() {
                        print('tap');
                        clearSearch();
                        if (widget.showDropDownBloc.isedited) {
                          widget.showDropDownBloc.eventIndosNoSink
                              .add(IndosNoAction.False);
                        } else {
                          widget.showDropDownBloc.eventIndosNoSink
                              .add(IndosNoAction.True);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(widget.showDropDownBloc.isedited
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down),
                    )),
              ],
            ),
            widget.showSearch
                ? widget.showDropDownBloc.isedited
                    ? SearchController(
                        hintText: widget.searchHint,
                        searchController: searchController,
                        originalList: widget.originalList,
                        showDropDownBloc: widget.showDropDownBloc,
                      )
                    : Container()
                : Container(),
          ],
        ));
  }

  clearSearch() {
    searchController.clear();
    Provider.of<SearchChangeProvider>(context, listen: false).searchKeyword =
        "";
    Provider.of<SearchChangeProvider>(context, listen: false).searchList = [];
    Provider.of<SearchChangeProvider>(context, listen: false).noDataFound =
        false;
  }
}
