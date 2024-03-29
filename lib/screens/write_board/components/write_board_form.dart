import 'dart:io';

import 'package:connect_people/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
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
  const WriteBoardForm(
      {Key key, @required this.categoryIDs, @required this.parentID})
      : super(key: key);

  final List<int> categoryIDs;
  final int parentID;

  @override
  _WriteBoardForm createState() => _WriteBoardForm();
}

class _WriteBoardForm extends State<WriteBoardForm> {

  int _uploadCount = 0;
  bool _isButtonDisabled = false;

  List<String> uploadedUrls = [];

  List<File> _photos = List<File>();
  List<String> _photosUrls = List<String>();

  List<PhotoStatus> _photosStatus = List<PhotoStatus>();
  List<PhotoSource> _photosSources = List<PhotoSource>();
  List<GalleryItem> _galleryItems = List<GalleryItem>();

  SharedPreferences sharedPreferences;

  TextEditingController brandNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subTitleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  void _buttonPressed(String onoff) {
    if (onoff == "ON") {
      setState(() {
        _isButtonDisabled = true;
      });
    } else {
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  void initState() {
    super.initState();
    _isButtonDisabled = false;
    _uploadCount = 0;
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

    if (permissionStatus == PermissionStatus.limited) {
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
      final picker = ImagePicker();
      PickedFile image = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 90
      );

      if (image != null) {
        if (_uploadCount > 4) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: new Text("이미지 업로드 최대 갯수는 5개 입니다"),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: new Text("Close"))
                ],
              );
            });
          return;
        }

        int length;
        length = _photos.length + 1;

        String fileExtension = path.extension(image.path);

        var allowExtensions = [".jpeg", ".jpg", ".png"];

        if (!allowExtensions.contains(fileExtension.toLowerCase())) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // title: new Text("필수"),
                content: new Text("이미지파일 jpeg, jpg, png 권장"),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: new Text("Close"))
                ],
              );
            });
          return;
        }

        _galleryItems.add(
          GalleryItem(
            id: Uuid().v1(),
            resource: image.path,
            isSvg: fileExtension.toLowerCase() == ".svg",
          ),
        );

        setState(() {
          _photos.add(File(image.path));
          _photosStatus.add(PhotoStatus.LOADING);
          _photosSources.add(PhotoSource.FILE);
        });

        try {
          bool isUploaded = await uploadFile(context, File(image.path));
          if (isUploaded) {
            print('Uploaded');
            _uploadCount++;
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

  Future<bool> saveBoard(String brandName, String title, String subTitle,
      String content, List<String> uploadedUrls) async {
    try {
      // 대카테고리 추가
      setState(() {
        if (!widget.categoryIDs.contains(widget.parentID)) {
          widget.categoryIDs.add(widget.parentID);
        }
      });

      Save save = Save();
      await save.call(brandName, title, subTitle, content, uploadedUrls,
          widget.categoryIDs);

      if (save.success != null && save.success) {
        return true;
      } else {
        throw save.message;
      }
    } catch (e) {
      throw e;
    }
  }

  _onSaveClicked(String brandName, String title, String subTitle,
      String content, List<String> uploadedUrls) async {
    try {
      // sharedPreferences = await SharedPreferences.getInstance();
      // await sharedPreferences.setStringList("images", _photosUrls);

      bool success = await saveBoard(brandName, title, subTitle, content, uploadedUrls);

      if (success) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                content: new Text("작성 완료", style: TextStyle(fontSize: 13)),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      },
                      child: new Text("Close", style: TextStyle(fontSize: 13)))
                ],
              );
            });
      }
    } catch (e) {
      print('Error saving');
    }
  }

  _showOpenAppSettingsDialog(context) {
    return CustomDialog.show(
      context,
      '"모든사진 권한" 이 필요합니다',
      '설정-커넥피플을 통해 접근 할 수 있도록 해주세요',
      '설정',
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
    // 이미지 업로드 중에 삭제 했거나, 이미지 업로드 실패 할 경우
    if (uploadedUrls.isEmpty) {
      setState(() {
        if (_photos.isNotEmpty) {
          _photos.removeAt(index);
        }
        if (_photosStatus.isNotEmpty) {
          _photosStatus.removeAt(index);
        }
        if (_photosSources.isNotEmpty) {
          _photosSources.removeAt(index);
        }
        if (_galleryItems.isNotEmpty) {
          _galleryItems.removeAt(index);
        }
      });
      return false;
    }
    
    uploadedUrls.removeAt(index);
    if (_photosStatus[index] == PhotoStatus.LOADED) {
      _photosUrls.removeAt(index);
    }
    _photos.removeAt(index);
    _photosStatus.removeAt(index);
    _photosSources.removeAt(index);
    _galleryItems.removeAt(index);
    setState(() {
      _uploadCount--;
    });
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
                      child: source == PhotoSource.FILE ? Image.file(image) : Image.network(_photosUrls[index - 1]),
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

  void _press(context) {
    if (uploadedUrls == null || uploadedUrls.isEmpty || uploadedUrls.length == 0) {
      showSnackBar(context, "이미지를 하나이상 업로드 해주세요");
      _buttonPressed("OFF");
    } else if (uploadedUrls.length > 5) {
      showSnackBar(context, "이미지는 최대 5개 까지 업로드 가능 합니다.");
      _buttonPressed("OFF");
    } else if (brandNameController.text.isEmpty) {
      showSnackBar(context, "파트너명을 입력해 주세요");
      _buttonPressed("OFF");
    } else if (titleController.text.isEmpty) {
      showSnackBar(context, "제목을 입력해 주세요");
      _buttonPressed("OFF");
    } else if (subTitleController.text.isEmpty) {
      showSnackBar(context, "연락처를 입력해 주세요");
      _buttonPressed("OFF");
    } else if (contentController.text.isEmpty) {
      showSnackBar(context, "내용을 입력해 주세요");
      _buttonPressed("OFF");
    } else {
      _onSaveClicked(
        brandNameController.text,
        titleController.text,
        subTitleController.text,
        contentController.text,
        uploadedUrls);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            images(),
            buildBrandNameFormField(),
            SizedBox(height: getProportionateScreenHeight(10)),
            buildTitleFormField(),
            SizedBox(height: getProportionateScreenHeight(10)),
            buildSubTitleFormField(),
            SizedBox(height: getProportionateScreenHeight(10)),
            buildContentFormField(),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              width: double.infinity,
              height: getProportionateScreenHeight(45),
              child: FlatButton(
                color: _isButtonDisabled? Colors.grey : Colors.blue,
                onPressed: () {
                  if (_isButtonDisabled) {
                    print("progress...");
                    return null;
                  } else {
                    _buttonPressed("ON");
                  }
                  _press(context);
                },
                child: Text(
                  _isButtonDisabled ? "진행중" : "작성완료",
                  style: TextStyle(
                  fontSize: getProportionateScreenWidth(12),
                  color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Text("(등록 후 수정 불가)", style: TextStyle(color: Colors.grey))
          ],
        ),
      ),
    );
  }

  TextField buildBrandNameFormField() {
    return TextField(
      controller: brandNameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "파트너명을 입력하세요. Ex) ㈜커넥피플, 홍길동",
        hintStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        contentPadding: EdgeInsets.all(10),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC3C3C3))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC3C3C3))),
      ),
      style: TextStyle(fontSize: 12),
    );
  }

  TextField buildTitleFormField() {
    return TextField(
      controller: titleController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "제목을 입력하세요. Ex) 저희 0000을 소개합니다.",
        hintStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        contentPadding: EdgeInsets.all(10),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC3C3C3))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC3C3C3))),
      ),
      style: TextStyle(fontSize: 12),
    );
  }

  TextField buildSubTitleFormField() {
    return TextField(
      controller: subTitleController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "연락처 Ex)010-0000-0000 or 카카오톡 ID or E-Mail",
        hintStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        contentPadding: EdgeInsets.all(10),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC3C3C3))),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFC3C3C3))),
      ),
      style: TextStyle(fontSize: 12),
    );
  }

  TextField buildContentFormField() {
    return TextField(
      controller: contentController,
      keyboardType: TextInputType.multiline,
      maxLines: 13,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "내용을 입력하세요.\n\nEx) 안녕하세요.\n여드름패치 및 습윤밴드 해외수출 및 OEM, 오프라인 판매 진행하실 대표님들 모십니다.\n" +
            "시중에나오는 메디폼과, 듀오덤이라고 생각해주시면 됩니다.\n온라인스토어가 아닌 해외수출, OEM, 오프라인 판매에\n" +
            "관심있는 파트너 분들을 모집하며\n" +
            "미국FDA/벤처인증/KTR인증/의약외품 인증받은 제품입니다.\n코로나로인한 마스크 착용으로 여드름패치가 각광받고있으며 함께 WIN-WIN하실분 연락주십시오.\n\n" +
            "홈페이지: www.ConnectPeople.com",
        hintStyle: TextStyle(color: Colors.grey),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        isDense: true,
        // contentPadding: new EdgeInsets.symmetric(vertical: 145.0, horizontal: 10.0),
        contentPadding: const EdgeInsets.all(8.0),
      ),
      style: TextStyle(fontSize: 12),
    );
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
