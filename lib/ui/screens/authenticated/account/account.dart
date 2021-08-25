import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/auth/auth_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/ui/components/buttons/chevron_back_button.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/components/images/superuser_image.dart';
import 'package:superconnector_vm/ui/components/overlay_input.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/block_list/block_list.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/components/account_item.dart';
import 'package:url_launcher/url_launcher.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  ScrollController _scrollController = ScrollController();
  File? _imageFile;
  final picker = ImagePicker();

  Future _logout() async {
    final _auth = Provider.of<AuthService>(context, listen: false);
    // Superuser? superuser =
    //     Provider.of<Superuser?>(context, listen: false);

    // if (superuser == null) {
    //   return;
    // }
    // // Superuser superuser =
    // //     Provider.of<Superuser>(context, listen: false);
    // superuser.fcmTokens = [];
    // await superuser.update();
    _auth.signOut();
    // Navigator.of(context, rootNavigator: true).pop();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future getImage(String uid) async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
    Superuser? superuser = context.watch<Superuser?>();

    if (superuser == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ConstantColors.OFF_WHITE,
        brightness: Brightness.light,
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: ConstantColors.OFF_WHITE,
              height: 55.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ChevronBackButton(
                      color: ConstantColors.PRIMARY,
                      onBack: () {
                        superuser.update();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      if (Platform.isAndroid) {
                        const uri =
                            'sms:?body=Hey%20check%20out%20this%20app%20Superconnector%20https://superconnector.com';
                        await launch(uri);
                      } else if (Platform.isIOS) {
                        // iOS
                        const uri =
                            'sms:&body=Hey%20check%20out%20this%20app%20Superconnector%20https://superconnector.com';
                        await launch(uri);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 19),
                      child: Text(
                        'Invite',
                        style: TextStyle(
                          color: ConstantColors.PRIMARY,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccountItem(
                      leading: Text(
                        '✒️️',
                      ),
                      title: 'Full Name',
                      subtitle: superuser.fullName,
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return OverlayInput(
                                fieldName: 'Full Name',
                                exampleText:
                                    superuser.fullName.length.toString() +
                                        ' / 50',
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.done,
                                value: superuser.fullName,
                                onChanged: (text) {
                                  superuser.fullName = text;
                                },
                                onSubmit: (text) async {
                                  superuser.fullName = text;
                                  superuser.update();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                    AccountItem(
                      leading: Text(
                        '✒️️',
                      ),
                      title: 'Username',
                      subtitle: superuser.username,
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return OverlayInput(
                                fieldName: 'Username',
                                exampleText:
                                    superuser.username.length.toString() +
                                        ' / 50',
                                textCapitalization: TextCapitalization.none,
                                textInputAction: TextInputAction.done,
                                value: superuser.username,
                                onChanged: (text) {
                                  superuser.username = text;
                                },
                                onSubmit: (text) async {
                                  superuser.username = text;
                                  superuser.update();
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                    AccountItem(
                      leading: SuperuserImage(
                        url: superuser.photoUrl,
                        radius: 22 / 2,
                        bordered: false,
                      ),
                      title: 'Profile Picture',
                      onPressed: () async {
                        superuser.photoUrl = await getImage(superuser.id);
                      },
                    ),
                    AccountItem(
                      leading: Text(
                        '🔔',
                      ),
                      title: 'Notifications',
                      onPressed: () {
                        AppSettings.openNotificationSettings();
                      },
                    ),
                    AccountItem(
                      leading: Text(
                        '❓',
                      ),
                      title: 'Support',
                      onPressed: () {
                        final Uri _emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: 'support@superconnector.com',
                          queryParameters: {
                            'subject': '',
                          },
                        );
                        launch(_emailLaunchUri.toString());
                      },
                    ),
                    AccountItem(
                      leading: Text(
                        '🔐',
                      ),
                      title: 'Privacy',
                      onPressed: () async {
                        const url = 'https://www.superconnector.com/privacy';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    AccountItem(
                      leading: Text(
                        '📁️',
                      ),
                      title: 'Report Someone',
                      onPressed: () async {
                        final Uri uri = Uri(
                          scheme: 'mailto',
                          path: 'support@superconnector.com',
                          query: 'subject=I\'d like to report someone',
                        );
                        if (await canLaunch(uri.toString())) {
                          launch(uri.toString());
                        } else {
                          throw 'Could not launch $uri';
                        }
                      },
                    ),
                    AccountItem(
                      leading: Text(
                        '📑',
                      ),
                      title: 'Export Data',
                      onPressed: () async {
                        final Uri uri = Uri(
                          scheme: 'mailto',
                          path: 'support@superconnector.com',
                          query: 'subject=I\'d like to export my account data',
                        );
                        if (await canLaunch(uri.toString())) {
                          launch(uri.toString());
                        } else {
                          throw 'Could not launch $uri';
                        }
                      },
                    ),
                    AccountItem(
                      leading: Text(
                        '⛔️',
                      ),
                      title: 'Deativate Account',
                      onPressed: () async {
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
                    AccountItem(
                      leading: Text(
                        '🚫',
                      ),
                      title: 'Block List',
                      onPressed: () {
                        SuperNavigator.push(
                          context: context,
                          widget: BlockList(),
                          fullScreen: false,
                        );
                      },
                    ),
                    AccountItem(
                      leading: Text(
                        '🚪',
                      ),
                      title: 'Log Out',
                      onPressed: () {
                        print('logout');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SuperDialog(
                              title: 'Log Out',
                              subtitle: 'Are you sure you want to log out?',
                              primaryActionTitle: 'Continue',
                              primaryAction: _logout,
                              secondaryActionTitle: 'Cancel',
                              secondaryAction: () =>
                                  Navigator.of(context).pop(),
                            );
                          },
                        );
                        // _panelController.open();
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
    );
  }
}
