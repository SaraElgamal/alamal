import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class FullScreenLoadingManager extends StatefulWidget {
  final Widget child;
  const FullScreenLoadingManager({super.key, required this.child});

  @override
  State<FullScreenLoadingManager> createState() => _FullScreenLoadingManagerState();

  static void show() {
    _FullScreenLoadingManagerState._isLoading.value = true;
  }

  static void hide() {
    _FullScreenLoadingManagerState._isLoading.value = false;
  }
}

class _FullScreenLoadingManagerState extends State<FullScreenLoadingManager> {
  static final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        widget.child,
        ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (context, value, child) {
              return Visibility(
                  visible: _isLoading.value,
                  child: Container(
                      height: 1.sh,
                      width: 1.sw,
                      color: context.colors.grey,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: NavigationService.currentContext!.colors.primary,
                          size: AppSize.sH50,
                        ),
                      )));
            }),
      ],
    );
  }
}
