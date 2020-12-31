import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:connect_people/constants.dart';

class GetBoardDetail {
  bool success;
  String message;
  int ID;
  String brandName;
  int memberID;
  String title;
  String subTitle;
  String content;
  String imageUrls;
  String created;

  Future<void> call(int boardID) async {
    try {
      final response = await http.get(
          HOST_CORE + '/boards/${boardID}/detail'
      );

      if (response.statusCode == 200) {
        success = true;
      }

      var jsonData = jsonDecode(response.body)['data'];
      print(jsonData);
      ID = jsonData['ID'];
      brandName = jsonData['brandName'];
      memberID = jsonData['memberID'];
      title = jsonData['title'];
      subTitle = jsonData['subTitle'];
      content = jsonData['content'];
      imageUrls = jsonData['imageUrls'];
      created = jsonData['created'];

    } catch (e) {
      success = false;
      message = e;
      throw ('Error save board');
    }
  }
}
