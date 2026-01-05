import 'package:animate_do/animate_do.dart';
import 'package:charity_app/core/config/res/color_manager.dart';
import 'package:charity_app/core/helpers/biometric_helper.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:charity_app/core/widgets/card_widget.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkBiometricLogin();
  }

  Future<void> _checkBiometricLogin() async {
    final isEnabled = await BiometricHelper.isBiometricEnabled();
    if (isEnabled) {
      final authenticated = await BiometricHelper.authenticate();
      if (authenticated) {
        final credentials = await BiometricHelper.getCredentials();
        if (credentials != null) {
          _login(
            email: credentials['email'],
            password: credentials['password'],
            isBiometric: true,
          );
        }
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (value.length < 6) {
      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    return null;
  }

  Future<void> _login({
    String? email,
    String? password,
    bool isBiometric = false,
  }) async {
    final loginEmail = email ?? _emailController.text.trim();
    final loginPassword = password ?? _passwordController.text;

    if (!isBiometric && !_formKey.currentState!.validate()) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmail,
        password: loginPassword,
      );

      if (mounted) {
        if (isBiometric) {
          context.go(AppRoutes.adminDashboard);
        } else {
          // Check if biometric is supported but not enabled
          final isSupported = await BiometricHelper.isBiometricSupported();
          final isEnabled = await BiometricHelper.isBiometricEnabled();

          if (isSupported && !isEnabled) {
            context.go(
              AppRoutes.biometricSetup,
              extra: {'email': loginEmail, 'password': loginPassword},
            );
          } else {
            context.go(AppRoutes.adminDashboard);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Login Error: ${e.code} - ${e.message}');
      if (mounted) {
        String errorMessage = 'حدث خطأ في تسجيل الدخول';
        if (e.code == 'user-not-found') {
          errorMessage = 'لا يوجد حساب بهذا البريد الإلكتروني';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'كلمة المرور غير صحيحة';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'البريد الإلكتروني غير صحيح';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'هذا الحساب معطل';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'محاولات كثيرة. يرجى المحاولة لاحقاً';
        } else if (e.code == 'invalid-credential') {
          errorMessage = 'بيانات الدخول غير صحيحة';
        } else {
          errorMessage = 'خطأ: ${e.message}';
        }
        MessageUtils.showError(errorMessage, context: context);
      }
    } catch (e) {
      debugPrint('Unexpected Login Error: $e');
      if (mounted) {
        MessageUtils.showError('حدث خطأ غير متوقع: $e', context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('دخول الإدارة')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 300.w,
                    height: 220.h,
                  ),
                ),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    ' مرحبا بك !\n سجل دخولك إلى الإدارة ',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
          
                      color: context.colors.textSubtle,
                      height: 1.5,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  label: 'البريد الإلكتروني',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                CustomTextFormField(
                  label: 'كلمة المرور',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: _validatePassword,
                  suffixIcon: InkWell(
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                SizedBox(height: 32.h),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Center(
                    child: LoadingButton(
                      margin: EdgeInsets.zero,
                      title: 'دخول',
                      onTap: () => _login(),
                      height: 50.h,
                    ),
                  ),
                ),
                 SizedBox(height: 20.h),
                 FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 18.sp,
                        color: context.colors.primary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        ' هذا الجزء خاص بأعضاء جمعية الأمل فقط',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: context.colors.primary,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
               
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
