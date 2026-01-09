import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/url_launcher_helper.dart';
import 'package:charity_app/core/widgets/card_widget.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:charity_app/features/admin/data/models/donation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DonationDetailsScreen extends StatelessWidget {
  final DonationModel donation;

  const DonationDetailsScreen({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffoldBackground,
      body: Column(
        children: [
          CustomAppHeader(
            title: 'تفاصيل التبرع',
            showBackButton: true,
            onBack: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.sW16),
              child: Column(
                children: [
                  _buildDonorInfoCard(context),
                  SizedBox(height: 16.h),
                  _buildDonationDetailsCard(context),
                  SizedBox(height: 16.h),
                  if (donation.description != null &&
                      donation.description!.isNotEmpty)
                    _buildDescriptionCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonorInfoCard(BuildContext context) {
    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 40.sp,
              color: context.colors.primary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            donation.name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: context.colors.text,
            ),
          ),
          SizedBox(height: 8.h),
          InkWell(
            onTap: () => UrlLauncherHelper.openPhone(phone: donation.phone),
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: context.colors.scaffoldBackground,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.phone,
                    size: 16.sp,
                    color: context.colors.textSubtle,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    donation.phone,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: context.colors.textSubtle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                context,
                icon: Icon(Icons.call, color: Colors.green.shade700, size: 24.sp),
                label: 'اتصال',
                color: Colors.green,
                onTap: () => UrlLauncherHelper.openPhone(phone: donation.phone),
              ),
              SizedBox(width: 16.w),
              _buildActionButton(
                context,
                icon: SvgPicture.asset(
                  'assets/icons/whatsApp.svg',
                  width: 24.w,
                  height: 24.h,
                ),
                label: 'واتساب',
                color: Colors.green.shade700,
                onTap: () =>
                    UrlLauncherHelper.openWhatsApp(phone: donation.phone),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonationDetailsCard(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: 'ج.م',
      decimalDigits: 0,
      locale: 'ar',
    );

    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'بيانات التبرع',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: context.colors.text,
            ),
          ),
          Divider(height: 24.h, color: context.colors.divider),

          _buildInfoRow(
            context,
            icon: Icons.monetization_on,
            label: 'المبلغ',
            value: currencyFormatter.format(donation.amount),
            valueColor: Colors.green,
            isBold: true,
            valueSize: 24.sp,
          ),
          Divider(height: 24.h, color: context.colors.divider),

          _buildInfoRow(
            context,
            icon: Icons.calendar_today,
            label: 'التاريخ',
            value: DateFormat(
              'yyyy/MM/dd - hh:mm a',
              'en',
            ).format(donation.date),
          ),
          Divider(height: 24.h, color: context.colors.divider),

          _buildInfoRow(
            context,
            icon: Icons.category,
            label: 'نوع التبرع',
            value: _getDonationTypeName(donation.donationType),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard(BuildContext context) {
    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notes, color: context.colors.primary),
              SizedBox(width: 8.w),
              Text(
                'ملاحظات / وصف',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.text,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            donation.description!,
            style: TextStyle(
              fontSize: 16.sp,
              height: 1.5,
              color: context.colors.text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
    double? valueSize,
  }) {
    return Row(
      children: [
        Icon(icon, color: context.colors.textSubtle, size: 20.sp),
        SizedBox(width: 12.w),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: context.colors.textSubtle),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: valueSize ?? 16.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? context.colors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required Widget icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDonationTypeName(int type) {
    // Assuming simple mapping for now. Can be updated based on actual enum or map
    switch (type) {
      case 0:
        return 'مالي';
      case 1:
        return 'عيني';
      case 2:
        return 'صدقة جارية';
      default:
        return 'أخرى';
    }
  }
}
