import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connect_people/screens/home_search/home_search_screen.dart';
import 'package:connect_people/screens/sign_in/sign_in_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SearchField extends StatefulWidget {
  
  const SearchField({
    Key key,
  }) : super(key: key);
  
  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {

  bool hasToken = false;

  Future<bool> _check() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('token') == null) {
      return false;
    }
    hasToken = true;
    return true;
  }

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.55,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onTap: () => hasToken ? 
            Navigator.pushNamed(context, HomeSearchScreen.routeName) 
            : Navigator.pushNamed(context, SignInScreen.routeName),
        readOnly: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "파트너를 검색해보세요",
            hintStyle: TextStyle(fontSize: 13.0),
            prefixIcon: Icon(Icons.search)),
      ),
    );
  }
}
