import 'package:connect_people/models/Category.dart';
import 'package:connect_people/screens/write_board/write_board_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:connect_people/size_config.dart';
import 'package:connect_people/constants.dart';

class MediumDepth extends StatefulWidget {
  const MediumDepth({
    Key key,
    @required this.parentID,
  }) : super(key: key);

  final int parentID;

  @override
  _MediumDepthState createState() => _MediumDepthState();
}

class CheckList {
  int categoryID;
  int depth;
  bool isCheck;

  CheckList({this.categoryID, this.depth, this.isCheck});
}

List<CheckList> checkList = new List<CheckList>();
List<int> categoryIDs = new List<int>();

Future<List<Category>> fetch(int parentID) async {
  final response = await http.get(HOST_CORE + '/categories/minor/${parentID}');
  if (response.statusCode != 200) {
    throw Exception("Fail to request API");
  }

  var jsonData = jsonDecode(response.body)['data'] as List;
  List<Category> categories = jsonData.map((json) => Category.fromJson(json)).toList();

  for (var mediumCategory in categories) {
    if (mediumCategory.minorData != null) {
      for (var minorCategory in mediumCategory.minorData) {
        var result = new CheckList(
            categoryID: minorCategory['ID'],
            depth: minorCategory['depth'],
            isCheck: false
        );
        checkList.add(result);
      }
    }
  }

  return categories;
}

class _MediumDepthState extends State<MediumDepth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('카테고리'),
          automaticallyImplyLeading: false, // 백버튼 비활성화
        ),
        body: SafeArea(
            child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(child:FutureBuilder(
              future: fetch(widget.parentID),
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
                      Row(
                        children: <Widget>[
                          new Flexible(
                              child:ListTile(
                                leading: Icon(Icons.keyboard_arrow_left),
                                title: Text("이전 카테고리"),
                                dense: true,
                                onTap: () => {
                                  setState(() {
                                    if (categoryIDs.contains(widget.parentID)) {
                                      categoryIDs.remove(widget.parentID);
                                    }
                                  }),
                                  Navigator.pop(context),
                                },
                              )
                          ),
                          new Flexible(
                              child:ListTile(
                                trailing: Icon(Icons.keyboard_arrow_right),
                                title: Text("다음"),
                                dense: true,
                                onTap: () => {
                                  setState(() {
                                    if (!categoryIDs.contains(widget.parentID)) {
                                      categoryIDs.add(widget.parentID);
                                    }
                                  }),
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => WriteBoardScreen(categoryIDs: categoryIDs)))
                                }
                              )
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),),
                      Divider(),
                      SizedBox(),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                  title: Text(snapshot.data[index].name ?? ""),
                                  dense: true,
                                  selected: true
                              ),
                              Divider(),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data[index].minorData != null ? snapshot.data[index].minorData.length : 0,
                                itemBuilder: (ctx, idx) {
                                  return CheckboxListTile(
                                      title: Text(snapshot.data[index].minorData[idx]['name'] ?? ""),
                                      value: checkList[idx].isCheck,
                                      onChanged: (bool value) {
                                        setState(() {
                                          checkList[idx].isCheck = value;
                                          if (value) {
                                            categoryIDs.add(checkList[idx].categoryID);
                                          } else {
                                            categoryIDs.remove(checkList[idx].categoryID);
                                          }
                                        });
                                      },
                                      dense: true,
                                  );
                                },
                                separatorBuilder: (ctx, idx) {
                                  return Divider();
                                },
                              )
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
        )));
  }
}
