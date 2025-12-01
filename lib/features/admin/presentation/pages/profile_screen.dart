import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/text_form_filed_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _emailController.text = _auth.currentUser?.email ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      if (_emailController.text == user.email &&
          _passwordController.text.isEmpty) {
        if (mounted) {
          MessageUtils.showSuccess('لم يتم إجراء أي تغييرات', context: context);
          setState(() => _isLoading = false);
        }
        return;
      }

      if (_emailController.text != user.email) {
        await user.verifyBeforeUpdateEmail(_emailController.text);
        if (mounted) {
          MessageUtils.showSuccess(
            'تم إرسال رابط التحقق إلى البريد الإلكتروني الجديد',
            context: context,
          );
        }
      }

      if (_passwordController.text.isNotEmpty) {
        await user.updatePassword(_passwordController.text);
        if (mounted) {
          MessageUtils.showSuccess(
            'تم تحديث كلمة المرور بنجاح',
            context: context,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'حدث خطأ ما';
        if (e.code == 'requires-recent-login') {
          message = 'يرجى تسجيل الدخول مرة أخرى للمتابعة';
        } else if (e.code == 'email-already-in-use') {
          message = 'البريد الإلكتروني مستخدم بالفعل';
        } else if (e.code == 'weak-password') {
          message = 'كلمة المرور ضعيفة';
        }
        MessageUtils.showError(message, context: context);
      }
    } catch (e) {
      if (mounted) {
        MessageUtils.showError('حدث خطأ غير متوقع', context: context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomAppHeader(title: 'الملف الشخصي', showBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.sW16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    TextFormFieldWidget(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مطلوب';
                        }
                        if (!value.contains('@')) {
                          return 'بريد إلكتروني غير صالح';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    TextFormFieldWidget(
                      controller: _passwordController,
                      label: 'كلمة المرور الجديدة',
                      subLabel: 'اتركها فارغة إذا لم ترد تغييرها',
                      prefixIcon: const Icon(Icons.lock_outline),
                      isPassword: true,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length < 6) {
                          return 'يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'حفظ التغييرات',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
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
