import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareHelper {
  static Future<void> shareText({required String text}) async {
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> shareUrl({required String url}) async {
    try {
      await SharePlus.instance.share(ShareParams(uri: Uri.parse(url)));
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> shareFileImage({
    required File image,
    String? message,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(image.path)], text: message),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> shareFile({required File file, String? message}) async {
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: message),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> shareNetworkImage({
    required String imageUrl,
    String? message,
  }) async {
    try {
      final Random rng = Random();
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;
      final File file = File('$tempPath${rng.nextInt(100)}.png');
      final Uri url = Uri.parse(imageUrl);
      final http.Response response = await http.get(url);
      await file.writeAsBytes(response.bodyBytes);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: message),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> shareFiles({
    required List<XFile> files,
    String? message,
  }) async {
    try {
      await SharePlus.instance.share(ShareParams(files: files, text: message));
    } catch (e) {
      rethrow;
    }
  }
}
