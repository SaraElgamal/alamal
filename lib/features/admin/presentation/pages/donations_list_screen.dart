import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/widgets/card_widget.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:charity_app/core/widgets/custom_dialog.dart'; // Import Custom Dialog

import 'package:charity_app/core/widgets/custom_loading.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/empty_widget.dart';
import 'package:charity_app/core/widgets/text_form_filed_widget.dart';
import 'package:charity_app/features/admin/data/models/donation_model.dart';
import 'package:charity_app/features/admin/presentation/cubit/admin_donations_cubit.dart';
import 'package:open_file/open_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';

class DonationsListScreen extends StatefulWidget {
  const DonationsListScreen({super.key});

  @override
  State<DonationsListScreen> createState() => _DonationsListScreenState();
}

class _DonationsListScreenState extends State<DonationsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AdminDonationsCubit(FirebaseFirestore.instance)..loadDonations(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: context.colors.scaffoldBackground,
            body: Column(
              children: [
                CustomAppHeader(
                  title: 'المتبرعين',
                  showBackButton: true,
                  onBack: () => context.pop(),
                  actions: [
                    CardWidget(
                      height: 40.h,
                      width: 40.w,
                      radius: 8.r,
                  margin: EdgeInsets.only(left: AppSize.sW16),
                      child: InkWell(
                        onTap: () =>  _showExportDialog(context),
                        child: Image.asset(
                          'assets/images/xls.png',
                          width: 32.w,
                          height: 32.h,
                        ),
                      ),
                    ),
                
                  ],
                ),
                _buildSearchBar(context),
                Expanded(
                  child: BlocConsumer<AdminDonationsCubit, AdminDonationsState>(
                    listener: (context, state) {
                      if (state.status == AdminDonationsStatus.excelExported &&
                          state.excelPath != null) {
                           OpenFile.open(state.excelPath);
                      }
                      if (state.status == AdminDonationsStatus.error &&
                          state.errorMessage != null) {
                        MessageUtils.showError(
                          state.errorMessage!,
                          context: context,
                        );
                      }
                      if (state.deleteSuccessMessage != null) {
                        MessageUtils.showSuccess(
                          state.deleteSuccessMessage!,
                          context: context,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.status == AdminDonationsStatus.loading) {
                        return CustomLoading.showLoadingView(context);
                      }

                      final displayDonations = state.isFiltering
                          ? state.filteredDonations
                          : state.donations;

                      if (displayDonations.isEmpty) {
                        return const Center(
                          child: EmptyWidget(title: 'لا توجد تبرعات مسجلة'),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await context
                              .read<AdminDonationsCubit>()
                              .loadDonations();
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.all(AppSize.sW16),
                          itemCount: displayDonations.length,
                          itemBuilder: (context, index) {
                            return _buildDonationCard(
                              context,
                              displayDonations[index],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.sW16),
      child: TextFormFieldWidget(
        controller: _searchController,
        label: 'بحث باسم المتبرع أو رقم الهاتف',
        onChanged: (value) {
          context.read<AdminDonationsCubit>().searchDonations(value);
        },
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showCustomDialog(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('تصدير البيانات', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12.h),
          const Text(
            'سيتم تحميل ملف Excel يحتوي على كافة بيانات المتبرعين. هل تريد المتابعة؟',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                ),
                onPressed: () {
                  context.pop(); // Close confirm dialog
                  _showProgressDialog(context); // Show progress logic
                },
                child: const Text(
                  'نعم، تحميل',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProgressDialog(BuildContext context) {
    final cubit = context.read<AdminDonationsCubit>();
    final stream = cubit.exportDonations();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StreamBuilder<double>(
          stream: stream,
          builder: (context, snapshot) {
            double progress = snapshot.data ?? 0.0;
            bool isComplete = progress >= 100;

            if (isComplete) {
              // If complete, close after short delay
              Future.delayed(const Duration(milliseconds: 500), () {
                if (dialogContext.mounted && Navigator.canPop(dialogContext)) {
                  Navigator.pop(dialogContext); // Close progress dialog
                }
              });
            }

            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(isComplete ? 'تم التحميل بنجاح!' : 'جارٍ التحميل...'),
                  SizedBox(height: 16.h),
                  LinearProgressIndicator(value: progress / 100),
                  SizedBox(height: 8.h),
                  Text('${progress.toInt()}%'),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDonationCard(BuildContext context, DonationModel donation) {
    final currencyFormatter = NumberFormat.currency(
      symbol: 'ج.م',
      decimalDigits: 0,
      locale: 'ar',
    );

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CardWidget(
        padding: EdgeInsets.all(16.w),
        isShadow: true,
        backgroundColor: context.colors.white.withOpacity(0.1),
        borderColor: context.colors.primary.withValues(alpha: 0.1),
        onClick: () {
          context.push(AppRoutes.donationDetails, extra: donation);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  donation.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: context.colors.text,
                  ),
                ),
                Text(
                  currencyFormatter.format(donation.amount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/whatsApp.svg',
                  width: 24.w,
                  height: 24.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  donation.phone,
                  style: TextStyle(color: context.colors.textSubtle),
                ),
                const Spacer(),
                Text(
                  DateFormat('yyyy/MM/dd').format(donation.date),
                  style: TextStyle(
                    color: context.colors.textSubtle,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            if (donation.description != null &&
                donation.description!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                donation.description!,
                style: TextStyle(
                  color: context.colors.textSubtle,
                  fontSize: 13.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: 8.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDeleteDonation(context, donation),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteDonation(BuildContext context, DonationModel donation) {
    showCustomDialog(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('حذف التبرع', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text('هل أنت متأكد من حذف تبرع ${donation.name}؟'),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.error,
                ),
                onPressed: () {
                  context.read<AdminDonationsCubit>().deleteDonation(
                    donation.id,
                  );
                  context.pop();
                },
                child: const Text('حذف', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
