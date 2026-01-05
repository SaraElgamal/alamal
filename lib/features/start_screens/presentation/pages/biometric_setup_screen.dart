import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/biometric_helper.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BiometricSetupScreen extends StatefulWidget {
  final String email;
  final String password;

  const BiometricSetupScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  Future<void> _enableBiometric() async {
    try {
      final authenticated = await BiometricHelper.authenticate();
      if (authenticated) {
        await BiometricHelper.saveCredentials(widget.email, widget.password);
        await BiometricHelper.setBiometricEnabled(true);
        if (mounted) {
          MessageUtils.showSuccess('تم تفعيل الدخول بالبصمة بنجاح');
          context.go(AppRoutes.adminDashboard);
        }
      } else {
        if (mounted) {
          MessageUtils.showError('فشل التحقق من البصمة');
        }
      }
    } catch (e) {
      if (mounted) {
        MessageUtils.showError('حدث خطأ أثناء تفعيل البصمة');
      }
    }
  }

  void _skip() {
    context.go(AppRoutes.adminDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                Icons.fingerprint,
                size: 100.sp,
                color: context.colors.primary,
              ),
              SizedBox(height: 50.h),
              Center(
                child: LoadingButton(
                  title: 'تفعيل الآن',
                  onTap: _enableBiometric,
                  color: context.colors.primary,
                  textColor: Colors.white,
                  borderRadius: AppRadius.bR12,
                  height: 50.h,
                ),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: _skip,
                child: Text(
                  'تخطي',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.colors.textSubtle,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
