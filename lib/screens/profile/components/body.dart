import 'dart:convert';

import 'package:connect_people/screens/board_detail/board_detail_screen.dart';
import 'package:connect_people/screens/home/home_screen.dart';
import 'package:connect_people/screens/sign_in/sign_in_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:connect_people/models/MyBoards.dart';
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

  Future<List<MyBoards>> _getMyBoards() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(
        HOST_CORE + '/my/boards',
        headers: {'token': prefs.getString('token')}
    );
    if (response.statusCode != 200) {
      throw Exception("Fail to request board API");
    }

    var jsonData = jsonDecode(response.body)['data'] as List;
    List<MyBoards> boards = jsonData.map((json) => MyBoards.fromJson(json)).toList();

    return boards;
  }

  Future<void> _delete(int boardID) async {
    try {
      final response = await http.delete(
          HOST_CORE + '/boards/' + boardID.toString()
      );

      if (response.statusCode == 200) {
        return true;
      }

    } catch (e) {
      print('Error delete board');
      return false;
    }
  }

  bool _isChecked = true;

  Widget notLogin(context, snapshot) {
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
        )
    );
  }

  void _showDialog(snapshot, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Text("정말 게시글을 삭제 하시겠습니까?", style: TextStyle(fontSize: 13)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes", style: TextStyle(fontSize: 13)),
              onPressed: () {
                _delete(snapshot.data[index].boardID);
                setState(() {
                  snapshot.data.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text("No", style: TextStyle(fontSize: 13)),
              onPressed: () {
                setState(() {
                  snapshot.data.removeAt(index);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _myBoardList(context, snapshot) {
    return Container(
      child: Column(
        children: <Widget>[
          ListView.separated(
            physics: NeverScrollableScrollPhysics(), // 스크롤 막기
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              final item = snapshot.data[index].boardID.toString();
              return Dismissible(
                key: Key(item),
                onDismissed: (direction) {
                  _showDialog(snapshot, index);
                },
                background: Container(color: Colors.red),
                child: ListTile(
                    leading: Image.network(
                        snapshot.data[index].imageUrl,
                        fit: BoxFit.cover
                    ),
                    title: Text(snapshot.data[index].title ?? ""),
                    // trailing: Icon(Icons.restore_from_trash),
                    dense: true,
                    onTap: () => Navigator.pushNamed(
                        context,
                        BoardDetailScreen.routeName,
                        arguments: BoardDetailArguments(boardID: snapshot.data[index].boardID)
                    ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          )
        ],
      ),
    );
  }

  Widget isLogin(context, snapshot) {
    return Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: SingleChildScrollView(
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
              Row(
                children: [
                  Text("내 작성글 ", style: TextStyle(color: Colors.black)),
                  Text("* 슬라이드로 삭제 가능", style: TextStyle(color: Colors.grey))
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(height: 30),
              FutureBuilder(
                future: _getMyBoards(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _myBoardList(context, snapshot);
                  } else {
                    return Container(
                      child: Center(child: CupertinoActivityIndicator()),
                    );
                  }
                },
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
          ),
        )
    );
  }

  void _signout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.ID == 0) {
              return notLogin(context, snapshot);
            }
            return isLogin(context, snapshot);
          } else {
            return Container(
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
        });
  }
}
