import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

abstract class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();
  static const _storage = FlutterSecureStorage();
  static const _keyEmail = 'admin_email';
  static const _keyPassword = 'admin_password';
  static const _keyBiometricEnabled = 'biometric_enabled';

  /// Checks if the device supports any biometric authentication.
  static Future<bool> isBiometricSupported() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// Attempts to authenticate the user and returns true upon success.
  static Future<bool> authenticate() async {
    try {
      if (!await isBiometricSupported()) return false;

      final List<BiometricType> available = await _auth
          .getAvailableBiometrics();

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

      return await _auth.authenticate(
        localizedReason: 'Authenticate using $biometricType to proceed',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e, st) {
      debugPrint('Biometric auth error: $e\n$st');
      return false;
    }
  }

  static Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyPassword, value: password);
  }

  static Future<Map<String, String>?> getCredentials() async {
    final email = await _storage.read(key: _keyEmail);
    final password = await _storage.read(key: _keyPassword);
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  static Future<void> clearCredentials() async {
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyPassword);
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _keyBiometricEnabled, value: enabled.toString());
  }

  static Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: _keyBiometricEnabled);
    return val == 'true';
  }
}
