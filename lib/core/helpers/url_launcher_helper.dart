import 'dart:io';

import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class UrlLauncherHelper {
  static Future<void> _launch(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      launchUrl(uri, mode: LaunchMode.externalApplication);
      // if (await canLaunchUrl(uri)) {
      //   launchUrl(uri, mode: LaunchMode.externalApplication);
      // } else {
      //   throw 'Could not launch $url';
      // }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> openUrl({required String url}) async {
    final Uri uri = Uri.parse(url);
    await _launch(uri.toString());
  }

  static Future<void> openMap({
    required double latitude,
    required double longitude,
  }) async {
    final Uri uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
    await _launch(uri.toString());
  }

  static Future<void> openEmail({required String email}) async {
    final Uri uri = Uri.parse('mailto:$email');
    await _launch(uri.toString());
  }

  static Future<void> openPhone({required String phone}) async {
    final Uri uri = Uri.parse('tel:$phone');
    await _launch(uri.toString());
  }

  static Future<void> openWhatsApp({
    required String phone,
    String? message,
  }) async {
    final sanitized = phone.replaceAll(RegExp(r'[^\d]'), '');
    final encodedMessage =
        message?.trim().isNotEmpty == true ? '?text=${Uri.encodeComponent(message!)}' : '';
    final url = 'https://wa.me/$sanitized$encodedMessage';
    await _launch(url);
  }

  static Future<void> launchReviewUrl() async {
    const String androidAppId = 'com.geexar.mycurrency';
    const String iosAppId = '6752825082'; //TODO :

    Uri uri;

    if (Platform.isAndroid) {
      uri = Uri.parse('market://details?id=$androidAppId');
    } else if (Platform.isIOS) {
      uri = Uri.parse('itms-apps://itunes.apple.com/app/id$iosAppId');
    } else {
      return;
    }
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Uri webUri;
      if (Platform.isAndroid) {
        webUri = Uri.parse('https://play.google.com/store/apps/details?id=$androidAppId');
      } else if (Platform.isIOS) {
        webUri = Uri.parse('https://apps.apple.com/app/id$iosAppId');
      } else {
        return;
      }
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri);
      }
    }
  }

  static Future<void> downloadFile({required String url, required String fileName}) async {
    try {
       if (Platform.isAndroid) {
        await Permission.storage.request();
      }

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Fallback if standard Download folder is not accessible
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        MessageUtils.showError('Could not find storage directory');
        return;
      }

      final savePath = '${directory.path}/$fileName';

      MessageUtils.showSuccess('بدء التحميل');
      await Dio().download(url, savePath);
      MessageUtils.showSuccess('تم التحميل بنجاح');
    } catch (e) {
      MessageUtils.showError('فشل التحميل');
    }
  }
}

///Schemes for android.
// <queries>
// <!-- If your app opens https URLs -->
// <intent>
// <action android:name="android.intent.action.VIEW" />
// <data android:scheme="http" />
// </intent>
// <intent>
// <action android:name="android.intent.action.VIEW" />
// <data android:scheme="https" />
// </intent>
// <!-- If your app makes calls -->
// <intent>
// <action android:name="android.intent.action.DIAL" />
// <data android:scheme="tel" />
// </intent>
// <!-- If your sends SMS messages -->
// <intent>
// <action android:name="android.intent.action.SENDTO" />
// <data android:scheme="sms" />
// </intent>
// <!-- If your app sends emails -->
// <intent>
// <action android:name="android.intent.action.SEND" />
// <data android:mimeType="*/*" />
// </intent>
// <!-- If your app open different apps -->
// <intent>
// <action android:name="android.intent.action.VIEW" />
// <data android:scheme="tg" />
// </intent>
// </queries>

///Schemes for ios.
// <key>LSApplicationQueriesSchemes</key>
// <array>
// <string>https</string>
// <string>tel</string>
// <string>sms</string>
// <string>whatsapp</string>
// <string>viber</string>
// <string>tg</string>
// <string>itms-beta</string>
// <string>itms</string>
// <string>*/*</string>
// </array>
