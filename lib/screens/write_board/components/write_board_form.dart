import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../components/form_error.dart';
import 'package:connect_people/screens/home/home_screen.dart';
import 'dart:async';

import '../../../constants.dart';
import '../../../size_config.dart';

import 'gallery_photo_wrapper.dart';
import 'delete_widget.dart';
import 'gallery_item.dart';
import 'custom_dialog.dart';
import 'upload_file.dart';
import 'save.dart';

enum PhotoStatus { LOADING, ERROR, LOADED }
enum PhotoSource { FILE, NETWORK }

class WriteBoardForm extends StatefulWidget {

  const WriteBoardForm({
    Key key,
    @required this.categoryIDs
  }) : super(key: key);

  final List<int> categoryIDs;

  @override
  _WriteBoardForm createState() => _WriteBoardForm();
}

class _WriteBoardForm extends State<WriteBoardForm> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String subTitle;
  String content;
  String brandName;
  List<String> uploadedUrls = [];
  bool remember = false;
  final List<String> errors = [];

  List<File> _photos = List<File>();
  List<String> _photosUrls = List<String>();

  List<PhotoStatus> _photosStatus = List<PhotoStatus>();
  List<PhotoSource> _photosSources = List<PhotoSource>();
  List<GalleryItem> _galleryItems = List<GalleryItem>();

  SharedPreferences sharedPreferences;

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
            MaterialIcons.photo_camera,
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

    if (permissionStatus == PermissionStatus.denied) {
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

          bool isUploaded = await uploadFile(context, image);
          if (isUploaded) {
            print('Uploaded');
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

  Future<bool> saveBoard(String brandName, int memberID, String title, String subTitle, String content, List<String> uploadedUrls) async {
    try {
      Save save = Save();
      await save.call(brandName, memberID, title, subTitle, content, uploadedUrls, widget.categoryIDs);

      if (save.success != null && save.success) {
        return true;
      } else {
        throw save.message;
      }
    } catch (e) {
      throw e;
    }
  }

  _onSaveClicked(String brandName, int memberID, String title, String subTitle, String content, List<String> uploadedUrls) async {
    try {
      // sharedPreferences = await SharedPreferences.getInstance();
      // await sharedPreferences.setStringList("images", _photosUrls);

      bool success = await saveBoard(brandName, memberID, title, subTitle, content, uploadedUrls);

      if (success) {
        showDialog(context: context, builder: (context) {
          return AlertDialog(
            title: new Text("Success!"),
            content: new Text("작성 완료"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, HomeScreen.routeName);
                  },
                  child: new Text("OK")
              )
            ],
          );
        });
      }

      print('Successfully saved');
    } catch (e) {
      print('Error saving ');
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

  Future<bool> uploadFile(context, File image) async {
    try {
      UploadFile uploadFile = UploadFile();
      await uploadFile.call(image);

      if (uploadFile.isUploaded != null && uploadFile.isUploaded) {
        uploadedUrls.add(uploadFile.returnUrl);
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
    print("delete index : " + (index).toString());
    uploadedUrls.removeAt(index);
    print(uploadedUrls);
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

  _test() {
    for (int i = 0; i < widget.categoryIDs.length; i++) {
      print(widget.categoryIDs[i]);
    }
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
                  visible: _photosStatus[index - 1] == PhotoStatus.LOADED,
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
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // TODO MemberID 가져와야 함
                _onSaveClicked(brandName, 1, title, subTitle, content, uploadedUrls);
              }
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
            padding: EdgeInsets.all(0.0),
            child: Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: 400.0, minHeight: 50.0),
                alignment: Alignment.center,
                child: Text(
                  "작성 완료",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
            ),
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
        labelText: "연락처",
        hintText: "연락처 또는 이메일을 입력해 주세요",
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
}
