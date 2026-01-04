import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

abstract class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();
  static const _storage = FlutterSecureStorage();
  static const _keyEmail = 'admin_email';
  static const _keyPassword = 'admin_password';
  static const _keyBiometricEnabled = 'biometric_enabled';

  // Minimum Android SDK version for reliable biometric support
  static const int _minAndroidSdkForBiometric = 23; // Android 6.0

  /// Checks the Android version to ensure compatibility
  static Future<bool> _isAndroidVersionSupported() async {
    if (!Platform.isAndroid) return true;

    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      debugPrint('BiometricHelper: Android SDK version: $sdkInt');

      // Android 6.0 (API 23) is minimum for fingerprint
      // Android 9.0 (API 28) is recommended for BiometricPrompt
      return sdkInt >= _minAndroidSdkForBiometric;
    } catch (e) {
      debugPrint('BiometricHelper: Error checking Android version: $e');
      return false;
    }
  }

  /// Checks if the device supports any biometric authentication.
  static Future<bool> isBiometricSupported() async {
    try {
      // Check Android version first
      if (!await _isAndroidVersionSupported()) {
        debugPrint(
          'BiometricHelper: Android version too old for biometric support',
        );
        return false;
      }

      // Check device capabilities
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      debugPrint(
        'BiometricHelper: canCheckBiometrics=$canCheckBiometrics, isDeviceSupported=$isDeviceSupported',
      );

      return canCheckBiometrics && isDeviceSupported;
    } on PlatformException catch (e) {
      debugPrint(
        'BiometricHelper: PlatformException in isBiometricSupported: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      debugPrint('BiometricHelper: Error in isBiometricSupported: $e');
      return false;
    }
  }

  /// Gets available biometric types with error handling
  static Future<List<BiometricType>> _getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint(
        'BiometricHelper: PlatformException getting available biometrics: ${e.code} - ${e.message}',
      );
      return [];
    } catch (e) {
      debugPrint('BiometricHelper: Error getting available biometrics: $e');
      return [];
    }
  }

  /// Attempts to authenticate the user and returns true upon success.
  static Future<bool> authenticate() async {
    try {
      // First check if biometric is supported
      if (!await isBiometricSupported()) {
        debugPrint('BiometricHelper: Biometric not supported on this device');
        return false;
      }

      // Get available biometric types
      final List<BiometricType> available = await _getAvailableBiometrics();

      if (available.isEmpty) {
        debugPrint('BiometricHelper: No biometric types available');
        return false;
      }

      // Determine biometric type for user message
      String biometricType = 'biometric authentication';
      if (available.contains(BiometricType.face)) {
        biometricType = 'Face ID';
      } else if (available.contains(BiometricType.fingerprint)) {
        biometricType = 'Fingerprint';
      } else if (available.contains(BiometricType.strong)) {
        biometricType = 'Strong biometric';
      } else if (available.contains(BiometricType.weak)) {
        biometricType = 'Weak biometric';
      }

      debugPrint(
        'BiometricHelper: Attempting authentication with $biometricType',
      );

      // Authenticate with timeout protection
      final result = await _auth
          .authenticate(
            localizedReason: 'Authenticate using $biometricType to proceed',
            options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: true,
              sensitiveTransaction: true,
            ),
          )
          .timeout(
            const Duration(seconds: 60), // Timeout after 60 seconds
            onTimeout: () {
              debugPrint('BiometricHelper: Authentication timeout');
              return false;
            },
          );

      debugPrint('BiometricHelper: Authentication result: $result');
      return result;
    } on PlatformException catch (e) {
      // Handle specific error codes
      debugPrint(
        'BiometricHelper: PlatformException during authentication: ${e.code} - ${e.message}',
      );

      switch (e.code) {
        case auth_error.notAvailable:
          debugPrint('BiometricHelper: Biometric not available');
          break;
        case auth_error.notEnrolled:
          debugPrint('BiometricHelper: No biometric enrolled');
          break;
        case auth_error.lockedOut:
          debugPrint(
            'BiometricHelper: Biometric locked out (too many attempts)',
          );
          break;
        case auth_error.permanentlyLockedOut:
          debugPrint('BiometricHelper: Biometric permanently locked out');
          break;
        default:
          debugPrint('BiometricHelper: Other platform error: ${e.code}');
      }

      return false;
    } on TimeoutException catch (e) {
      debugPrint('BiometricHelper: Authentication timeout: $e');
      return false;
    } catch (e, st) {
      debugPrint(
        'BiometricHelper: Unexpected error during authentication: $e\n$st',
      );
      return false;
    }
  }

  static Future<void> saveCredentials(String email, String password) async {
    try {
      await _storage.write(key: _keyEmail, value: email);
      await _storage.write(key: _keyPassword, value: password);
    } catch (e) {
      debugPrint('BiometricHelper: Error saving credentials: $e');
      rethrow;
    }
  }

  static Future<Map<String, String>?> getCredentials() async {
    try {
      final email = await _storage.read(key: _keyEmail);
      final password = await _storage.read(key: _keyPassword);
      if (email != null && password != null) {
        return {'email': email, 'password': password};
      }
      return null;
    } catch (e) {
      debugPrint('BiometricHelper: Error reading credentials: $e');
      return null;
    }
  }

  static Future<void> clearCredentials() async {
    try {
      await _storage.delete(key: _keyEmail);
      await _storage.delete(key: _keyPassword);
      await _storage.delete(key: _keyBiometricEnabled);
    } catch (e) {
      debugPrint('BiometricHelper: Error clearing credentials: $e');
      rethrow;
    }
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _storage.write(
        key: _keyBiometricEnabled,
        value: enabled.toString(),
      );
    } catch (e) {
      debugPrint('BiometricHelper: Error setting biometric enabled: $e');
      rethrow;
    }
  }

  static Future<bool> isBiometricEnabled() async {
    try {
      final val = await _storage.read(key: _keyBiometricEnabled);
      return val == 'true';
    } catch (e) {
      debugPrint('BiometricHelper: Error reading biometric enabled: $e');
      return false;
    }
  }
}
