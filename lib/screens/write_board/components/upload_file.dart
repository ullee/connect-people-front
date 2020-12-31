import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:connect_people/constants.dart';
import 'package:path/path.dart' as path;

class UploadFile {
  bool success;
  String message;
  bool isUploaded;
  String returnUrl;

  Future<void> call(File image) async {
    try {
      var request = new http.MultipartRequest('POST',
          Uri.parse(HOST_CORE + '/boards/images'))
        ..files.add(
            await http.MultipartFile.fromPath(
                'tempFile',
                image.path,
                contentType: MediaType('image', path.extension(image.path))
            )
        );

      // var response = await request.send();
      var response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200) {
        isUploaded = true;
        returnUrl = json.decode(response.body)["data"]["returnUrl"];
      }
    } catch (e) {
      throw ('Error uploading photo');
    }
  }
}
