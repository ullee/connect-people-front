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
  bool isCheck;

  CheckList({this.categoryID, this.isCheck});
}

class _MediumDepthState extends State<MediumDepth> {
  List<CheckList> checkList = new List<CheckList>();
  List<int> categoryIDs = new List<int>();

  Future<List<Category>> fetch() async {
    var uri = HOST_CORE + '/categories/minor';
    final response = await http.get(Uri.parse(uri));
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }

    var jsonData = jsonDecode(response.body)['data'] as List;
    List<Category> categories =
        jsonData.map((json) => Category.fromJson(json)).toList();

    for (var mediumCategory in categories) {
      if (mediumCategory.minorData != null) {
        for (var minorCategory in mediumCategory.minorData) {
          var result =
              new CheckList(categoryID: minorCategory['ID'], isCheck: false);
          checkList.add(result);
        }
      }
    }

    return categories;
  }

  _getCheckListIndex(int categoryID) {
    for (int i = 0; i < checkList.length; i++) {
      if (checkList[i].categoryID == categoryID) {
        return i;
      }
    }
    return 0;
  }

  Widget _topButton(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.keyboard_arrow_left),
                Text("이전"),
              ],
            ),
            onPressed: () => {
                  setState(() {
                    if (categoryIDs.contains(widget.parentID)) {
                      categoryIDs.remove(widget.parentID);
                    }
                  }),
                  Navigator.pop(context),
                }),
        Column(
          children: [
            Text("글쓰기"),
            Text("(복수선택가능)", style: TextStyle(fontSize: 13)),
          ],
        ),
        FlatButton(
          color: Colors.white,
          child: Row(
            children: [
              Text("다음"),
              Icon(Icons.keyboard_arrow_right),
            ],
          ),
          onPressed: () => {
            setState(() {
              if (categoryIDs.isEmpty) {
                print(categoryIDs);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: new Text("필수"),
                        content: new Text("카테고리를 한개이상 선택해 주세요"),
                        actions: <Widget>[
                          new FlatButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: new Text("Close"))
                        ],
                      );
                    });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WriteBoardScreen(
                            categoryIDs: categoryIDs,
                            parentID: widget.parentID)));
              }
            }),
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: Center(child: Text('글쓰기')),
          title: Center(child: _topButton(context)),
          automaticallyImplyLeading: false, // 백버튼 비활성화
        ),
        body: SafeArea(
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
                          // _topButton(context),
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
                              return Column(
                                children: [
                                  ListTile(
                                      title:
                                          Text(snapshot.data[index].name ?? ""),
                                      dense: true,
                                      selected: true),
                                  Divider(),
                                  ListView.separated(
                                    physics:
                                        NeverScrollableScrollPhysics(), // 스크롤 막기
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data[index].minorData !=
                                            null
                                        ? snapshot.data[index].minorData.length
                                        : 0,
                                    itemBuilder: (ctx, idx) {
                                      return CheckboxListTile(
                                        title: Text(snapshot.data[index]
                                                .minorData[idx]['name'] ??
                                            ""),
                                        value: checkList[_getCheckListIndex(
                                                snapshot.data[index]
                                                    .minorData[idx]['ID'])]
                                            .isCheck,
                                        onChanged: (bool value) {
                                          setState(() {
                                            checkList[_getCheckListIndex(
                                                    snapshot.data[index]
                                                        .minorData[idx]['ID'])]
                                                .isCheck = value;
                                            if (value) {
                                              categoryIDs.add(snapshot
                                                  .data[index]
                                                  .minorData[idx]['ID']);
                                            } else {
                                              categoryIDs.remove(snapshot
                                                  .data[index]
                                                  .minorData[idx]['ID']);
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

void showSnackBar(BuildContext context, String message) {
  Scaffold.of(context).hideCurrentSnackBar();
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(message, textAlign: TextAlign.center),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.lightBlue,
  ));
}
