import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:image/image.dart' as IMG;
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:sn_progress_dialog/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:solohouse/_common/c_style.dart';
import 'package:solohouse/_common/util.dart';
import 'package:solohouse/app_config.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../_common/api.dart';
import '../_widgets/common_widgets.dart';
import '../_widgets/textarea_dialog.dart';

class ContentWritePage extends StatefulWidget {
  const ContentWritePage({Key? key}) : super(key: key);

  @override
  State<ContentWritePage> createState() => _ContentWritePageState();
}

class _ContentWritePageState extends State<ContentWritePage> {
  final TextEditingController _tecTitle = TextEditingController();
  final TextfieldTagsController _tagsController = TextfieldTagsController();

  String category = '';
  List<String> categories = [
    '일상',
    '집꾸미기',
    '홈스토랑',
    '펫라이프',
  ];
  String content = '';

  AssetEntity? coverPic;
  List<AssetEntity> selectPics = [];

  bool termCheck = false;

  @override
  void initState() {
    super.initState();

    category = categories.first;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글쓰기'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width-32,
                margin: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: hexColor('F3F3F3')
                  )
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    padding: EdgeInsets.zero,
                    alignedDropdown: true,
                    child: DropdownButton(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8),
                      value: category,
                      items: categories.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value, style: CStyle.p16_7_3)
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          category = value as String;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: TextField(
                  controller: _tecTitle,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  style: CStyle.p16_7_3,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 12, right: 12),
                    hintText: "제목을 입력하세요.",
                    hintStyle: CStyle.p16_7_B,
                    counterText: ""
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true, // user must tap button!
                        builder: (BuildContext context) {
                          return TextAreaDialog(
                            text: content
                          );
                        }
                    ).then((value) {
                      if(value != null) {
                        setState(() {
                          content = value;
                        });
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width-32,
                      minHeight: 46
                    ),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: hexColor('F3F3F3'),
                        width: 2
                      )
                    ),
                    child: content==''?Text('내용을 입력해주세요.', style: CStyle.p14_5_B):Text(content, style: CStyle.p14_5_4),
                  ),
                ),
              ),
              _images(context),
              TextFieldTags(
                textfieldTagsController: _tagsController,
                textSeparators: const [' ', ','],
                letterCase: LetterCase.normal,
                validator: (String tag) {
                  if (_tagsController.getTags!.contains(tag)) {
                    return '중복된 태그입니다.';
                  }
                  return null;
                },
                inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
                  return ((context, sc, tags, onTagDelete) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: TextField(
                        controller: tec,
                        focusNode: fn,
                        style: CStyle.p16_7_3,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                            RegExp("[#]"),
                          ),
                        ],
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: _tagsController.hasTags ? '' : "태그입력",
                          hintStyle: CStyle.p14_5_B,
                          errorText: error,
                          prefixIconConstraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.74),
                          prefixIcon: tags.isNotEmpty?
                          SingleChildScrollView(
                            controller: sc,
                            padding: EdgeInsets.only(right: 8),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: tags.map((String tag) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      color: CStyle.colorSec,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    padding: EdgeInsets.only(right: 4, top: 4, bottom: 4, left: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Text('#$tag', style: CStyle.p16_7_white),
                                          onTap: () {
                                            print("$tag selected");
                                          },
                                        ),
                                        SizedBox(width: 4.0),
                                        InkWell(
                                          child: Icon(Icons.cancel, size: 20.0, color: Colors.white),
                                          onTap: () {
                                            onTagDelete(tag);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()),
                          )
                          :null,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      ),
                    );
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          showWebDialog(context, '서비스 이용약관', 'https://server/policy/term.html');
                        },
                        child: Text('서비스 이용약관 동의', style: CStyle.p14_5_pri)
                    ),
                    Checkbox(
                        value: termCheck,
                        onChanged: (value) {
                          setState(() {
                            termCheck = value as bool;
                          });
                        }
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: InkWell(
                  onTap: () {
                    saveContent(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width-32,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CStyle.colorPri,
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text('작성완료', style: CStyle.p14_7_white),
                  ),
                ),

              )
            ],
          ),
        ),
      )
    );
  }

  Widget _images(BuildContext context) {
    double cellWidth = (MediaQuery.of(context).size.width-32-24) / 4;
    if(selectPics.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
        child: cellAdd(context, cellWidth)
      );
    } else {
      return GridView.builder(
          itemCount: selectPics.length + 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16, 30, 16, 30),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1
          ),
          itemBuilder: (BuildContext context, int index) {
            if(selectPics.length == index) {
              return cellAdd(context, cellWidth);
            }

            AssetEntity item = selectPics[index];
            return Stack(
              children: [
                FutureBuilder<dynamic> (
                  future: item.thumbnailData, // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.data != null ) {
                      final bytes = snapshot.data;
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(bytes, width: cellWidth, height: cellWidth, fit: BoxFit.cover)
                      );
                    } else {
                      return Container();
                    }

                  }
                ),
                Visibility(
                  visible: coverPic==item,
                  child: Container(
                    margin: EdgeInsets.only(left: 4, top: 4),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(
                      color: CStyle.colorPri,
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Text('대표', style: CStyle.p10_7_white),
                  ),
                ),
                SizedBox(
                  width: cellWidth,
                  height: cellWidth,
                  child: _imagePopup(item: item, cellWidth: cellWidth)
                ),
              ],
            );
          }
      );

    }
  }

  Widget _imagePopup({required AssetEntity item, required double cellWidth}) => PopupMenuButton<int>(
    padding: EdgeInsets.zero,
    icon: SizedBox(
      width: cellWidth,
      height: cellWidth,
    ),
    onSelected: (value) async {
      if(value == 0) {
        //대표 이미지로 설정
        setState(() {
          coverPic = item;

          selectPics.remove(item);
          selectPics.insert(0, item);
        });
      } else if(value == 1) {
        setState(() {
          if(coverPic == item) {
            coverPic = null;
          }
          selectPics.remove(item);

          if(coverPic == null) {
            if(selectPics.isNotEmpty) {
              coverPic = selectPics.first;
            }
          }
        });
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 0,
        child: Text("대표사진", style: CStyle.p12_4_6),
      ),
      PopupMenuItem(
        value: 1,
        child: Text("삭제", style: CStyle.p12_4_6),
      ),
    ],
  );

  Future<void> onAddClick(BuildContext context) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: selectPics,
        maxAssets: 12,
        requestType: RequestType.common,
        textDelegate: KoreanAssetPickerTextDelegate(),
      ),
    );

    if(result != null) {
      selectPics.clear();
      setState(() {
        selectPics.addAll(result);

        if(coverPic == null) {
          coverPic = selectPics.first;
        } else {
          if(!selectPics.contains(coverPic)) {
            coverPic = selectPics.first;
          }
        }
      });
    }
  }


  Widget cellAdd(BuildContext context, double cellWidth) {
    return InkWell(
      onTap: () {
        //이미지 추가 다이얼로그를 띄운다.
        onAddClick(context);
      },
      child: Container(
        width: cellWidth,
        height: cellWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2,
            color: hexColor('F3F3F3')
          )
        ),
        child: Icon(Icons.add_a_photo_outlined, size: cellWidth/2, color: hexColor('F3F3F3')),
      ),
    );
  }

  Future<void> saveContent(BuildContext context) async {

    if(!termCheck) {
      SmartDialog.showToast('서비스 이용약관에 동의해 주세요.');
      return;
    }

    //무결성 확인

    //첫번째는 동영상인지 확인한다.
    String fileType = mime((await selectPics[0].file)!.path)!;
    if(!fileType.contains('image')) {
      SmartDialog.showToast('대표는 사진만 가능합니다.');
      return;
    }

    //제목과 카테고리가 있어야 한다.
    if(category.isEmpty) {
      SmartDialog.showToast('카테고리를 선택해 주세요.');
      return;
    }

    if(_tecTitle.text.isEmpty) {
      SmartDialog.showToast('제목을 입력해 주세요.');
      return;
    }

    if(content.isEmpty) {
      SmartDialog.showToast('내용 입력해주세요.');
      return;
    }

    if(selectPics.isEmpty) {
      SmartDialog.showToast('최소 1장의 사진을 등록해주세요.');
      return;
    }



    String cover = '';
    List<String> images = [];
    String keyword = _tagsController.getTags!.join(',');

    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: selectPics.length + 1, msg: '업로드 중입니다...');

    // 파일을 업로드한다.
    int count = 0;
    for(AssetEntity asset in selectPics) {
      File? uploadFile = await asset.file;
      if(uploadFile != null) {
        count++;

        //파일이 비디오 인지 확인한다.
        String? type = mime(uploadFile.path);
        Uint8List? uploadImageBytes;
        if(type!.contains('video')) {
          uploadImageBytes ??= uploadFile.readAsBytesSync();

        } else {
          uploadImageBytes ??= uploadFile.readAsBytesSync();
          IMG.Image? oriImage = IMG.decodeImage(uploadFile.readAsBytesSync());
          if(oriImage != null) {
            if(oriImage.width > oriImage.height) {
              if(oriImage.width > 1080) {
                uploadImageBytes = Uint8List.fromList(IMG.encodeJpg(IMG.copyResize(oriImage, width: 1080), quality: 80));
              }
            } else {
              if(oriImage.height > 1080) {
                uploadImageBytes = Uint8List.fromList(IMG.encodeJpg(IMG.copyResize(oriImage, height: 1080), quality: 80));
              }
            }
          }
        }




        var res = await Api().uploadBytes(basename(uploadFile.path), uploadImageBytes!);
        pd.update(value: count);
        if(res.statusCode == 200) {
          var uploadRes = jsonDecode(res.body);
          images.add(uploadRes['s3_files'][0]['path']);
          if(asset == coverPic) {
            cover = uploadRes['s3_files'][0]['path'];
          }
        }
      }
    }

    String url = '${AppConfig().baseUrl()}/user/content';
    var body = {
      'category': category,
      'title': _tecTitle.text,
      'cover': cover,
      'images': images.join(','),
      'keyword': keyword,
      'message': content
    };

    count++;
    pd.update(value: count);
    var postRes = await Api().post(Uri.parse(url), body: body);

    Completed(completedMsg: "등록 완료!");

    if(checkApiError(postRes)) {
      SmartDialog.showToast('에러 T.T');
    } else {
      if (mounted) {
        Navigator.pop(context, 'REFRESH');
      }
    }
  }
}


class KoreanAssetPickerTextDelegate extends AssetPickerTextDelegate {
  const KoreanAssetPickerTextDelegate();

  @override
  String get languageCode => 'kr';

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';

  @override
  String get edit => '편집';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => '읽기실패';

  @override
  String get original => '원본';

  @override
  String get preview => '미리보기';

  @override
  String get select => '선택';

  @override
  String get emptyList => '데이타 없음';

  @override
  String get unSupportedAssetType => 'Unsupported HEIC asset type.';

  @override
  String get unableToAccessAll => 'Unable to access all assets on the device';

  @override
  String get viewingLimitedAssetsTip =>
      'Only view assets and albums accessible to app.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Click to update accessible assets';

  @override
  String get accessAllTip => 'App can only access some assets on the device. '
      'Go to system settings and allow app to access all assets on the device.';

  @override
  String get goToSystemSettings => 'Go to system settings';

  @override
  String get accessLimitedAssets => 'Continue with limited access';

  @override
  String get accessiblePathName => 'Accessible assets';

  @override
  String get sTypeAudioLabel => '오디오';

  @override
  String get sTypeImageLabel => '사진';

  @override
  String get sTypeVideoLabel => '비디오';

  @override
  String get sTypeOtherLabel => '기타';

  @override
  String get sActionPlayHint => '재생';

  @override
  String get sActionPreviewHint => '미리보기';

  @override
  String get sActionSelectHint => '선택';

  @override
  String get sActionSwitchPathLabel => '경로변경';

  @override
  String get sActionUseCameraHint => '카메라 사용';

  @override
  String get sNameDurationLabel => '시간';

  @override
  String get sUnitAssetCountLabel => '갯수';
}