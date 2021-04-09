import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

class Save {
  bool success;
  String message;

  Future<void> call(String brandName, String title, String subTitle, String content, List<String> uploadedUrls, List<int> categoryIDs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var uri = HOST_CORE + '/boards';
      final response = await http.post(
          Uri.parse(uri),
          body: jsonEncode(
              {
                'brandName': brandName,
                'title': title,
                'subTitle': subTitle,
                'content': content,
                'imageUrls': uploadedUrls,
                'categoryIDs': categoryIDs
              }
          ),
          headers: {'Content-Type': 'application/json', 'token': prefs.getString('token')}
      );

      if (response.statusCode == 200) {
        success = true;
      }

    } catch (e) {
      success = false;
      throw ('Error save board');
    }
  }
}
