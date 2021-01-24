import 'package:flutter/material.dart';

import 'components/body.dart';

class _SearchState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('검색')
      ),
      body: Body(categoryIDs: widget.categoryIDs),
    );
  }
}

class SearchScreen extends StatefulWidget {
  static String routeName = "/search";

  const SearchScreen({
    Key key,
    @required this.categoryIDs
  }) : super(key: key);

  final List<int> categoryIDs;

  @override
  _SearchState createState() => _SearchState();
}
