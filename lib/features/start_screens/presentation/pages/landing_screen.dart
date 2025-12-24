import 'package:animate_do/animate_do.dart';
import 'package:charity_app/core/helpers/cache_service.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:charity_app/core/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  bool _hasDraft = false;

  @override
  void initState() {
    super.initState();
    _checkDraft();
  }

  Future<void> _checkDraft() async {
    final draft = CacheStorage.read('case_draft');
    setState(() {
      _hasDraft = draft != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Stack(
            children: [
              ClipPath(
                clipper: LandingHeaderClipper(),
                child: Image.asset(
                  'assets/images/backlogo.png',
                  height: 400.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  color: context.colors.primary.withOpacity(0.1),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              ClipPath(
                clipper: LandingHeaderClipper(),
                child: Container(
                  height: 400.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50.h, right: 16.w, left: 16.w),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: Colors.white.withOpacity(0.2),
                      //     shape: BoxShape.circle,
                      //   ),
                      //   child: BlocBuilder<ThemeCubit, AppThemeMode>(
                      //     builder: (context, themeMode) {
                      //       IconData icon;
                      //       if (themeMode == AppThemeMode.light) {
                      //         icon = Icons.light_mode;
                      //       } else if (themeMode == AppThemeMode.dark) {
                      //         icon = Icons.dark_mode;
                      //       } else {
                      //         icon = Icons.brightness_auto;
                      //       }
                      //       return IconButton(
                      //         icon: Icon(icon, color: Colors.white),
                      //         onPressed: () {
                      //           context.read<ThemeCubit>().toggleTheme();
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  CardWidget(
                    height: 50.h,
                    width: 50.w,
                    radius: 8.r,
                    backgroundColor: context.colors.primary5.withValues(
                      alpha: 0.2,
                    ),
                    child: Icon(
                      Icons.energy_savings_leaf_outlined,
                      color: context.colors.primary,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'جمعية الأمل',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: context.colors.primary,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  FadeInDown(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      'معاً نصنع الفرق ونبني مستقبلاً أفضل للجميع بلمسة إنسانية وعطاء لا ينتهي.',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: context.colors.black50,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    child: LoadingButton(
                      onTap: () async {
                        context.push(AppRoutes.caseRegistration).then((_) {
                          if (mounted) _checkDraft();
                        });
                      },
                      title: _hasDraft ? 'استكمال البيانات' : 'تسجيل جديد',
                      customChild: Text(
                        _hasDraft ? 'استكمال البيانات' : 'تسجيل جديد',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: LoadingButton(
                      title: 'دخول الإدارة',
                      onTap: () async {
                        await context.push(AppRoutes.adminLogin);
                      },
                      color: context.colors.background,
                      borderSide: BorderSide(color: context.colors.primary),
                      customChild: Text(
                        'دخول الإدارة',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
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

class LandingHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(
      0,
      size.height - 50,
    ); // Start slightly above the bottom-left corner

    // Create a quadratic bezier curve
    var firstControlPoint = Offset(
      size.width / 2,
      size.height + 20,
    ); // Control point below the image
    var firstEndPoint = Offset(
      size.width,
      size.height - 50,
    ); // End point slightly above the bottom-right corner

    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    path.lineTo(size.width, 0); // Line to top-right
    path.close(); // Close the path to top-left
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
