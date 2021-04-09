import 'package:connect_people/models/Category.dart';
import 'package:connect_people/screens/category_result/category_result_screen.dart';
import 'package:connect_people/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:connect_people/size_config.dart';
import 'package:connect_people/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var token;

  Future<List<Category>> fetch() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var uri = HOST_CORE + '/categories/minor';
    final response = await http.get(Uri.parse(uri));
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
      child: SingleChildScrollView(
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
                      Divider(),
                      SizedBox(),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          var icon = Icons.accessibility_new_rounded;
                          if (snapshot.data[index].ID == 6) {
                            icon = Icons.add_a_photo_outlined;
                          } else if (snapshot.data[index].ID == 7) {
                            icon = Icons.add_business;
                          } else if (snapshot.data[index].ID == 8) {
                            icon = Icons.adb_sharp;
                          } else if (snapshot.data[index].ID == 9) {
                            icon = Icons.audiotrack_sharp;
                          } else if (snapshot.data[index].ID == 10) {
                            icon = Icons.auto_awesome;
                          }
                          return Column(
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(icon),
                                  title: Text(
                                    snapshot.data[index].name ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  dense: true,
                                  selected: true),
                              Divider(),
                              GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 5.55,
                                  mainAxisSpacing: 3.0,
                                  crossAxisSpacing: 3.0,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount:
                                    snapshot.data[index].minorData != null
                                        ? snapshot.data[index].minorData.length
                                        : 0,
                                itemBuilder: (ctx, idx) {
                                  return FlatButton(
                                    onPressed: () => {
                                      if (token != null)
                                        {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CategoryResultScreen(
                                                          categoryID: snapshot
                                                                  .data[index]
                                                                  .minorData[
                                                              idx]['ID']))),
                                        }
                                      else
                                        {
                                          Navigator.pushNamed(
                                              context, SignInScreen.routeName)
                                        }
                                    },
                                    child: Text(snapshot.data[index]
                                            .minorData[idx]['name'] ??
                                        ""),
                                    color: Color(0xFFDCEBFF),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      )
                    ],
                  );
                }
              })),
    ));
  }
}
