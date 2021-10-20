import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/services/auth/auth_service.dart';
import 'package:superconnector_vm/core/utils/constants/colors.dart';
import 'package:superconnector_vm/core/utils/constants/strings.dart';
import 'package:superconnector_vm/core/utils/nav/super_navigator.dart';
import 'package:superconnector_vm/core/utils/sms_utility.dart';
import 'package:superconnector_vm/ui/components/dialogs/super_dialog.dart';
import 'package:superconnector_vm/ui/components/underline.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/block_list/block_list.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/components/account_info/account_info.dart';
import 'package:superconnector_vm/ui/screens/authenticated/account/components/account_tile.dart';
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

  Future _toUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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

    // final TextStyle emojiStyle = TextStyle(
    //   fontSize: 18.0,
    // );

    return Scaffold(
      backgroundColor: ConstantColors.OFF_DARK_BLUE,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 8.0),
                    //     child: ChevronBackButton(
                    //       // color: ConstantColors.PRIMARY,
                    //       onBack: () {
                    //         superuser.update();
                    //         Navigator.pop(context);
                    //       },
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        String body = ConstantStrings.TARGETED_INVITE_COPY +
                            ConstantStrings.TESTFLIGHT_LINK;
                        await SMSUtility.send(
                          body,
                          [],
                        );
                        // showDialog(
                        //   context: context,
                        //   builder: (context) {
                        //     return SuperDialog(
                        //       title: 'Sign out',
                        //       subtitle: 'Are you sure you want to sign out?',
                        //       primaryActionTitle: 'Continue',
                        //       primaryAction: _logout,
                        //       secondaryActionTitle: 'Cancel',
                        //       secondaryAction: () => Navigator.of(context).pop(),
                        //     );
                        //   },
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 6.0,
                        ),
                        margin: const EdgeInsets.only(
                          right: 20.0,
                        ),
                        height: 36.0,
                        width: 76.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.0),
                          color: Colors.white.withOpacity(.20),
                        ),
                        child: Text(
                          'Invite',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   behavior: HitTestBehavior.opaque,
                    //   onTap: () async {
                    //     await SMSUtility.send(
                    //       'Hey check out this app Superconnector https://superconnector.com',
                    //       [],
                    //     );
                    //   },
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(
                    //         right: 19,
                    //         bottom: 9.0,
                    //       ),
                    //       child: Text(
                    //         'Invite',
                    //         style: TextStyle(
                    //           color: ConstantColors.PRIMARY,
                    //           fontSize: 18.0,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
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
                        title: 'ACCOUNT',
                        subtitle: 'Manage your profile and data.',
                        onPress: () {
                          SuperNavigator.push(
                            context: context,
                            widget: AccountInfo(),
                            fullScreen: false,
                          );
                        },
                      ),
                      AccountTile(
                        title: 'PERMISSIONS',
                        subtitle: "View mobile phone information we're using.",
                        onPress: () {
                          AppSettings.openAppSettings(
                            asAnotherTask: true,
                          );
                          Future.delayed(
                              Duration(milliseconds: 50), () => exit(0));
                        },
                      ),
                      // AccountTile(
                      //   title: 'SOCIAL',
                      //   subtitle: 'Share your social profiles with connections.',
                      //   onPress: () {},
                      // ),
                      AccountTile(
                        title: 'HELP & FEEDBACK',
                        subtitle: "We'd love to hear from you.",
                        onPress: () {
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
                      AccountTile(
                        title: 'BLOCK LIST',
                        onPress: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return FractionallySizedBox(
                                heightFactor: 0.93,
                                child: BlockList(),
                              );
                            },
                          );
                          // SuperNavigator.push(
                          //   context: context,
                          //   widget: BlockList(),
                          //   fullScreen: false,
                          // );
                        },
                      ),
                      AccountTile(
                        title: 'TERMS OF SERVICE',
                        onPress: () async {
                          await _toUrl('https://www.superconnector.com/terms');
                        },
                      ),
                      AccountTile(
                        title: 'PRIVACY POLICY',
                        onPress: () async {
                          await _toUrl(
                              'https://www.superconnector.com/privacy');
                        },
                      ),
                      AccountTile(
                        title: 'SIGN OUT',
                        onPress: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SuperDialog(
                                title: 'Sign out',
                                subtitle: 'Are you sure you want to sign out?',
                                primaryActionTitle: 'Continue',
                                primaryAction: _logout,
                                secondaryActionTitle: 'Cancel',
                                secondaryAction: () =>
                                    Navigator.of(context).pop(),
                              );
                            },
                          );
                        },
                      ),

                      SizedBox(
                        height: 52.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Built by Superconnector Corporation in Los Angeles.',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(.8),
                          ),
                        ),
                      ),

                      // AccountItem(
                      //   leading: Text(
                      //     '✒️️',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Full Name',
                      //   subtitle: superuser.fullName,
                      //   onPressed: () {
                      //     Navigator.of(context).push(
                      //       PageRouteBuilder(
                      //         opaque: false,
                      //         pageBuilder: (BuildContext context, _, __) {
                      //           return OverlayInput(
                      //             fieldName: 'Full Name',
                      //             textCapitalization: TextCapitalization.words,
                      //             textInputAction: TextInputAction.done,
                      //             value: superuser.fullName,
                      //             onChanged: (text) {
                      //               superuser.fullName = text;
                      //             },
                      //             onSubmit: (text) async {
                      //               superuser.fullName = text;
                      //               superuser.update();
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     );
                      //   },
                      // ),
                      // // AccountItem(
                      // //   leading: Text(
                      // //     '✒️️',
                      // //     style: emojiStyle,
                      // //   ),
                      // //   title: 'Username',
                      // //   subtitle: '@' + superuser.username,
                      // //   onPressed: () {
                      // //     Navigator.of(context).push(
                      // //       PageRouteBuilder(
                      // //         opaque: false,
                      // //         pageBuilder: (BuildContext context, _, __) {
                      // //           return OverlayInput(
                      // //             fieldName: 'Username',
                      // //             textCapitalization: TextCapitalization.none,
                      // //             textInputAction: TextInputAction.done,
                      // //             value: superuser.username,
                      // //             onChanged: (text) {
                      // //               superuser.username = text;
                      // //             },
                      // //             onSubmit: (text) async {
                      // //               superuser.username = text;
                      // //               superuser.update();
                      // //             },
                      // //           );
                      // //         },
                      // //       ),
                      // //     );
                      // //   },
                      // // ),
                      // AccountItem(
                      //   leading: Image.asset(
                      //     'assets/images/authenticated/phone-icon.png',
                      //     width: 18.0,
                      //   ),
                      //   title: 'Phone Number',
                      //   subtitle: superuser.phoneNumber,
                      //   onPressed: () async {},
                      // ),
                      // AccountItem(
                      //   leading: SuperuserImage(
                      //     url: superuser.photoUrl,
                      //     radius: 20 / 2,
                      //     bordered: false,
                      //   ),
                      //   title: 'Profile Picture',
                      //   onPressed: () async {
                      //     superuser.photoUrl = await getImage(superuser.id);
                      //   },
                      // ),
                      // AccountItem(
                      //   leading: Text(
                      //     '🔔',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Notifications',
                      //   onPressed: () {
                      //     AppSettings.openNotificationSettings();
                      //   },
                      // ),
                      // AccountItem(
                      //   leading: Text(
                      //     '❓',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Support',
                      //   onPressed: () {
                      //     final Uri _emailLaunchUri = Uri(
                      //       scheme: 'mailto',
                      //       path: 'support@superconnector.com',
                      //       queryParameters: {
                      //         'subject': '',
                      //       },
                      //     );
                      //     launch(_emailLaunchUri.toString());
                      //   },
                      // ),
                      // AccountItem(
                      //   leading: Text(
                      //     '🔐',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Privacy',
                      //   onPressed: () async {
                      //     const url = 'https://www.superconnector.com/privacy';
                      //     if (await canLaunch(url)) {
                      //       await launch(url);
                      //     } else {
                      //       throw 'Could not launch $url';
                      //     }
                      //   },
                      // ),
                      // AccountItem(
                      //   leading: Text(
                      //     '📁️',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Report Someone',
                      //   onPressed: () async {
                      //     final Uri uri = Uri(
                      //       scheme: 'mailto',
                      //       path: 'support@superconnector.com',
                      //       query: 'subject=I\'d like to report someone',
                      //     );
                      //     if (await canLaunch(uri.toString())) {
                      //       launch(uri.toString());
                      //     } else {
                      //       throw 'Could not launch $uri';
                      //     }
                      //   },
                      // ),
                      // AccountItem(
                      //   leading: Text(
                      //     '📑',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Export Data',
                      //   onPressed: () async {
                      //     final Uri uri = Uri(
                      //       scheme: 'mailto',
                      //       path: 'support@superconnector.com',
                      //       query: 'subject=I\'d like to export my account data',
                      //     );
                      //     if (await canLaunch(uri.toString())) {
                      //       launch(uri.toString());
                      //     } else {
                      //       throw 'Could not launch $uri';
                      //     }
                      //   },
                      // ),
                      // AccountItem(
                      //   leading: Text(
                      //     '⛔️',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Deativate Account',
                      //   onPressed: () async {
                      //     final Uri uri = Uri(
                      //       scheme: 'mailto',
                      //       path: 'support@superconnector.com',
                      //       query: 'subject=I\'d like to deactivate my account',
                      //     );
                      //     if (await canLaunch(uri.toString())) {
                      //       launch(uri.toString());
                      //     } else {
                      //       throw 'Could not launch $uri';
                      //     }
                      //   },
                      // ),
                      // AccountItem(
                      //   leading: Text(
                      //     '🚫',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Block List',
                      //   onPressed: () {
                      //     SuperNavigator.push(
                      //       context: context,
                      //       widget: BlockList(),
                      //       fullScreen: false,
                      //     );
                      //   },
                      // ),
                      // AccountItem(
                      //   leading: Text(
                      //     '🚪',
                      //     style: emojiStyle,
                      //   ),
                      //   title: 'Log Out',
                      //   onPressed: () {
                      //     print('logout');
                      //     showDialog(
                      //       context: context,
                      //       builder: (context) {
                      //         return SuperDialog(
                      //           title: 'Log Out',
                      //           subtitle: 'Are you sure you want to log out?',
                      //           primaryActionTitle: 'Continue',
                      //           primaryAction: _logout,
                      //           secondaryActionTitle: 'Cancel',
                      //           secondaryAction: () => Navigator.of(context).pop(),
                      //         );
                      //       },
                      //     );
                      //     // _panelController.open();
                      //   },
                      // ),
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
