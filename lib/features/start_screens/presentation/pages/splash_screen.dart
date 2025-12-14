import 'package:animate_do/animate_do.dart';
import 'package:charity_app/core/helpers/cache_service.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    // Artificial delay for splash effect
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final onboardingSeen =
        CacheStorage.read('onboarding_seen') as bool? ?? false;

    if (onboardingSeen) {
      context.go(AppRoutes.landing);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ZoomIn(
          duration: const Duration(seconds: 1),
          child: Image.asset(
            'assets/images/logo.png',
            width: 350.w,
            height: 350.h,
          ),
        ),
      ),
    );
  }
}
