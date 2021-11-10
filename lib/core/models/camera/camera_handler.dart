import 'dart:convert';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_upchunk/flutter_upchunk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/photo/photo.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/nav/authenticated_controller.dart';
import 'package:superconnector_vm/core/utils/video/better_player_utility.dart';
import 'package:tapioca/tapioca.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

class CameraHandler extends ChangeNotifier {
  CameraController? cameraController;
  String _caption = '';
  String _filter = 'Normal';
  bool _browsingFilters = false;
  BetterPlayerController? _betterPlayerController;
  double _progress = 0;
  // bool _uploadCompleted = false;
  // bool _isUploading = false;
  // String? _errorMessage;
  Map<String, dynamic> _uploadData = {};
  List<Video> _videos = [];
  List<Photo> _photos = [];
  XFile? videoFile;
  File? imageFile;
  img.Image? decodedImage;

  double get progress => _progress;
  String get caption => _caption;
  String get filter => _filter;
  bool get browsingFilters => _browsingFilters;

  set caption(String text) {
    _caption = text;
    notifyListeners();
  }

  Future setFilter(String text) async {
    _filter = text;
    try {
      final tapiocaBalls = [
        TapiocaBall.filter(Filters.pink),
      ];
      final cup = Cup(Content(videoFile!.path), tapiocaBalls);
      var tempDir = await getTemporaryDirectory();
      final path =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}result.mp4';
      cup.suckUp(path).then((_) async {
        videoFile = XFile(path);
        notifyListeners();
      });
    } on PlatformException {
      print("error!!!!");
    }

    notifyListeners();
  }

  set browsingFilters(bool shouldBrowse) {
    _browsingFilters = shouldBrowse;
    notifyListeners();
  }

  Future initCamera(
    CameraDescription camera, {
    Function? listener,
  }) async {
    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.bgra8888,
    );

    if (listener != null) {
      cameraController!.addListener(() => listener);
    }

    await cameraController!.initialize();
    await cameraController!.prepareForVideoRecording();
    await cameraController!.lockCaptureOrientation(
      DeviceOrientation.portraitUp,
    );
    // caption = '';

    notifyListeners();
  }

  bool isRecording() {
    return cameraController != null && cameraController!.value.isRecordingVideo;
  }

  Future disposeCamera() async {
    if (cameraController != null) {
      CameraController temp = cameraController!;
      cameraController = null;
      await temp.dispose();
    }

    // caption = '';

    // await initCamera(camera);

    notifyListeners();
  }

  Future takePicture() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      // imageFile = await cameraController!.takePicture();

      XFile xfile = await cameraController!.takePicture();

      List<int> imageBytes = await xfile.readAsBytes();

      decodedImage = img.decodeImage(imageBytes);

      if (cameraController!.description.lensDirection ==
          CameraLensDirection.front) {
        decodedImage = img.flipHorizontal(decodedImage!);
      }

      File file = File(xfile.path);

      imageFile = await file.writeAsBytes(
        img.encodeJpg(decodedImage!),
        flush: true,
      );

      // final img.Image? capturedImage =
      //     img.decodeImage(await File(imageFile!.path).readAsBytes());
      // final img.Image? orientedImage = img.bakeOrientation(capturedImage!);
      // await File(imageFile!.path).writeAsBytes(img.encodeJpg(orientedImage!));
    }
  }

  Future createPhotos(
    List<Connection> connections,
    Superuser superuser,
  ) async {
    _photos = [];
    _uploadData = {};
    _progress = 0;

    List<Future> futures = [];

    var uuid = Uuid();
    // Time based for potential sorting purposes
    var timeBasedUuid = uuid.v1();

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('${superuser.id}/photos/$timeBasedUuid');
    UploadTask uploadTask = ref.putFile(imageFile!);
    uploadTask.snapshotEvents.listen((event) {
      _progress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
    }).onError((error) {
      // do something to handle error
    });
    await uploadTask.whenComplete(() => null);
    var downloadUrl = await ref.getDownloadURL();

    connections.forEach((connection) {
      var photoDoc = FirebaseFirestore.instance.collection('photos').doc();
      Photo photo = Photo(
        id: photoDoc.id,
        url: downloadUrl,
        created: DateTime.now(),
        superuserId: superuser.id,
        connectionId: connection.id,
        caption: caption,
        status: 'ready',
        unwatchedIds:
            connection.userIds.where((id) => id != superuser.id).toList(),
        deleted: false,
      );
      _photos.add(photo);
      futures.add(photo.create());
      connection.mostRecentActivity = DateTime.now();
      futures.add(connection.update());
    });

    await Future.wait(futures);
    _caption = '';
    _filter = 'Normal';
    _browsingFilters = false;
  }

  Future createVideos(
    List<Connection> connections,
    Superuser superuser,
    XFile file,
    BetterPlayerController betterPlayerController,
  ) async {
    _videos = [];
    _uploadData = {};
    _progress = 0;

    List<Future> futures = [];

    connections.forEach((connection) {
      var videoDoc = FirebaseFirestore.instance.collection('videos').doc();
      Video video = Video(
        id: videoDoc.id,
        created: DateTime.now(),
        superuserId: superuser.id,
        connectionId: connection.id,
        caption: caption,
        unwatchedIds:
            connection.userIds.where((id) => id != superuser.id).toList(),
        duration: BetterPlayerUtility.getVideoDuration(
          betterPlayerController,
        ),
        views: 0,
        deleted: false,
      );
      _videos.add(video);
      futures.add(video.create());
      connection.mostRecentActivity = DateTime.now();
      futures.add(connection.update());
    });

    await Future.wait(futures);
    await setUploadData();
    await _uploadFile(file);
    _caption = '';
    _filter = 'Normal';
    _browsingFilters = false;
  }

  Future setUploadData() async {
    String basicAuth = 'Basic ' +
        base64Encode(
          utf8.encode(
            '${dotenv.env['MUX_TOKEN_ID_DEV']}:${dotenv.env['MUX_TOKEN_SECRET_DEV']}',
            // '${dotenv.env['MUX_TOKEN_ID_PROD']}:${dotenv.env['MUX_TOKEN_SECRET_PROD']}',
          ),
        );
    Map<String, String> headers = {
      'content-type': 'application/json',
      'authorization': basicAuth
    };

    Map body = {
      'new_asset_settings': {
        'passthrough': _videos.map((e) => e.id).toList().join(','),
        'playback_policy': ['public']
      },
      'cors_origin': '*',
    };

    var response = await http.post(
      Uri.https('api.mux.com', '/video/v1/uploads'),
      headers: headers,
      body: jsonEncode(body),
    );

    var jsonResponse = jsonDecode(response.body);
    _uploadData = jsonResponse['data'];
  }

  Future<void> _uploadFile(XFile fileToUpload) async {
    _progress = 0;

    // Chunk upload
    var uploadOptions = UpChunkOptions()
      ..endPoint = await _uploadData['url']
      ..file = File(fileToUpload.path)
      ..onProgress = (double progress) {
        _progress = progress;
        notifyListeners();
      }
      ..onError = (
        String message,
        int chunk,
        int attempts,
      ) {
        // _errorMessage = 'UpChunk error 💥 🙀:\n'
        //     ' - Message: $message\n'
        //     ' - Chunk: $chunk\n'
        //     ' - Attempts: $attempts';
        notifyListeners();
      }
      ..onSuccess = () async {
        if (_betterPlayerController == null) {
          return;
        }
      };

    UpChunk.createUpload(uploadOptions);
  }

  void navigateToRolls(BuildContext context) {
    Provider.of<AuthenticatedController>(
      context,
      listen: false,
    ).setIndex(0);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
