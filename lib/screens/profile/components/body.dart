import 'dart:convert';

import 'package:connect_people/screens/home/home_screen.dart';
import 'package:connect_people/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:connect_people/models/Profile.dart';

import 'package:connect_people/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<Profile> _fetch() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        HOST_CORE + '/me',
        headers: {'token': prefs.getString('token')}
    );
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }

    Map jsonResult = json.decode(response.body)['result'];
    Map jsonData = json.decode(response.body)['data'];

    if (jsonResult != null && jsonResult['code'] != 1) {
      print(jsonResult['message']);
    }

    if (jsonData == null) {
      var temp = {"ID":0, "loginId":null, "name":null, "phone":null};
      jsonData = temp;
    }

    return Profile.fromJson(jsonData);
  }

  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {

    void _signout() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
    }

    return FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ID == 0) {
              return Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            ListTile(
                                title: Text(
                                    "로그인이 필요합니다.",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                trailing: IconButton(
                                    icon: const Icon(Icons.keyboard_arrow_right),
                                    onPressed: () {
                                      Navigator.pushNamed(context, SignInScreen.routeName);
                                    }),
                                onTap: () {
                                  Navigator.pushNamed(context, SignInScreen.routeName);
                                }
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text("버전정보"),
                                Text("V1.0.0"),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            }
            return Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    ProfilePic(),
                    SizedBox(height: 20),
                    Text(snapshot.data.name ?? "-"),
                    Text(snapshot.data.loginId ?? "-"),
                    Text(snapshot.data.phone ?? "-"),
                    Row(
                      children: [
                        Text("마케팅 정보 수신 동의"),
                        Switch(
                          value: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value;
                            });
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text("버전정보"),
                        Text("V1.0.0"),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        _signout();
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      },
                      child: Text(
                        "로그아웃",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ));
          } else {
            return Container(
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
        });
  }
}
