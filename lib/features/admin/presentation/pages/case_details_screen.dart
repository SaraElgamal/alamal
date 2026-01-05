import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/helpers/url_launcher_helper.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/widgets/card_widget.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../user/data/models/case_model.dart';

class CaseDetailsScreen extends StatelessWidget {
  final CaseModel caseEntity;
  final bool showEditAction;

  const CaseDetailsScreen({
    super.key,
    required this.caseEntity,
    this.showEditAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.scaffoldBackground,
      body: Column(
        children: [
          CustomAppHeader(
            title: 'تفاصيل الحالة',
            showBackButton: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSize.sW16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Basic Information Section
                  _buildBasicInfoCard(context),
                  SizedBox(height: AppSize.sH16),

                  // Spouse Information (if exists)
                  if (caseEntity.spouse != null) ...[
                    _buildSpouseInfoCard(context),
                    SizedBox(height: AppSize.sH16),
                  ],

                  // Family Members Section
                  if (caseEntity.familyMembers.isNotEmpty) ...[
                    _buildFamilyMembersCard(context),
                    SizedBox(height: AppSize.sH16),
                  ],

                  // Financial Overview
                  _buildFinancialOverviewCard(context),
                  SizedBox(height: AppSize.sH16),

                  // Expenses Breakdown
                  _buildExpensesCard(context),
                  SizedBox(height: AppSize.sH16),

                  // Aid History
                  if (caseEntity.aidHistory.isNotEmpty) ...[
                    _buildAidHistoryCard(context),
                    SizedBox(height: AppSize.sH16),
                  ],

                  // Additional Info
                  _buildAdditionalInfoCard(context),
                  SizedBox(height: AppSize.sH24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Basic Information Card
  Widget _buildBasicInfoCard(BuildContext context) {
    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.person,
                  color: context.colors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'البيانات الأساسية لمقدم الطلب',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.sH16),
          _buildInfoItem(
            context,
            icon: Icons.badge,
            label: 'الاسم',
            value: caseEntity.applicant.name,
          ),
          Divider(
            color: context.colors.divider,
          ),
          _buildInfoItem(
            context,
            icon: Icons.credit_card,
            label: 'الرقم القومي',
            value: caseEntity.applicant.nationalId,
            onCopy: () =>
                _copyToClipboard(context, caseEntity.applicant.nationalId),
          ),
            Divider(
            color: context.colors.divider,
          ),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  icon: Icons.cake,
                  label: 'السن',
                  value: '${caseEntity.applicant.age} سنة',
                ),
              ),
              
              SizedBox(width: 8.w),
              Expanded(
                child: _buildInfoItem(
                  context,
                  icon: Icons.work,
                  label: 'المهنة',
                  value: caseEntity.applicant.profession,
                ),
              ),
            ],
          ),
            Divider(
            color: context.colors.divider,
          ),
          _buildInfoItem(
            context,
            icon: Icons.attach_money,
            label: 'الدخل الشهري',
            value: _formatCurrency(caseEntity.applicant.income),
            valueColor: Colors.green,
          ),
            Divider(
            color: context.colors.divider,
          ),
          _buildPhoneItem(context, caseEntity.applicant.phone),
            Divider(
            color: context.colors.divider,
          ),
          if (caseEntity.applicant.address != null &&
              caseEntity.applicant.address!.isNotEmpty)
            _buildInfoItem(
              context,
              icon: Icons.location_on,
              label: 'العنوان',
              value: caseEntity.applicant.address!,
            ),
        ],
      ),
    );
  }

  // Spouse Information Card
  Widget _buildSpouseInfoCard(BuildContext context) {
    final spouse = caseEntity.spouse!;
    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.family_restroom_sharp,
                  color: context.colors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'بيانات الزوج/الزوجة',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.sH16),
          _buildInfoItem(
            context,
            icon: Icons.badge,
            label: 'الاسم',
            value: spouse.name,
          ),
          _buildInfoItem(
            context,
            icon: Icons.credit_card,
            label: 'الرقم القومي',
            value: spouse.nationalId,
          ),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  icon: Icons.cake,
                  label: 'السن',
                  value: '${spouse.age} سنة',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildInfoItem(
                  context,
                  icon: Icons.work,
                  label: 'المهنة',
                  value: spouse.profession,
                ),
              ),
            ],
          ),
          _buildInfoItem(
            context,
            icon: Icons.attach_money,
            label: 'الدخل الشهري',
            value: _formatCurrency(spouse.income),
            valueColor: Colors.green,
          ),
          _buildPhoneItem(context, spouse.phone),
        ],
      ),
    );
  }

  // Family Members Card
  Widget _buildFamilyMembersCard(BuildContext context) {
    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.groups,
                  color: context.colors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'أفراد الأسرة',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${caseEntity.familyMembers.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.sH16),
          ...caseEntity.familyMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.colors.scaffoldBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: context.colors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: context.colors.primary,
                        radius: 16.r,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          member.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallInfo(
                          context,
                          icon: Icons.cake,
                          value: '${member.age} سنة',
                        ),
                      ),
                      Expanded(
                        child: _buildSmallInfo(
                          context,
                          icon: Icons.work,
                          value: member.profession,
                        ),
                      ),
                      Expanded(
                        child: _buildSmallInfo(
                          context,
                          icon: Icons.attach_money,
                          value: _formatCurrency(member.income),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Financial Overview Card
  Widget _buildFinancialOverviewCard(BuildContext context) {
    final totalIncome = caseEntity.manualTotalFamilyIncome;
    final totalExpenses = caseEntity.expenses.total;
    final remaining = totalIncome - totalExpenses;
    final isPositive = remaining >= 0;

    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: context.colors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'نظرة مالية',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.sH16),
          _buildFinancialSummaryItem(
            context,
            icon: Icons.trending_up,
            label: 'إجمالي الدخل الشهري',
            value: _formatCurrency(totalIncome),
            color: Colors.green,
          ),
          SizedBox(height: 12.h),
          _buildFinancialSummaryItem(
            context,
            icon: Icons.trending_down,
            label: 'إجمالي المصروفات الشهرية',
            value: _formatCurrency(totalExpenses),
            color: Colors.orange,
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isPositive ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPositive ? Icons.check_circle : Icons.warning,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPositive ? 'فائض شهري' : 'عجز شهري',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: context.colors.textSubtle,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _formatCurrency(remaining.abs()),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(caseEntity.caseDescription.isNotEmpty)...[
          SizedBox(height: 16.h),
          _buildInfoItem(
            context,
            icon: Icons.description,
            label: 'وصف الحالة',
            value: caseEntity.caseDescription,
          ),],
        ],
      ),
    );
  }

  // Expenses Breakdown Card
  Widget _buildExpensesCard(BuildContext context) {
    final expenses = caseEntity.expenses;
    final totalExpenses = expenses.total;

    final expenseItems = [
      {'icon': Icons.home, 'label': 'الإيجار', 'value': expenses.rent},
      {
        'icon': Icons.lightbulb,
        'label': 'الكهرباء',
        'value': expenses.electricity,
      },
      {'icon': Icons.water_drop, 'label': 'المياه', 'value': expenses.water},
      {
        'icon': Icons.local_fire_department,
        'label': 'الغاز',
        'value': expenses.gas,
      },
      {'icon': Icons.school, 'label': 'التعليم', 'value': expenses.education},
      {
        'icon': Icons.medical_services,
        'label': 'العلاج',
        'value': expenses.treatment,
      },
      {
        'icon': Icons.credit_card,
        'label': 'سداد الديون',
        'value': expenses.debtRepayment,
      },
      {'icon': Icons.more_horiz, 'label': 'أخرى', 'value': expenses.other},
    ];

    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.receipt_long,
                  color: context.colors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'تفصيل المصروفات',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.sH16),
          ...expenseItems.map((item) {
            final value = item['value'] as double;
            if (value <= 0) return const SizedBox.shrink();

            final percentage = totalExpenses > 0
                ? (value / totalExpenses)
                : 0.0;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 20.sp,
                        color: context.colors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item['label'] as String,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        _formatCurrency(value),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${(percentage * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: context.colors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: context.colors.primary.withValues(
                        alpha: 0.1,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      minHeight: 6.h,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Aid History Card
  Widget _buildAidHistoryCard(BuildContext context) {
    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.card_giftcard,
                  color: context.colors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'سجل المساعدات',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${caseEntity.aidHistory.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.sH16),
          ...caseEntity.aidHistory.map((aid) {
            return Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.colors.scaffoldBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.volunteer_activism,
                      color: Colors.green,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getAidTypeName(aid.type),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          DateFormat('dd/MM/yyyy').format(aid.date),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: context.colors.textSubtle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatCurrency(aid.value),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Additional Info Card
  Widget _buildAdditionalInfoCard(BuildContext context) {
    return CardWidget(
      isShadow: true,
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.info,
                  color: context.colors.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'معلومات إضافية',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.sH16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  icon: Icons.restaurant,
                  label: 'عدد كروت التموين',
                  value: '${caseEntity.rationCardCount}',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildInfoItem(
                  context,
                  icon: Icons.elderly,
                  label: 'عدد المعاشات',
                  value: '${caseEntity.pensionCount}',
                ),
              ),
            ],
          ),
          _buildInfoItem(
            context,
            icon: Icons.calendar_today,
            label: 'تاريخ التسجيل',
            value: DateFormat(
              'dd/MM/yyyy - hh:mm a',
            ).format(caseEntity.createdAt),
          ),
        ],
      ),
    );
  }

  // Helper: Build Info Item
  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    VoidCallback? onCopy,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: context.colors.textSubtle),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: context.colors.textSubtle,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
          if (onCopy != null)
            IconButton(
              icon: Icon(
                Icons.copy,
                size: 18.sp,
                color: context.colors.primary,
              ),
              onPressed: onCopy,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  // Helper: Build Phone Item
  Widget _buildPhoneItem(BuildContext context, String phone) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h,top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.phone, size: 20.sp, color: context.colors.textSubtle),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رقم الهاتف',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: context.colors.textSubtle,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            child: CardWidget(
              radius: 50.r,
              height: 30.h,
              width: 30.w,
              backgroundColor: context.colors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.phone_outlined, size: 20.sp, color: Colors.green)),
            onTap: () => UrlLauncherHelper.openPhone(phone: phone),
           
          ),
          SizedBox(width: 30.w),
          InkWell(
            onTap: () => UrlLauncherHelper.openWhatsApp(phone: phone),
            child: SvgPicture.asset('assets/icons/whatsApp.svg', height: 30.h,
              width: 30.w,)),
      
        ],
      ),
    );
  }

  // Helper: Build Small Info
  Widget _buildSmallInfo(
    BuildContext context, {
    required IconData icon,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: context.colors.textSubtle),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 12.sp, color: context.colors.textSubtle),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Helper: Build Financial Summary Item
  Widget _buildFinancialSummaryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.colors.textSubtle,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Format Currency
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00', 'ar');
    return '${formatter.format(amount)} ج.م';
  }

  // Helper: Copy to Clipboard
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم النسخ'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  // Helper: Get Aid Type Name
  String _getAidTypeName(dynamic type) {
    final typeString = type.toString().split('.').last;
    switch (typeString) {
      case 'monthly':
        return 'مساعدة شهرية';
      case 'financial':
        return 'مساعدة مالية';
      case 'inkind':
        return 'مساعدة عينية';
      case 'urgent':
        return 'مساعدة عاجلة';
      default:
        return typeString;
    }
  }
}
