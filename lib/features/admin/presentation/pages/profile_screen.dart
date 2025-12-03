import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:charity_app/core/widgets/text_form_filed_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      bool hasChanges = false;

      if (_nameController.text != user.displayName) {
        await user.updateDisplayName(_nameController.text);
        hasChanges = true;
      }

      if (_emailController.text != user.email) {
        await user.verifyBeforeUpdateEmail(_emailController.text);
        if (mounted) {
          MessageUtils.showSuccess(
            'تم إرسال رابط التحقق إلى البريد الإلكتروني الجديد',
            context: context,
          );
        }
        hasChanges = true;
      }

      if (mounted) {
        if (hasChanges) {
          MessageUtils.showSuccess('تم تحديث البيانات بنجاح', context: context);
        } else {
          MessageUtils.showSuccess('لم يتم إجراء أي تغييرات', context: context);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'حدث خطأ ما';
        if (e.code == 'requires-recent-login') {
          message = 'يرجى تسجيل الدخول مرة أخرى للمتابعة';
        } else if (e.code == 'email-already-in-use') {
          message = 'البريد الإلكتروني مستخدم بالفعل';
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
                      controller: _nameController,
                      label: 'الاسم',
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مطلوب';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
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
                    SizedBox(height: 24.h),
                    OutlinedButton(
                      onPressed: () {
                        context.push(AppRoutes.changePassword);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: context.colors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: context.colors.primary,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'تغيير كلمة المرور',
                            style: TextStyle(
                              color: context.colors.primary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    LoadingButton(
                      title: 'حفظ التغييرات',
                      onTap: _updateProfile,
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
