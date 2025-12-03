import 'package:charity_app/core/helpers/biometric_helper.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('دخول الإدارة')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              LoadingButton(
                title: 'دخول',
                onTap: () => _login(),
                borderRadius: 8,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
