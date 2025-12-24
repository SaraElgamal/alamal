import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WizardNavigationBar extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback? onBack;
  final bool isLastStep;
  final bool isFirstStep;

  const WizardNavigationBar({
    super.key,
    required this.onNext,
    this.onBack,
    this.isLastStep = false,
    this.isFirstStep = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: LoadingButton(
              margin: EdgeInsets.zero,
              onTap: () async => onNext(),
              title: isLastStep ? 'تأكيد وإرسال' : 'التالي',
              customChild: Text(
                isLastStep ? 'تأكيد وإرسال' : 'التالي',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (!isFirstStep) ...[
            SizedBox(height: 15.h),
            LoadingButton(
              margin: EdgeInsets.zero,
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              title: 'السابق',
              color: context.colors.background,
              onTap: () async => onBack?.call(),
              customChild: Text(
                'السابق',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
