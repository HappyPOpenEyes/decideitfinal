import 'package:decideitfinal/Dashboard/Dashboard.dart';
import 'package:decideitfinal/SearchTextProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home/homescreen.dart';
import 'SplashScreens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchChangeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "DecideIt",
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: email == null ? SplashScreen() : HomeScreen(),
      )));
}
