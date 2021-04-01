import 'package:connect_people/models/Category.dart';
import 'package:connect_people/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import 'medium_depth.dart';
import 'package:connect_people/size_config.dart';
import 'package:connect_people/constants.dart';

class Body extends StatefulWidget {
  @override
  _BodySate createState() => _BodySate();
}

class _BodySate extends State<Body> {
  var token;

  Future<List<Category>> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    final response = await http.get(HOST_CORE + '/categories/major');
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }

    var jsonData = jsonDecode(response.body)['data'] as List;
    List<Category> categories =
        jsonData.map((json) => Category.fromJson(json)).toList();

    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: FutureBuilder(
          future: fetch(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
            } else {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                  ),
                  // SizedBox(height: getProportionateScreenWidth(20)),
                  ListView.separated(
                    // physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var icon = Icons.airline_seat_recline_normal_outlined;
                      if (index == 1) {
                        icon = Icons.accessibility;
                      } else if (index == 2) {
                        icon = Icons.agriculture;
                      } else if (index == 3) {
                        icon = Icons.airplanemode_active_outlined;
                      }
                      return ListTile(
                          leading: Icon(icon),
                          title: Text(snapshot.data[index].name ?? ""),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          dense: true,
                          onTap: () => {
                                if (token != null)
                                  {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MediumDepth(
                                                parentID:
                                                    snapshot.data[index].ID))),
                                  }
                                else
                                  {
                                    Navigator.pushNamed(
                                        context, SignInScreen.routeName)
                                  }
                              });
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  )
                ],
              );
            }
          }),
    ));
  }
}
