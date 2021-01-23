import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../../../size_config.dart';
import '../../../constants.dart';
import 'header.dart';

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

  List<dynamic> deletedItems;

  Future<List<dynamic>> _getCategoryNames() async {
    final response = await http.post(
        HOST_CORE + '/categories/names',
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

  Widget tags() {
    return FutureBuilder(
        future: _getCategoryNames(),
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
                  /*
                  removeButton: ItemTagsRemoveButton(
                    onRemoved: (){
                      if (snapshot.data.length > 0) {
                        setState(() {
                          snapshot.data.removeAt(index);
                        });
                      }
                      return true;
                    },
                  ),
                  */
                );
              },
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Header(),
            SizedBox(height: getProportionateScreenWidth(30)),
            tags(),
          ],
        ),
      ),
    );
  }
}
