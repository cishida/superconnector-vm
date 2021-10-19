import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/components/account_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  ScrollController _scrollController = ScrollController();
  final _picker = ImagePicker();
  File? _imageFile;

  String _formatPhone(String phone) {
    String countryCode = phone.substring(1, phone.length - 10);
    String areaCode = phone.substring(phone.length - 10, phone.length - 7);
    String number = phone.substring(phone.length - 7, phone.length - 4) +
        '-' +
        phone.substring(phone.length - 4);
    String formattedPhone = '+' + countryCode + ' (' + areaCode + ') ' + number;

    return formattedPhone;
  }

  Future _pickImage(String uid) async {
    var pickedFile = await _picker.pickImage(source: ImageSource.gallery);

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
      androidUiSettings: AndroidUiSettings(),
      iosUiSettings: IOSUiSettings(
        title: '',
        aspectRatioPickerButtonHidden: true,
        rotateClockwiseButtonHidden: true,
        resetButtonHidden: true,
      ),
    );
    if (croppedFile != null) {
      _imageFile = croppedFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    Superuser? superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Container();
    }

    return Scaffold(
      backgroundColor: ConstantColors.OFF_DARK_BLUE,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ChevronBackButton(
                          // color: ConstantColors.PRIMARY,
                          onBack: () {
                            // superuser.update();
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Underline(
                color: Colors.white.withOpacity(.2),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountTile(
                        title: 'FULL NAME',
                        subtitle: superuser.fullName,
                        showChevron: false,
                        onPress: () {},
                      ),
                      AccountTile(
                        title: 'MOBILE PHONE',
                        subtitle: _formatPhone(superuser.phoneNumber),
                        showChevron: false,
                        onPress: () {},
                      ),
                      AccountTile(
                        title: 'PROFILE PICTURE',
                        subtitle: 'Edit your profile picture.',
                        onPress: () async {
                          superuser.photoUrl = await _pickImage(superuser.id);
                          superuser.update();
                        },
                      ),
                      AccountTile(
                        title: 'EXPORT DATA',
                        subtitle: 'Request a summary of your data logs.',
                        onPress: () async {
                          final Uri uri = Uri(
                            scheme: 'mailto',
                            path: 'support@superconnector.com',
                            query:
                                'subject=I\'d like to export my account data',
                          );
                          if (await canLaunch(uri.toString())) {
                            launch(uri.toString());
                          } else {
                            throw 'Could not launch $uri';
                          }
                        },
                      ),
                      AccountTile(
                        title: 'DEACTIVATE ACCOUNT',
                        subtitle:
                            'Schedule your account for deactivation or deletion.',
                        onPress: () async {
                          final Uri uri = Uri(
                            scheme: 'mailto',
                            path: 'support@superconnector.com',
                            query: 'subject=I\'d like to deactivate my account',
                          );
                          if (await canLaunch(uri.toString())) {
                            launch(uri.toString());
                          } else {
                            throw 'Could not launch $uri';
                          }
                        },
                      ),
                      SizedBox(
                        height: 200.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
