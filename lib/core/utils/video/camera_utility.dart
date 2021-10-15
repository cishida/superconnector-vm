import 'package:camera/camera.dart';

class CameraUtility {
  static Future<CameraController> initializeController(
    CameraDescription camera, {
    Function? listener,
  }) async {
    CameraController controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );

    if (listener != null) {
      controller.addListener(() => listener);
    }

    await controller.initialize();
    await controller.prepareForVideoRecording();

    return controller;
  }
}
