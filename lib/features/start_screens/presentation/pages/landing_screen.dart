import 'package:animate_do/animate_do.dart';
import 'package:charity_app/core/navigation/routes/app_router.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.w),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: BlocBuilder<ThemeCubit, AppThemeMode>(
                      builder: (context, themeMode) {
                        IconData icon;
                        String tooltip;
                  
                        if (themeMode == AppThemeMode.light) {
                          icon = Icons.light_mode;
                          tooltip = 'الوضع الفاتح';
                        } else if (themeMode == AppThemeMode.dark) {
                          icon = Icons.dark_mode;
                          tooltip = 'الوضع الداكن';
                        } else {
                          icon = Icons.brightness_auto;
                          tooltip = 'تلقائي';
                        }
                  
                        return IconButton(
                          icon: Icon(icon, color: Colors.white),
                          onPressed: () {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                          tooltip: tooltip,
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
                FadeInDown(
                  child: Icon(
                    Icons.volunteer_activism,
                    size: 100.w,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24.h),
                FadeInDown(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'جمعية الأمل',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                FadeInDown(
                  delay: const Duration(milliseconds: 400),
                  child: Text(
                    'معاً نصنع الفرق',
                    style: TextStyle(fontSize: 18.sp, color: Colors.white70),
                  ),
                ),
                SizedBox(height: 64.h),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () async {
                      await  AppRouter.router.push(AppRoutes.caseRegistration);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text('تسجيل جديد '),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: OutlinedButton(
                      onPressed: () {
                        context.push(AppRoutes.adminLogin);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white, width: 2.w),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'دخول الإدارة',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
