import 'dart:convert';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_upchunk/flutter_upchunk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:superconnector_vm/core/models/connection/connection.dart';
import 'package:superconnector_vm/core/models/superuser/superuser.dart';
import 'package:superconnector_vm/core/models/video/video.dart';
import 'package:superconnector_vm/core/utils/video/better_player_utility.dart';

class CameraHandler extends ChangeNotifier {
  CameraController? _cameraController;
  BetterPlayerController? _betterPlayerController;
  double _progress = 0;
  bool _uploadCompleted = false;
  bool _isUploading = false;
  String? _errorMessage;
  Map<String, dynamic> _uploadData = {};
  List<Video> _videos = [];

  double get progress => _progress;

  Future createVideos(
    List<Connection> connections,
    Superuser superuser,
    XFile file,
  ) async {
    _videos = [];
    _uploadData = {};
    _uploadCompleted = false;
    _isUploading = true;
    _progress = 0;

    List<Future> futures = [];

    connections.forEach((connection) {
      var videoDoc = FirebaseFirestore.instance.collection('videos').doc();
      Video video = Video(
        id: videoDoc.id,
        created: DateTime.now(),
        superuserId: superuser.id,
        connectionId: connection.id,
        unwatchedIds:
            connection.userIds.where((id) => id != superuser.id).toList(),
        duration: BetterPlayerUtility.getVideoDuration(
          _betterPlayerController,
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
    _uploadCompleted = false;
    _isUploading = true;
    _errorMessage = null;

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
        _errorMessage = 'UpChunk error 💥 🙀:\n'
            ' - Message: $message\n'
            ' - Chunk: $chunk\n'
            ' - Attempts: $attempts';
        notifyListeners();
      }
      ..onSuccess = () async {
        if (_betterPlayerController == null) {
          return;
        }

        _uploadCompleted = true;
      };

    UpChunk.createUpload(uploadOptions);
  }
}
