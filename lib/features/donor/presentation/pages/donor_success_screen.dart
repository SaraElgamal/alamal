import 'package:charity_app/core/helpers/url_launcher_helper.dart';
import 'package:charity_app/core/navigation/navigation.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class DonorSuccessScreen extends StatelessWidget {
  const DonorSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Center(
              child: Lottie.asset(
                height: 500.h,
                width: 300.h,
                'assets/animation/Success celebration.json',
                repeat: false,
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
                  Lottie.asset(
                    'assets/animation/Success.json',
                    width: 200.w,
                    height: 200.h,
                    repeat: false,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'شكراً لعطائك!',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'تم تسجيل تبرعك بنجاح. جزاك الله خيراً وجعله في ميزان حسناتك',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
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
                  LoadingButton(
                    onTap: () async {
                      context.go(AppRoutes.landing);
                    },
                    title: 'العودة للرئيسية',
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
