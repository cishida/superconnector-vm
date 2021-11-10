import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/camera/camera_handler.dart';
import 'package:superconnector_vm/core/utils/constants/values.dart';
import 'package:superconnector_vm/ui/components/overlays/overlay_menu.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/camera.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/camera_lens_container/camera_lens_container.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_icon.dart';
import 'package:superconnector_vm/core/utils/extensions/string_extension.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/camera_overlay/camera_overlay_rolls.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/components/uploaded_media/uploaded_media.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/image_preview_container/image_preview_container.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/intro/intro_selection.dart';
import 'package:superconnector_vm/ui/screens/authenticated/camera/trending/trending.dart';
import 'package:superconnector_vm/ui/screens/authenticated/contacts/contacts.dart';
import 'package:superconnector_vm/ui/screens/authenticated/record/video_preview_container/video_preview_container.dart';

class CameraMenu extends StatefulWidget {
  const CameraMenu({
    Key? key,
    required this.toggleCamera,
  }) : super(key: key);

  final Function toggleCamera;

  @override
  State<CameraMenu> createState() => _CameraMenuState();
}

class _CameraMenuState extends State<CameraMenu> {
  // File? _imageFile;
  final _picker = ImagePicker();

  Future<File?> getImage() async {
    var pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<XFile?> getVideo() async {
    var pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 60),
    );

    if (pickedFile != null) {
      return XFile(pickedFile.path);
    } else {
      print('No video selected.');
      return null;
    }
  }

  Future onReset() async {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
      listen: false,
    );

    cameraHandler.imageFile = null;
    cameraHandler.videoFile = null;
    cameraHandler.caption = '';
  }

  Future _goToUploadedMedia() async {
    final cameraHandler = Provider.of<CameraHandler>(
      context,
      listen: false,
    );

    Navigator.of(context).pop();

    final widget;
    if (cameraHandler.imageFile != null) {
      widget = ImagePreviewContainer(
        onReset: () => onReset(),
      );
    } else {
      widget = VideoPreviewContainer(
        onReset: () => onReset(),
      );
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => widget,
        transitionDuration: Duration.zero,
      ),
    );
    // Navigator.of(context).push(
    //   PageRouteBuilder(
    //     pageBuilder: (c, a1, a2) => UploadedMedia(),
    //     transitionsBuilder: (c, anim, a2, child) => FadeTransition(
    //       opacity: anim,
    //       child: child,
    //     ),
    //     transitionDuration: Duration(
    //       milliseconds: 50,
    //     ),
    //   ),
    // );
  }

  List<Widget> _buildIcons(
    BuildContext context,
  ) {
    Map<String, double> nameSizes = {
      'flip': 20.0,
      'flash': 15.0,
      'upload': 16.0,
      // 'lenses': 22.0,
      // 'message': 28.0,
      'trending': 22.0,
      // 'intro': 20.4,
      // 'contract': 22.0,
      // 'invoice': 19.0,
      // 'pay': 13.0,
    };

    List<Widget> widgets = [];
    final cameraHandler = Provider.of<CameraHandler>(
      context,
      listen: false,
    );

    nameSizes.forEach((key, value) {
      widgets.add(
        CameraIcon(
          imageName: 'assets/images/authenticated/record/camera-menu-' +
              key.toLowerCase() +
              '.png',
          title: key.capitalize(),
          onPress: () async {
            switch (key) {
              case 'flip':
                widget.toggleCamera();
                break;
              case 'flash':
                if (cameraHandler.cameraController != null) {
                  switch (cameraHandler.cameraController!.value.flashMode) {
                    case FlashMode.always:
                      await cameraHandler.cameraController!.setFlashMode(
                        FlashMode.auto,
                      );
                      break;
                    case FlashMode.auto:
                      await cameraHandler.cameraController!.setFlashMode(
                        FlashMode.off,
                      );
                      break;
                    case FlashMode.off:
                      await cameraHandler.cameraController!.setFlashMode(
                        FlashMode.always,
                      );
                      break;
                    default:
                  }
                }
                setState(() {});
                break;
              case 'upload':
                final Map<String, Function> menuOptions = {
                  'Photo Upload': () async {
                    cameraHandler.imageFile = await getImage();
                    if (cameraHandler.imageFile != null) {
                      _goToUploadedMedia();
                    }
                  },
                  'Video Upload': () async {
                    cameraHandler.videoFile = await getVideo();
                    if (cameraHandler.videoFile != null) {
                      _goToUploadedMedia();
                    }
                  },
                };

                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    reverseTransitionDuration: Duration(milliseconds: 0),
                    pageBuilder: (BuildContext context, _, __) {
                      return OverlayMenu(menuOptions: menuOptions);
                    },
                  ),
                );
                // cameraHandler.imageFile = await getImage();

                // Navigator.of(context).push(
                //   PageRouteBuilder(
                //     pageBuilder: (c, a1, a2) => UploadedMedia(
                //         // file: _imageFile!,
                //         ),
                //     transitionsBuilder: (c, anim, a2, child) => FadeTransition(
                //       opacity: anim,
                //       child: child,
                //     ),
                //     transitionDuration: Duration(
                //       milliseconds: 50,
                //     ),
                //   ),
                // );

                break;
              case 'trending':
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return FractionallySizedBox(
                      heightFactor: 0.93,
                      child: Trending(),
                    );
                  },
                );
                break;
              case 'intro':
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return FractionallySizedBox(
                      heightFactor: 0.93,
                      child: Contacts(
                        isIntro: true,
                        isGroup: true,
                        confirm: () {
                          print('Confirm');
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => CameraLensContainer(
                                lens: key,
                                // reset: ,
                                child: Positioned(
                                  right: 13.0,
                                  top: ConstantValues.TOP_HEIGHT,
                                  child: CameraOverlayRolls(),
                                ),
                              ),
                              transitionsBuilder: (c, anim, a2, child) =>
                                  FadeTransition(
                                opacity: anim,
                                child: child,
                              ),
                              transitionDuration: Duration(
                                milliseconds: 200,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
                break;
              default:
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (c, a1, a2) => Camera(
                      feature: key,
                    ),
                    transitionsBuilder: (c, anim, a2, child) => FadeTransition(
                      opacity: anim,
                      child: child,
                    ),
                    transitionDuration: Duration(
                      milliseconds: 200,
                    ),
                  ),
                );
            }
          },
          width: value,
        ),
      );
    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    CameraHandler cameraHandler = Provider.of<CameraHandler>(context);

    return Positioned.fill(
      top: 51.0,
      right: 0.0,
      child: Align(
        alignment: Alignment.topRight,
        child: AnimatedOpacity(
          opacity: !cameraHandler.isRecording() ? 1.0 : 0.0,
          duration: const Duration(
            milliseconds: ConstantValues.CAMERA_OVERLAY_FADE_MILLISECONDS,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _buildIcons(
              context,
            ),
          ),
        ),
      ),
    );
  }
}
