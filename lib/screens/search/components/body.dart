import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../../size_config.dart';
import '../../../constants.dart';
import '../../../models/Board.dart';
import 'search_no_result.dart';
import 'package:connect_people/screens/board_detail/board_detail_screen.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
    @required this.categoryIDs
  }) : super(key: key);

  final List<int> categoryIDs;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();

  String searchText = "";
  bool _firstSearch = true;

  @override
  void initState() {
    super.initState();
  }

  _BodyState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          _firstSearch = true;
          searchText = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          searchText = searchController.text;
        });
      }
    });
  }

  final TextEditingController searchController = TextEditingController();

  Future<List<dynamic>> getCategoryNames() async {
    var uri = HOST_CORE + '/categories/names';
    final response = await http.post(
        Uri.parse(uri),
        body: jsonEncode(
            {
              'categoryIDs': widget.categoryIDs,
            }
        ),
        headers: {'Content-Type': 'application/json'}
    );
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }

    return jsonDecode(response.body)['data']['categoryNames'];
  }

  Future<List<Board>> getSearchResult() async {
    final response = await http.post(
        Uri.parse(HOST_CORE + '/boards/search'),
        body: jsonEncode(
            {
              // 'keyword': searchText,
              'categoryIDs': widget.categoryIDs
            }
        ),
        headers: {'Content-Type': 'application/json'}
    );
    if (response.statusCode != 200) {
      throw Exception("Fail to request API");
    }

    var jsonData = jsonDecode(response.body)['data'] as List;
    List<Board> boards = jsonData.map((json) => Board.fromJson(json)).toList();

    return boards;
  }

  Widget searchField() {
    return Container(
      width: SizeConfig.screenWidth * 0.89,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      /*
      child: TextField(
        // onChanged: (value) => print(value),
        controller: searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(9)),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: "찾고 싶은 파트너를 검색해보세요",
          hintStyle: TextStyle(fontSize: 13.3),
          prefixIcon: Icon(Icons.search),
        ),
      ),
      */
    );
  }

  Widget header() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          searchField(),
        ],
      ),
    );
  }

  Widget tags() {
    return FutureBuilder(
        future: getCategoryNames(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          } else {
            return Tags(
              key: _tagStateKey,
              itemCount: snapshot.data.length,
              itemBuilder: (index) {
                return ItemTags(
                  key: Key(index.toString()),
                  index: index, // required
                  title: snapshot.data[index],
                  textStyle: TextStyle(fontSize: 14),
                  combine: ItemTagsCombine.withTextBefore,
                  // removeButton: ItemTagsRemoveButton(onRemoved: (){if (snapshot.data.length > 0) {setState(() {snapshot.data.removeAt(index);});}return true;},),
                );
              },
            );
          }
        }
    );
  }

  Widget _images(context, snapshot, index) {
    return Container(
        height: 189,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
              context,
              BoardDetailScreen.routeName,
              arguments: BoardDetailArguments(boardID: snapshot.data[index].ID)
          ),
          child: Container(
            // padding: EdgeInsets.all(getProportionateScreenWidth(8)),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(snapshot.data[index].imageUrl),
                  fit: BoxFit.cover
              ),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2.0,
                  blurRadius: 5.0,
                )
              ],
              color: Colors.white,
            ),
          ),
        )
    );
  }

  Widget _content(context, snapshot, index) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          SizedBox(height: 5.0),
          Text(
            snapshot.data[index].majorCategoryName,
            style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.0),
          Text(
            snapshot.data[index].title,
            style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.0),
          Text(
            snapshot.data[index].content,
            style: TextStyle(color: Colors.black, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.0),
          Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: SvgPicture.asset(
                      "assets/icons/Heart Icon_2.svg",
                      color: Colors.orange,
                      height: getProportionateScreenWidth(9),
                    ),
                  ),
                  Container(
                    child: Text(
                      " 99",
                      style: TextStyle(color: Colors.black, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
          )
        ]
    );
  }

  Widget searchResult() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: FutureBuilder(
          future: getSearchResult(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: SearchNoResult(),
                ),
              );
            } else {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // SizedBox(height: 15.0),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.55,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 1.0,
                      ),
                      physics: NeverScrollableScrollPhysics(), // 스크롤 막기
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 15.0, left: 6.0, right: 6.0, top: 15.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _images(context, snapshot, index),
                                _content(context, snapshot, index),
                              ]
                          ),
                        );
                      },
                    )
                  ]
              );
            }
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            header(),
            SizedBox(height: getProportionateScreenWidth(30)),
            searchResult(),
            /*
            tags(),
            SizedBox(height: getProportionateScreenWidth(30)),
            _firstSearch ? SearchNoResult() : searchResult()
            */
          ],
        ),
      ),
    );
  }
}
