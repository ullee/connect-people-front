import 'package:flutter/material.dart';
import 'package:connect_people/routes.dart';
// import 'package:connect_people/screens/splash/splash_screen.dart';
import 'package:connect_people/screens/home/home_screen.dart';
import 'package:connect_people/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Connect People',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: HomeScreen.routeName,
      routes: routes,
    );
  }
}
