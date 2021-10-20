import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';

class ProfileImagePicker extends StatefulWidget {
  ProfileImagePicker({
    Key? key,
    required this.superuser,
    this.width = 125,
    this.showTitle = true,
  }) : super(key: key);

  final Superuser superuser;
  final double width;
  final bool showTitle;

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _imageFile;
  final picker = ImagePicker();
  // bool _wasCropped = false;

  Future getImage(String uid) async {
    var pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      await _cropImage();

      Reference ref =
          FirebaseStorage.instance.ref().child('${uid}_profile_image');
      UploadTask uploadTask = ref.putFile(_imageFile!);
      await uploadTask.whenComplete(() => null);
      var downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } else {
      print('No image selected.');
      return '';
    }
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: _imageFile!.path,
      cropStyle: CropStyle.circle,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      // ],
      androidUiSettings: AndroidUiSettings(
          // toolbarTitle: 'Cropper',
          // toolbarColor: Colors.deepOrange,
          // toolbarWidgetColor: Colors.white,
          // initAspectRatio: CropAspectRatioPreset.original,
          // lockAspectRatio: false,
          ),
      iosUiSettings: IOSUiSettings(
        title: '',
        aspectRatioPickerButtonHidden: true,
        rotateClockwiseButtonHidden: true,
        resetButtonHidden: true,
      ),
    );
    if (croppedFile != null) {
      _imageFile = croppedFile;
      // setState(() {
      //   _wasCropped = true;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Container();
    }

    // if (_imageFile != null && !_wasCropped) {
    //   _cropImage();
    // }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 19.0, bottom: 34.0),
          child: GestureDetector(
            onTap: () async {
              superuser.photoUrl = await getImage(superuser.id);
              await superuser.update();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.showTitle
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 11.0),
                        child: Text(
                          'PROFILE PICTURE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .2,
                          ),
                        ),
                      )
                    : Container(),
                Stack(
                  children: [
                    _imageFile == null && superuser.photoUrl != ''
                        ? SuperuserImage(
                            url: superuser.photoUrl,
                            radius: widget.width / 2,
                          )
                        : Container(
                            width: widget.width,
                            height: widget.width,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // color: ConstantColors.IMAGE_BORDER,
                              // border: _imageFile != null
                              //     ? Border.all(
                              //         width: 2,
                              //         color: ConstantColors.IMAGE_BORDER,
                              //       )
                              //     : Border.all(
                              //         width: 0,
                              //         // color: ConstantColors.IMAGE_BORDER,
                              //       ),
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: _imageFile == null
                                    ? AssetImage(
                                        'assets/images/authenticated/profile-image-picker-empty.png',
                                      )
                                    : FileImage(_imageFile!) as ImageProvider,
                              ),
                            ),
                          ),
                    Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: Image(
                        width: 28.0,
                        image: AssetImage(
                          'assets/images/authenticated/edit-photo-icon.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
