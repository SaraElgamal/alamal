import 'package:charity_app/core/helpers/url_launcher_helper.dart';
import 'package:charity_app/core/navigation/navigation.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Celebration animation in the background
          Positioned.fill(
            child: Center(
              child: Lottie.asset(
                height: 500.h,width: 300.h,
                'assets/animation/Success celebration.json',
                repeat: false,
                //fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Main success animation
                  Lottie.asset(
                    'assets/animation/Success.json',
                    width: 200.w,
                    height: 200.h,
                    repeat: false,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'تم التسجيل بنجاح!',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'بياناتك تسجلت بنجاح ووصلتنا وإن شاء الله سيتم التواصل معك قريباً',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  // Facebook link
                  InkWell(
                    onTap: () => UrlLauncherHelper.openUrl(
                      url:
                          'https://www.facebook.com/alamalaweshelhagar/about?locale=ar_AR', 
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.facebook,
                            color: const Color(0xFF1877F2),
                            size: 24.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'تابعنا على فيسبوك',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1877F2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // New Registration button
                  LoadingButton(
                    onTap: () async {
                      context.pushReplacement(AppRoutes.caseRegistration);
                    },
                    title: 'تسجيل جديد',
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
