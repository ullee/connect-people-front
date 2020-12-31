import 'package:flutter/widgets.dart';
import 'package:connect_people/screens/complete_profile/complete_profile_screen.dart';
import 'package:connect_people/screens/forgot_password/forgot_password_screen.dart';
import 'package:connect_people/screens/home/home_screen.dart';
import 'package:connect_people/screens/login_success/login_success_screen.dart';
import 'package:connect_people/screens/profile/profile_screen.dart';
import 'package:connect_people/screens/sign_in/sign_in_screen.dart';
import 'package:connect_people/screens/splash/splash_screen.dart';
import 'package:connect_people/screens/write_board/write_board_screen.dart';
import 'package:connect_people/screens/board_detail/board_detail_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
  WriteBoardScreen.routeName: (context) => WriteBoardScreen(),
  BoardDetailScreen.routeName: (context) => BoardDetailScreen(),
};
