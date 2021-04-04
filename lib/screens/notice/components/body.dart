// import 'package:connect_people/components/WebViewContainer.dart';
import 'dart:convert';
import 'package:connect_people/screens/notice_detail/notice_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connect_people/models/Notice.dart';
import 'package:connect_people/constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        // child: WebViewContainer("http://ec2-3-35-207-154.ap-northeast-2.compute.amazonaws.com:8080/notice/list"),
        // margin: EdgeInsets.all(20.0),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: _list(context),
      ),
    );
  }

  Future<List<Notice>> _getNotices() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.get(HOST_LAMBDA + '/dev/v1/notice',
        headers: {'token': prefs.getString('token')});
    if (response.statusCode != 200) {
      throw Exception("Fail to request board API");
    }

    var jsonData = jsonDecode(response.body)['items'] as List;
    List<Notice> notices = jsonData.map((json) => Notice.fromJson(json)).toList();

    return notices;
  }

  Widget _list(context) {
    return Column(
      children: [
        FutureBuilder(
          future: _getNotices(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _noticeList(context, snapshot);
            } else {
              return Container(
                child: Text("등록된 게시글이 없습니다.", style: TextStyle(color: Colors.black, fontSize: 12)),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _noticeList(context, snapshot) {
    return Container(
      height: 650,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data[index].title, style: TextStyle(fontSize: 15)),
                        SizedBox(height: 10),
                        Text(snapshot.data[index].created.split(" ")[0], style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    dense: true,
                    onTap: () => Navigator.pushNamed(context, NoticeDetailScreen.routeName,
                      arguments: NoticeDetailArguments(notice_id: snapshot.data[index].id)
                    )
                  )
                ]
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
}
