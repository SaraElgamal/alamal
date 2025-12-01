import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<T?> showDefaultBottomSheet<T>({BuildContext? context, required Widget child}) {
  return showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context ?? NavigationService.navigatorKey.currentContext!,
    builder: (context) => DefaultSheetBody(child: child),
  );
}

class DefaultSheetBody extends StatelessWidget {
  final Widget child;
  const DefaultSheetBody({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              color: context.colors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: 1.sw,
                padding: EdgeInsets.only(
                  bottom: ScreenUtil().bottomBarHeight == 0 ? 20.h : ScreenUtil().bottomBarHeight,
                  left: 20.w,
                  right: 20.w,
                  top: 15.h,
                ),
                child: Wrap(
                  children: [
                    const Align(
                      alignment: Alignment.center,
                    ),
                  //  15.szH,
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
