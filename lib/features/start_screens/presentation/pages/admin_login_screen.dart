import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../admin/presentation/pages/admin_dashboard_screen.dart';
import '../../../../core/widgets/custom_text_form_field.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    
    // Email regex pattern
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

  Future<void> _login() async {
      Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
          );
    // if (_formKey.currentState!.validate()) {
    //   setState(() => _isLoading = true);
    //   try {
    //     await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: _emailController.text.trim(),
    //       password: _passwordController.text,
    //     );
    //     if (mounted) {
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
    //       );
    //     }
    //   } on FirebaseAuthException catch (e) {
    //     if (mounted) {
    //       String errorMessage = 'حدث خطأ في تسجيل الدخول';
          
    //       if (e.code == 'user-not-found') {
    //         errorMessage = 'لا يوجد حساب بهذا البريد الإلكتروني';
    //       } else if (e.code == 'wrong-password') {
    //         errorMessage = 'كلمة المرور غير صحيحة';
    //       } else if (e.code == 'invalid-email') {
    //         errorMessage = 'البريد الإلكتروني غير صحيح';
    //       } else if (e.code == 'user-disabled') {
    //         errorMessage = 'هذا الحساب معطل';
    //       } else if (e.code == 'too-many-requests') {
    //         errorMessage = 'محاولات كثيرة. يرجى المحاولة لاحقاً';
    //       }
          
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(errorMessage),
    //           backgroundColor: Colors.red,
    //           behavior: SnackBarBehavior.floating,
    //         ),
    //       );
    //     }
    //   } finally {
    //     if (mounted) setState(() => _isLoading = false);
    //   }
    // }
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('دخول'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
