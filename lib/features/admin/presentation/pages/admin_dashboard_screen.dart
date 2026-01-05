import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/theme/theme_cubit.dart';
import 'package:charity_app/core/widgets/card_widget.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:charity_app/core/widgets/custom_dialog.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/custom_loading.dart';
import 'package:charity_app/core/widgets/empty_widget.dart';
import 'package:charity_app/core/widgets/text_form_filed_widget.dart';
import 'package:charity_app/features/admin/presentation/cubit/admin_cases_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import '../../../../injection_container.dart' as di;
import '../cubit/admin_cases_state.dart';
import '../../data/models/case_model.dart' as admin_model;
import '../../../user/data/models/case_model.dart' as user_model;
import '../../../user/data/models/person_model.dart' as user_person;
import '../../../user/data/models/expenses_model.dart' as user_expenses;
import '../../../user/data/models/aid_model.dart' as user_aid;

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AdminCasesCubit? _cubit;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && _cubit != null) {
      _cubit!.loadMoreCases();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _cubit = di.sl<AdminCasesCubit>()..loadCases();
        return _cubit!;
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: context.colors.scaffoldBackground,
            drawer: _buildDrawer(context),
            body: Column(
              children: [
                CustomAppHeader(
                  title: 'إدارة الجمعية',
                  showBackButton: false,
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                      tooltip: 'حذف جميع البيانات',
                      onPressed: () => _confirmDeleteAll(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: Colors.white),
                      tooltip: 'تصدير إلى Excel',
                      onPressed: () {
                        context.read<AdminCasesCubit>().exportToExcel();
                      },
                    ),
                  ],
                ),
                _buildSearchBar(context),
                Expanded(
                  child: BlocConsumer<AdminCasesCubit, AdminCasesState>(
                    listener: (context, state) {
                      if (state.successMessage != null) {
                        MessageUtils.showSuccess(
                          state.successMessage!,
                          context: context,
                        );
                      }
                      if (state.deleteSuccessMessage != null) {
                        MessageUtils.showSuccess(
                          state.deleteSuccessMessage!,
                          context: context,
                        );
                      }
                      if (state.status == AdminCasesStatus.excelExported &&
                          state.excelPath != null) {
                        OpenFile.open(state.excelPath);
                      }
                      if (state.status == AdminCasesStatus.error &&
                          state.errorMessage != null) {
                        MessageUtils.showError(
                          state.errorMessage!,
                          context: context,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state.status == AdminCasesStatus.loading &&
                          state.cases.isEmpty) {
                        return CustomLoading.showLoadingView(context);
                      }

                      final displayCases = state.isFiltering
                          ? state.filteredCases
                          : state.cases;

                      if (displayCases.isEmpty) {
                        return const Center(
                          child: EmptyWidget(title: 'لا توجد حالات مسجلة'),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(AppSize.sW16),
                        itemCount:
                            displayCases.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= displayCases.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomLoading.showDotLoader(),
                              ),
                            );
                          }
                          final caseItem = displayCases[index];
                          return _buildCaseCard(context, caseItem);
                        },
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

  Widget _buildDrawer(BuildContext context) {
    final user = di.sl<FirebaseAuth>().currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // UserAccountsDrawerHeader(
          //   accountName: Text(''),
          //   accountEmail: Text(user?.email ?? 'admin@charity.com'),
          //   // currentAccountPicture: const CircleAvatar(
          //   //   backgroundColor: Colors.white,
          //   //   child: Icon(Icons.person, size: 40),
          //   // ),
          //   decoration: BoxDecoration(color: context.colors.primary),
          // ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('الملف الشخصي'),
            onTap: () {
              context.pop();
              context.push(AppRoutes.profile);
            },
          ),
          // BlocBuilder<ThemeCubit, AppThemeMode>(
          //   builder: (context, themeMode) {
          //     final isDark = themeMode == AppThemeMode.dark;
          //     return ListTile(
          //       leading: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
          //       title: Text(isDark ? 'الوضع الداكن' : 'الوضع الفاتح'),
          //       trailing: Switch(
          //         value: isDark,
          //         onChanged: (value) {
          //           context.read<ThemeCubit>().toggleTheme();
          //         },
          //       ),
          //     );
          //   },
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              context.pop();
              context.go(AppRoutes.landing);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.sW16),
      child: Row(
        children: [
          Expanded(
            child: TextFormFieldWidget(
              controller: _searchController,
              label: 'بحث بالاسم أو الرقم القومي',
              onChanged: (value) {
                context.read<AdminCasesCubit>().searchCases(value);
              },
              prefixIcon: const Icon(Icons.search),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: () => _showFilterBottomSheet(context),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final cubit = context.read<AdminCasesCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) =>
          BlocProvider.value(value: cubit, child: _FilterBottomSheet()),
    );
  }

  Widget _buildCaseCard(BuildContext context, admin_model.CaseModel caseItem) {
    // Determine if case is urgent
    final totalIncome = caseItem.manualTotalFamilyIncome;
    final totalExpenses = caseItem.expenses.total;
    final remaining = totalIncome - totalExpenses;
    final isUrgent = remaining < 0 || totalIncome < 2000;
    final isCritical = remaining < -500 || totalIncome < 1000;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: CardWidget(
        padding: EdgeInsets.all(16.w),
        isShadow: true,
        child: InkWell(
          onTap: () {
            context.push(
              AppRoutes.caseDetails,
              extra: {'case': _mapToUserCaseModel(caseItem), 'showEdit': true},
            );
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Row(
            children: [
              // Urgent Indicator
              if (isUrgent)
                Container(
                  width: 4.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: isCritical ? Colors.red : Colors.orange,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              if (isUrgent) SizedBox(width: 12.w),

              // Main Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with urgent badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            caseItem.applicant.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.colors.primary,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        if (isUrgent)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: isCritical ? Colors.red : Colors.orange,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              isCritical ? 'عاجل' : 'متابعة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // National ID
                    Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          size: 14.sp,
                          color: context.colors.textSubtle,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          caseItem.applicant.nationalId,
                          style: TextStyle(
                            color: context.colors.textSubtle,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Phone
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14.sp,
                          color: context.colors.textSubtle,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          caseItem.applicant.phone,
                          style: TextStyle(
                            color: context.colors.textSubtle,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete Button
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: context.colors.error,
                  size: 20.sp,
                ),
                onPressed: () => _confirmDeleteCase(context, caseItem),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  //   // Determine if case is urgent
  //   final totalIncome = caseItem.manualTotalFamilyIncome;
  //   final totalExpenses = caseItem.expenses.total;
  //   final remaining = totalIncome - totalExpenses;
  //   final isUrgent = remaining < 0 || totalIncome < 2000;
  //   final isCritical = remaining < -500 || totalIncome < 1000;

  //   return Padding(
  //     padding: EdgeInsets.only(bottom: 16.h),
  //     child: CardWidget(
  //       padding: EdgeInsets.zero,
  //       isShadow: true,
  //       child: InkWell(
  //         onTap: () {
  //           context.push(
  //             AppRoutes.caseDetails,
  //             extra: {'case': _mapToUserCaseModel(caseItem), 'showEdit': true},
  //           );
  //         },
  //         borderRadius: BorderRadius.circular(12.r),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             // Header with urgent badge
  //             Container(
  //               padding: EdgeInsets.all(16.w),
  //               decoration: BoxDecoration(
  //                 color: isCritical
  //                     ? Colors.red.withValues(alpha: 0.1)
  //                     : isUrgent
  //                     ? Colors.orange.withValues(alpha: 0.1)
  //                     : Colors.green.withValues(alpha: 0.05),
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(12.r),
  //                   topRight: Radius.circular(12.r),
  //                 ),
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       // Urgent Badge
  //                       if (isUrgent)
  //                         Container(
  //                           padding: EdgeInsets.symmetric(
  //                             horizontal: 8.w,
  //                             vertical: 4.h,
  //                           ),
  //                           decoration: BoxDecoration(
  //                             color: isCritical ? Colors.red : Colors.orange,
  //                             borderRadius: BorderRadius.circular(20.r),
  //                           ),
  //                           child: Row(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               Icon(
  //                                 isCritical
  //                                     ? Icons.report_problem
  //                                     : Icons.warning,
  //                                 color: Colors.white,
  //                                 size: 14.sp,
  //                               ),
  //                               SizedBox(width: 4.w),
  //                               Text(
  //                                 isCritical ? 'عاجل جداً' : 'يحتاج متابعة',
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 11.sp,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       Expanded(
  //                         child: Text(
  //                           caseItem.applicant.name,
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             color: context.colors.primary,
  //                             fontSize: 16.sp,
  //                           ),
  //                           textAlign: isUrgent
  //                               ? TextAlign.left
  //                               : TextAlign.right,
  //                         ),
  //                       ),
  //                       IconButton(
  //                         icon: Icon(
  //                           Icons.delete_outline,
  //                           color: context.colors.error,
  //                           size: 20.sp,
  //                         ),
  //                         onPressed: () =>
  //                             _confirmDeleteCase(context, caseItem),
  //                         padding: EdgeInsets.zero,
  //                         constraints: const BoxConstraints(),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),

  //             // Body with details
  //             Padding(
  //               padding: EdgeInsets.all(16.w),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Quick Info Chips
  //                   Wrap(
  //                     spacing: 8.w,
  //                     runSpacing: 8.h,
  //                     children: [
  //                       _buildInfoChip(
  //                         context,
  //                         icon: Icons.credit_card,
  //                         label: caseItem.applicant.nationalId,
  //                       ),
  //                       _buildInfoChip(
  //                         context,
  //                         icon: Icons.phone,
  //                         label: caseItem.applicant.phone,
  //                       ),
  //                       _buildInfoChip(
  //                         context,
  //                         icon: Icons.groups,
  //                         label:
  //                             '${caseItem.familyMembers.length + 1 + (caseItem.spouse != null ? 1 : 0)} أفراد',
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(height: 12.h),

  //                   // Case Description
  //                   Container(
  //                     padding: EdgeInsets.all(12.w),
  //                     decoration: BoxDecoration(
  //                       color: context.colors.primary.withValues(alpha: 0.05),
  //                       borderRadius: BorderRadius.circular(8.r),
  //                       border: Border.all(
  //                         color: context.colors.primary.withValues(alpha: 0.2),
  //                       ),
  //                     ),
  //                     child: Row(
  //                       children: [
  //                         Icon(
  //                           Icons.description,
  //                           size: 16.sp,
  //                           color: context.colors.primary,
  //                         ),
  //                         SizedBox(width: 8.w),
  //                         Expanded(
  //                           child: Text(
  //                             caseItem.caseDescription,
  //                             style: TextStyle(
  //                               fontSize: 13.sp,
  //                               color: context.colors.text,
  //                             ),
  //                             maxLines: 2,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   SizedBox(height: 12.h),

  //                   // Financial Summary
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: _buildFinancialInfo(
  //                           context,
  //                           icon: Icons.trending_up,
  //                           label: 'الدخل',
  //                           value: _formatCurrencyShort(totalIncome),
  //                           color: Colors.green,
  //                         ),
  //                       ),
  //                       SizedBox(width: 8.w),
  //                       Expanded(
  //                         child: _buildFinancialInfo(
  //                           context,
  //                           icon: Icons.trending_down,
  //                           label: 'المصروفات',
  //                           value: _formatCurrencyShort(totalExpenses),
  //                           color: Colors.orange,
  //                         ),
  //                       ),
  //                       SizedBox(width: 8.w),
  //                       Expanded(
  //                         child: _buildFinancialInfo(
  //                           context,
  //                           icon: remaining >= 0
  //                               ? Icons.check_circle
  //                               : Icons.warning,
  //                           label: remaining >= 0 ? 'فائض' : 'عجز',
  //                           value: _formatCurrencyShort(remaining.abs()),
  //                           color: remaining >= 0 ? Colors.green : Colors.red,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }



  void _confirmDeleteCase(
    BuildContext context,
    admin_model.CaseModel caseItem,
  ) {
    showCustomDialog(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('حذف الحالة', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text('هل أنت متأكد من حذف حالة ${caseItem.applicant.name}؟'),
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
                  context.read<AdminCasesCubit>().deleteCase(caseItem.id);
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

  void _confirmDeleteAll(BuildContext context) {
    showCustomDialog(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'حذف جميع البيانات',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: context.colors.error),
          ),
          SizedBox(height: 16.h),
          const Text(
            'هل أنت متأكد من حذف جميع الحالات؟ هذا الإجراء لا يمكن التراجع عنه.',
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
                  backgroundColor: context.colors.error,
                ),
                onPressed: () {
                  context.read<AdminCasesCubit>().deleteAllCases();
                  context.pop();
                },
                child: const Text(
                  'حذف الكل',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  user_model.CaseModel _mapToUserCaseModel(admin_model.CaseModel c) {
    return user_model.CaseModel(
      id: c.id,
      applicant: user_person.PersonModel(
        name: c.applicant.name,
        nationalId: c.applicant.nationalId,
        age: c.applicant.age,
        profession: c.applicant.profession,
        income: c.applicant.income,
        phone: c.applicant.phone,
        address: c.applicant.address,
      ),
      spouse: c.spouse != null
          ? user_person.PersonModel(
              name: c.spouse!.name,
              nationalId: c.spouse!.nationalId,
              age: c.spouse!.age,
              profession: c.spouse!.profession,
              income: c.spouse!.income,
              phone: c.spouse!.phone,
              address: c.spouse!.address,
            )
          : null,
      caseDescription: c.caseDescription,
      familyMembers: c.familyMembers
          .map(
            (m) => user_person.PersonModel(
              name: m.name,
              nationalId: m.nationalId,
              age: m.age,
              profession: m.profession,
              income: m.income,
              phone: m.phone,
              address: m.address,
            ),
          )
          .toList(),
      rationCardCount: c.rationCardCount,
      pensionCount: c.pensionCount,
      manualTotalFamilyIncome: c.manualTotalFamilyIncome,
      expenses: user_expenses.ExpensesModel(
        rent: c.expenses.rent,
        electricity: c.expenses.electricity,
        water: c.expenses.water,
        gas: c.expenses.gas,
        education: c.expenses.education,
        treatment: c.expenses.treatment,
        debtRepayment: c.expenses.debtRepayment,
        other: c.expenses.other,
      ),
      aidHistory: c.aidHistory
          .map(
            (a) => user_aid.AidModel(
              type: user_aid.AidType.values[a.type.index],
              value: a.value,
              date: a.date,
            ),
          )
          .toList(),
      createdAt: c.createdAt,
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? _selectedStatus;
  bool _sortByLowestIncome = false;
  String? _maritalStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تصفية النتائج', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text(
            'الحالة الاجتماعية',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Wrap(
            spacing: 8.w,
            children: ['متزوج', 'أعزب', 'أرمل', 'مطلق'].map((status) {
              return ChoiceChip(
                label: Text(status),
                selected: _maritalStatus == status,
                onSelected: (selected) {
                  setState(() {
                    _maritalStatus = selected ? status : null;
                  });
                },
              );
            }).toList(),
          ),
          SizedBox(height: 16.h),
          SwitchListTile(
            title: const Text('ترتيب حسب الأقل دخلاً'),
            value: _sortByLowestIncome,
            onChanged: (value) {
              setState(() {
                _sortByLowestIncome = value;
              });
            },
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<AdminCasesCubit>().filterCases(
                  maritalStatus: _maritalStatus,
                  sortByLowestIncome: _sortByLowestIncome,
                );
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: const Text('تطبيق'),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
