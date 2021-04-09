import 'dart:convert';

import 'package:connect_people/constants.dart';
import 'package:connect_people/screens/board_detail/board_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:connect_people/models/MyBoards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: _list(context),
      ),
    );
  }

  Future<List<MyBoards>> _getMyBoards() async {
    final prefs = await SharedPreferences.getInstance();
    var uri = HOST_CORE + '/my/boards';
    final response = await http.get(Uri.parse(uri),
        headers: {'token': prefs.getString('token')});
    if (response.statusCode != 200) {
      throw Exception("Fail to request board API");
    }

    var jsonData = jsonDecode(response.body)['data'] as List;
    List<MyBoards> boards = jsonData.map((json) => MyBoards.fromJson(json)).toList();

    return boards;
  }

  Future<void> _delete(int boardID) async {
    try {
      var uri = HOST_CORE + '/boards/' + boardID.toString();
      final response = await http.delete(Uri.parse(uri));

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print('Error delete board');
      return false;
    }
  }

  Widget _list(context) {
    return Column(
      children: [
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
                child: Center(child: Text("등록한 게시글이 없습니다.", style: TextStyle(color: Colors.black, fontSize: 12))),
                // child: Center(child: CupertinoActivityIndicator()),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _myBoardList(context, snapshot) {
    return Container(
      height: 590,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
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
                    leading: Image.network(snapshot.data[index].imageUrl,
                    fit: BoxFit.cover),
                    title: Text(snapshot.data[index].title ?? ""),
                    dense: true,
                    onTap: () => Navigator.pushNamed(
                      context, BoardDetailScreen.routeName,
                      arguments: BoardDetailArguments(boardID: snapshot.data[index].boardID)),
                  ),
                );
              },
            separatorBuilder: (context, index) {
              return Divider();
            },
          )),
        ],
      ),
    );
  }

  void _showDialog(snapshot, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content:
              new Text("정말 게시글을 삭제 하시겠습니까?", style: TextStyle(fontSize: 13)),
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
}
