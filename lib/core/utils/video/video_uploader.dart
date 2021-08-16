import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class VideoUploader {
  Future<dynamic> getUploadJson(String videoId) async {
    String basicAuth = 'Basic ' +
        base64Encode(
          utf8.encode(
            '${dotenv.env['MUX_TOKEN_ID_DEV']}:${dotenv.env['MUX_TOKEN_SECRET_DEV']}',
          ),
        );
    Map<String, String> headers = {
      'content-type': 'application/json',
      'authorization': basicAuth
    };

    print(videoId);
    Map body = {
      'new_asset_settings': {
        'passthrough': videoId,
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
    // _video.uploadId = jsonResponse['data']['id'].toString();

    // return jsonResponse['data']['url'];
    return jsonResponse['data'];
  }

//   Future<void> _uploadFile(File fileToUpload) async {
//     _progress = 0;
//     _uploadComplete = false;
//     _isUploading = true;
//     _errorMessage = null;
//     final superuser = Provider.of<Superuser>(context, listen: false);

//     // Chunk upload
//     var uploadOptions = UpChunkOptions()
//       ..endPoint = await _getUploadUrl()
//       ..file = fileToUpload
//       ..onProgress = (double progress) {
//         setState(() {
//           _progress = progress.floor();
//         });
//       }
//       ..onError = (
//         String message,
//         int chunk,
//         int attempts,
//       ) {
//         setState(() {
//           _errorMessage = 'UpChunk error 💥 🙀:\n'
//               ' - Message: $message\n'
//               ' - Chunk: $chunk\n'
//               ' - Attempts: $attempts';
//         });
//       }
//       ..onSuccess = () async {
//         // if (_video == null) {
//         //   return;
//         // }
//         await videoDoc.set({
//           'uploadId': _video.uploadId,
//           'superuserId': superuser.uid,
//           'caption': _video.caption,
//           // 'hashtags': _video!.hashtags ?? [],
//           'created': Timestamp.now(),
//           'views': 0,
//           'likes': 0,
//           'fromGallery': widget.fromGallery,
//           'deleted': false,
//         });
//         // await AnalyticsLogger.sendAnalyticsEvent(
//         //   'video_created',
//         //   parameters: {
//         //     'caption': _video.caption,
//         //     'superuserId': superuser.uid,
//         //     'uploadId': _video.uploadId,
//         //   },
//         // );
//         setState(() {
//           _uploadComplete = true;
//           _isUploading = false;
//         });

//         Navigator.of(context).popUntil((route) => route.isFirst);
//       };

//     print(UpChunk.createUpload(uploadOptions));
//   }
}
