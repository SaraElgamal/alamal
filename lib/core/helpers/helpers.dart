import 'dart:io';
import 'package:charity_app/core/config/res/constants_manager.dart';
import 'package:charity_app/core/helpers/cache_service.dart';
import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:charity_app/core/widgets/custom_loading.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class Helpers {
  static Future<File?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      File imageFile = File(image.path);
      return imageFile;
    }
    return null;
  }

  static bool isArabic() =>
      CacheStorage.read(ConstantManager.languageKey) == 'ar';

  static String? _token;

  static Future<void> init() async {
    _token = await SecureStorage.read(ConstantManager.token);
  }

  static bool isLogged() => _token != null && _token!.isNotEmpty;

  static void setToken(String? token) {
    _token = token;
  }

  static bool isEnglish() =>
      CacheStorage.read(ConstantManager.languageKey) == 'en';

  static Future<List<File>> getImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> result = await picker.pickMultiImage();
    if (result.isNotEmpty) {
      List<File> files = result.map((e) => File(e.path)).toList();
      return files;
    } else {
      return [];
    }
  }

  static Future<File?> getImageFromCameraOrDevice({int? imageQuality}) async {
    final ImagePicker picker = ImagePicker();
    File? image;
    await showModalBottomSheet(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text('مكتبة الصور'),
                  onTap: () async {
                    final currentImage = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: imageQuality,
                    );
                    if (currentImage != null) {
                      image = File(currentImage.path);
                    }
                    NavigationService.pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text('الكاميرا'),
                  onTap: () async {
                    final currentImage = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: imageQuality,
                    );
                    if (currentImage != null) {
                      image = File(currentImage.path);
                    }
                    NavigationService.pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    return image;
  }

  static void shareApp(url) {
    CustomLoading.showFullScreenLoading();
    SharePlus.instance
        .share(url)
        .whenComplete(() => CustomLoading.hideFullScreenLoading());
  }

  static String getDeviceType() {
    if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'android';
    }
  }

  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required Widget bottomSheet,
    double? maxHeight,
    bool? enableDrag,
    double? minHeight,
    bool? isDismissible,
    bool isconstrainsNull = false,
  }) => showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    constraints: isconstrainsNull
        ? null
        : BoxConstraints(
            maxHeight: maxHeight ?? 559.h,
            minHeight: minHeight ?? 0,
          ),
    enableDrag: enableDrag ?? true,
    isDismissible: isDismissible ?? true,
    backgroundColor: Colors.transparent,
    builder: (_) => bottomSheet,
  );

  static String formatDateTime(DateTime? date) {
    DateTime dateTime = DateTime.parse(date.toString());
    DateFormat dateFormat = DateFormat('dd/MM/yyyy - h:mm a');
    return dateFormat.format(dateTime);
  }

  // static UserModel? get user {
  //   final String? userData = CacheStorage.read(ConstantManager.userData);
  //   if (userData != null) {
  //     return UserModel.fromJson(jsonDecode(userData));
  //   }
  //   return null;
  // }

  static Future<String> getDeviceId() async {
    final cached = CacheStorage.read(ConstantManager.deviceId);
    if (cached != null && cached.isNotEmpty) return cached;
    final deviceInfo = DeviceInfoPlugin();
    String deviceId = 'unknown_device_id';
    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      deviceId = android.id;
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      deviceId = ios.identifierForVendor ?? deviceId;
    }
    await CacheStorage.write(ConstantManager.deviceId, deviceId);
    if (kDebugMode) {
      debugPrint('Device ID: $deviceId');
    }
    return deviceId;
  }

  static String? get deviceId => CacheStorage.read(ConstantManager.deviceId);

  // static Future<String?> getDeviceToken() async {
  //   final FirebaseMessaging _firebaseMessaging = sl<FirebaseMessaging>();
  //   try {
  //     final token = await _firebaseMessaging.getToken();
  //     if (kDebugMode) {
  //       print('📱 [Driver] FCM Token: $token');
  //     }
  //     await CacheStorage.write(
  //       ConstantManager.fbToken,
  //       token,
  //     );
  //     return token;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('FCM: Failed to get token: $e');
  //     }
  //     return null;
  //   }
  // }

  static String calculateFee(String requestAmountStr, String payableStr) {
    final requestAmount = double.parse(
      requestAmountStr.replaceAll(' USD', '').trim(),
    );
    final payable = double.parse(payableStr.replaceAll(' USD', '').trim());

    final fee = payable - requestAmount;
    return fee.toStringAsFixed(4);
  }

  static String sanitizePhone(String phone) {
    String cleaned = phone.trim();
    if (cleaned.startsWith('0')) {
      cleaned = cleaned.replaceFirst(RegExp(r'^0+'), '');
    }
    return cleaned;
  }

  // static Future<String> getAddressFromLatLong({
  //   required String lat,
  //   required String lng,
  // }) async {
  //   try {
  //     await GeocodingHelper.setLocaleIdentifier(
  //       isArabic()
  //           ? 'ar'
  //           : isEnglish()
  //               ? 'en'
  //               : 'ur',
  //     );
  //     String latitude = lat;
  //     String longitude = lng;

  //     List<Placemark> placeMarks = await GeocodingHelper.getAddressFromCoordinates(
  //       double.parse(latitude),
  //       double.parse(longitude),
  //     );
  //     if (placeMarks.isNotEmpty) {
  //       Placemark place = placeMarks.first;

  //       String city = place.locality ?? '';
  //       String name = place.name ?? '';

  //       String formattedAddress = '$name , $city';
  //       return formattedAddress;
  //     } else {
  //       return 'noLocation'.tr();
  //     }
  //   } catch (e) {
  //     debugPrint('An error occurred: $e');
  //     return 'noLocation'.tr();
  //   }
  // }
}
