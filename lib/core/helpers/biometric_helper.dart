import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

abstract class BiometricHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

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

      final List<BiometricType> available = await _auth.getAvailableBiometrics();

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
      );
    } catch (e, st) {
      debugPrint('Biometric auth error: $e\n$st');
      return false;
    }
  }
}
