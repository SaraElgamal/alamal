import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:charity_app/core/widgets/text_form_filed_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Re-authenticate user
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(_newPasswordController.text);

      if (mounted) {
        MessageUtils.showSuccess(
          'تم تغيير كلمة المرور بنجاح',
          context: context,
        );
        context.pop();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'حدث خطأ يرجى ادخال كلمة السر القديمه بشكل صحيح والمحاولة مره اخرى';
        if (e.code == 'wrong-password') {
          message = 'كلمة المرور الحالية غير صحيحة';
        } else if (e.code == 'weak-password') {
          message = 'كلمة المرور الجديدة ضعيفة';
        } else if (e.code == 'requires-recent-login') {
          message = 'يرجى تسجيل الدخول مرة أخرى';
        }
        MessageUtils.showError(message, context: context);
      }
    } catch (e) {
      if (mounted) {
        MessageUtils.showError('حدث خطأ غير متوقع', context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppHeader(
            title: 'تغيير كلمة المرور',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.sW16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    TextFormFieldWidget(
                      controller: _currentPasswordController,
                      label: 'كلمة المرور الحالية',
                      prefixIcon: const Icon(Icons.lock_outline),
                      isPassword: _obscureCurrent,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrent
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مطلوب';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextFormFieldWidget(
                      controller: _newPasswordController,
                      label: 'كلمة المرور الجديدة',
                      prefixIcon: const Icon(Icons.lock_outline),
                      isPassword: _obscureNew,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNew ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _obscureNew = !_obscureNew),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مطلوب';
                        }
                        if (value.length < 6) {
                          return 'يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextFormFieldWidget(
                      controller: _confirmPasswordController,
                      label: 'تأكيد كلمة المرور الجديدة',
                      prefixIcon: const Icon(Icons.lock_outline),
                      isPassword: _obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مطلوب';
                        }
                        if (value != _newPasswordController.text) {
                          return 'كلمة المرور غير متطابقة';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40.h),
                    LoadingButton(
                      margin: EdgeInsets.zero,
                      title: 'تغيير كلمة المرور',
                      onTap: _changePassword,
                      color: context.colors.primary,
                      textColor: Colors.white,
                      borderRadius: 12.r,
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
