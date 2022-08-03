import 'package:decideitfinal/PostQuestion/PostQuestion.dart';
import 'package:flutter/material.dart';

class SearchChangeProvider extends ChangeNotifier {
  List<Categories> searchList = [];
  String searchKeyword = "", noData = "No Data Found";
  bool noDataFound = false, isCleared = false;

  void changeSearchText() {
    
    notifyListeners();
  }
}
