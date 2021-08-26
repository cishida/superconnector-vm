import 'package:camera/camera.dart';

class CameraUtility {
  static Future<CameraController> initializeController(
    List<CameraDescription> cameras,
  ) async {
    CameraController controller = CameraController(
      cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front),
      ResolutionPreset.veryHigh,
      enableAudio: true,
    );
    await controller.initialize();
    await controller.prepareForVideoRecording();

    return controller;
  }
}
