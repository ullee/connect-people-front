import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/home/home_screen.dart';
import 'dart:async';
import 'dart:convert';

import '../../../constants.dart';
import '../../../size_config.dart';

import 'gallery_photo_wrapper.dart';
import 'delete_widget.dart';
import 'gallery_item.dart';
import 'custom_dialog.dart';
import 'generate_image_url.dart';
import 'upload_file.dart';

class Result {
  final int code;
  final String message;
  Result({this.code, this.message});
  Result.fromJson(Map<String, dynamic> json) :
        code = json['code'],
        message = json['message'];

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message
  };
}

Future<Result> fetchAll(String brandName, int memberID, String title, String subTitle, String content) async {
  final response = await http.post(
    HOST_CORE + '/boards',
    body: jsonEncode(
      {
        'brandName': brandName,
        'memberID': memberID,
        'title': title,
        'subTitle': subTitle,
        'content': content
      }
    ),
    headers: {'Content-Type': 'application/json'}
  );
  if (response.statusCode != 200) {
    throw Exception("Fail to request API");
  }

  var jsonData = jsonDecode(response.body)['result'];
  var result = Result.fromJson(jsonData);

  return result;
}

enum PhotoStatus { LOADING, ERROR, LOADED }
enum PhotoSource { FILE, NETWORK }

class WriteBoardForm extends StatefulWidget {
  @override
  _WriteBoardForm createState() => _WriteBoardForm();
}

class _WriteBoardForm extends State<WriteBoardForm> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String subTitle;
  String content;
  String brandName;
  bool remember = false;
  final List<String> errors = [];

  List<File> _photos = List<File>();
  List<String> _photosUrls = List<String>();

  List<PhotoStatus> _photosStatus = List<PhotoStatus>();
  List<PhotoSource> _photosSources = List<PhotoSource>();
  List<GalleryItem> _galleryItems = List<GalleryItem>();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  _buildAddPhoto() {
    return InkWell(
      onTap: () => _onAddPhotoClicked(context),
      child: Container(
        margin: EdgeInsets.all(5),
        height: 100,
        width: 100,
        color: Color(0xFFA3A3A3),
        child: Center(
          child: Icon(
            MaterialIcons.add_to_photos,
            color: kLightGray,
          ),
        ),
      ),
    );
  }

  _onAddPhotoClicked(context) async {

    Permission permission;

    if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    PermissionStatus permissionStatus = await permission.status;

    print(permissionStatus);

    if (permissionStatus == PermissionStatus.restricted) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      _showOpenAppSettingsDialog(context);

      permissionStatus = await permission.status;

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.undetermined) {
      permissionStatus = await permission.request();

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus != PermissionStatus.denied) {
      if (Platform.isIOS) {
        _showOpenAppSettingsDialog(context);
      } else {
        permissionStatus = await permission.request();
      }

      if (permissionStatus != PermissionStatus.granted) {
        //Only continue if permission granted
        return;
      }
    }

    if (permissionStatus == PermissionStatus.granted) {
      print('Permission granted');

      File image = await ImagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        int length;
        length = _photos.length + 1;

        String fileExtension = path.extension(image.path);

        _galleryItems.add(
          GalleryItem(
            id: Uuid().v1(),
            resource: image.path,
            isSvg: fileExtension.toLowerCase() == ".svg",
          ),
        );

        setState(() {
          _photos.add(image);
          _photosStatus.add(PhotoStatus.LOADING);
          _photosSources.add(PhotoSource.FILE);
        });

        try {
          GenerateImageUrl generateImageUrl = GenerateImageUrl();
          await generateImageUrl.call(fileExtension);

          String uploadUrl;
          if (generateImageUrl.isGenerated != null && generateImageUrl.isGenerated) {
            uploadUrl = generateImageUrl.uploadUrl;
          } else {
            throw generateImageUrl.message;
          }

          bool isUploaded = await uploadFile(context, uploadUrl, image);
          if (isUploaded) {
            print('Uploaded');
            setState(() {
              _photosUrls.add(generateImageUrl.downloadUrl);
              _photosStatus
                  .replaceRange(length - 1, length, [PhotoStatus.LOADED]);
              _galleryItems[length - 1].resource = generateImageUrl.downloadUrl;
            });
          }
        } catch (e) {
          print(e);
          setState(() {
            _photosStatus[length - 1] = PhotoStatus.ERROR;
          });
        }
      }
    }
  }

  _showOpenAppSettingsDialog(context) {
    return CustomDialog.show(
      context,
      'Permission needed',
      'Photos permission is needed to select photos',
      'Open settings',
      openAppSettings,
    );
  }

  Future<bool> uploadFile(context, String url, File image) async {
    try {
      UploadFile uploadFile = UploadFile();
      await uploadFile.call(url, image);

      if (uploadFile.isUploaded != null && uploadFile.isUploaded) {
        return true;
      } else {
        throw uploadFile.message;
      }
    } catch (e) {
      throw e;
    }
  }

  _onPhotoClicked(int index) {
    if (_photosStatus[index] == PhotoStatus.ERROR) {
      print("Try uploading again");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: _galleryItems,
          photoStatus: _photosStatus[index],
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Future<bool> _onDeleteReviewPhotoClicked(int index) async {
    if (_photosStatus[index] == PhotoStatus.LOADED) {
      _photosUrls.removeAt(index);
    }
    _photos.removeAt(index);
    _photosStatus.removeAt(index);
    _photosSources.removeAt(index);
    _galleryItems.removeAt(index);
    setState(() {});
    return true;
  }

  Widget images() {
    return Container(
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _photos.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildAddPhoto();
            }
            File image = _photos[index - 1];
            PhotoSource source = _photosSources[index - 1];

            return Stack(
              children: <Widget>[
                InkWell(
                    onTap: () => _onPhotoClicked(index - 1),
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 100,
                      width: 100,
                      color: kLightGray,
                      child: source == PhotoSource.FILE
                          ? Image.file(image)
                          : Image.network(_photosUrls[index - 1]),
                    )
                ),
                Visibility(
                  visible: _photosStatus[index - 1] == PhotoStatus.LOADING,
                  child: Positioned.fill(
                    child: SpinKitWave(
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Visibility(
                  visible: _photosStatus[index - 1] == PhotoStatus.ERROR,
                  child: Positioned.fill(
                    child: Icon(
                      MaterialIcons.error,
                      color: kErrorRed,
                      size: 35,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    padding: EdgeInsets.all(6),
                    alignment: Alignment.topRight,
                    child: DeleteWidget(
                          () => _onDeleteReviewPhotoClicked(index - 1),
                    ),
                  ),
                )
              ],
            );
          }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          images(),
          buildBrandNameFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildTitleFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildSubTitleFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildContentFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "작성 완료",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // API Response Parsing
                FutureBuilder<Result>(
                  future: fetchAll(brandName, 1, title, subTitle, content),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: new Text("Error"),
                          content: new Text(snapshot.error),
                          actions: <Widget>[new FlatButton(
                              onPressed: null, child: new Text("Close"))
                          ],
                        );
                      });
                      return null;
                    } else {
                      // 글 작성 성공
                      if (snapshot.data.code == 1) {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: new Text("Success!"),
                            content: new Text(snapshot.data.message),
                            actions: <Widget>[
                              new FlatButton(
                                  onPressed: null, child: new Text("Close"))
                            ],
                          );
                        });
                      }
                      return null;
                    }
                  },
                );
                // TODO Future 로직 안타서 강제 Alert 차후 개선 필요
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    title: new Text("Success!"),
                    content: new Text("작성 완료"),
                    actions: <Widget>[new FlatButton(onPressed: () {Navigator.pushNamed(context, HomeScreen.routeName);}, child: new Text("OK"))],
                  );
                });
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildBrandNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => content = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        brandName = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: "업체명",
        hintText: "업체명을 입력 하세요",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        contentPadding: EdgeInsets.all(10),
      ),
      style: TextStyle(
          fontSize: 12
      ),
    );
  }

  TextFormField buildContentFormField() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onSaved: (newValue) => content = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        content = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        labelText: "내용",
        hintText: "내용을 입력 하세요",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        // contentPadding: new EdgeInsets.symmetric(vertical: 145.0, horizontal: 10.0),
        contentPadding: const EdgeInsets.all(8.0),
      ),
      style: TextStyle(
          fontSize: 12
      ),
    );
  }

  TextFormField buildSubTitleFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => subTitle = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        title = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: "부제목",
        hintText: "부제목을 입력 하세요",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        contentPadding: EdgeInsets.all(10),
      ),
      style: TextStyle(
          fontSize: 12
      ),
    );
  }

  TextFormField buildTitleFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => title = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        title = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: "제목",
        hintText: "제목을 입력 하세요",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        contentPadding: EdgeInsets.all(10),
      ),
      style: TextStyle(
          fontSize: 12
      ),
    );
  }
}
