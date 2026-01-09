import 'package:charity_app/core/config/res/app_sizes.dart';
import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/widgets/card_widget.dart';
import 'package:charity_app/core/widgets/custom_app_header.dart';
import 'package:charity_app/core/widgets/custom_dialog.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/custom_loading.dart';
import 'package:charity_app/core/widgets/empty_widget.dart';
import 'package:charity_app/core/widgets/text_form_filed_widget.dart';
import 'package:charity_app/features/admin/presentation/cubit/admin_cases_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import '../../../../injection_container.dart' as di;
import '../cubit/admin_cases_state.dart';
import '../../data/models/case_model.dart' as admin_model;
import '../../../user/data/models/case_model.dart' as user_model;
import '../../../user/data/models/person_model.dart' as user_person;
import '../../../user/data/models/expenses_model.dart' as user_expenses;
import '../../../user/data/models/aid_model.dart' as user_aid;

class CasesListScreen extends StatefulWidget {
  const CasesListScreen({super.key});

  @override
  State<CasesListScreen> createState() => _CasesListScreenState();
}

class _CasesListScreenState extends State<CasesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
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
            backgroundColor: context.colors.scaffoldBackground,
            body: Column(
              children: [
                CustomAppHeader(
                  title: 'الحالات المسجلة',
                  showBackButton: true,
                  onBack: () => context.pop(),
                  actions: [
                    CardWidget(
                      height: 40.h,
                      width: 40.w,
                      radius: 8.r,
                      margin: EdgeInsets.only(left: AppSize.sW16),
                      child: InkWell(
                        onTap: () => _confirmExport(context),
                        child: Image.asset(
                          'assets/images/xls.png',
                          width: 32.w,
                          height: 32.h,
                        ),
                      ),
                    ),
                    CardWidget(
                      height: 40.h,
                      width: 40.w,
                      radius: 8.r,
                      backgroundColor: context.colors.error10,
                      margin: EdgeInsets.only(left: AppSize.sW16),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'حذف جميع البيانات',
                          onPressed: () => _confirmDeleteAll(context),
                        ),
                      ),
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
                        // Close dialog if open? Handled in _confirmExport
                        // Open file
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
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const EmptyWidget(title: 'لا توجد حالات مسجلة'),
                              if (state.isFiltering)
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<AdminCasesCubit>()
                                        .clearFilter();
                                  },
                                  child: const Text('إلغاء الفلتر'),
                                ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<AdminCasesCubit>().loadCases();
                          await Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(AppSize.sW16),
                          itemCount:
                              displayCases.length +
                              (state.isLoadingMore ? 1 : 0),
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

  void _confirmExport(BuildContext context) {
    showCustomDialog(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.download_rounded,
            size: 50.sp,
            color: context.colors.primary,
          ),
          SizedBox(height: 16.h),
          Text('تصدير البيانات', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 12.h),
          const Text(
            'سيتم تحميل ملف Excel يحتوي على كافة بيانات الحالات المسجلة. هل تريد المتابعة؟',
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
    final cubit = context.read<AdminCasesCubit>();
    final stream = cubit.exportToExcelChange();

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
        backgroundColor: context.colors.white.withValues(alpha: 0.1),

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
                              color: context.colors.text,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        // if (isUrgent)
                        //   Container(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: 6.w,
                        //       vertical: 2.h,
                        //     ),
                        //     decoration: BoxDecoration(
                        //       color: isCritical ? Colors.red : Colors.orange,
                        //       borderRadius: BorderRadius.circular(4.r),
                        //     ),
                        //     child: Text(
                        //       isCritical ? 'عاجل' : 'متابعة',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: 10.sp,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // National ID
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/whatsApp.svg',
                          width: 24.w,
                          height: 24.h,
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
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: context.colors.error,
                  size: 20.sp,
                ),
                onPressed: () => _confirmDeleteCase(context, caseItem),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
  bool _sortByLowestIncome = false;
  String? _maritalStatus;
  bool? _hasAid;
  bool? _hasChildren;

  @override
  void initState() {
    super.initState();
    final cubitState = context.read<AdminCasesCubit>().state;
    _maritalStatus = cubitState.filterMaritalStatus;
    _sortByLowestIncome = cubitState.filterSortByLowestIncome ?? false;
    _hasAid = cubitState.filterHasAid;
    _hasChildren = cubitState.filterHasChildren;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.sW16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تصفية النتائج',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _maritalStatus = null;
                    _sortByLowestIncome = false;
                    _hasAid = null;
                    _hasChildren = null;
                  });
                  context.read<AdminCasesCubit>().clearFilter();
                  context.pop();
                },
                child: const Text(
                  'إعادة تهيئة',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Marital Status
          Text(
            'الحالة الاجتماعية',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: [
              _buildFilterChip('متزوج', 'متزوج'),
              _buildFilterChip('أعزب / آخر', 'أخرى'),
            ],
          ),

          SizedBox(height: 16.h),

          // Has Children
          Text('لديهم أبناء؟', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: [
              _buildBoolChip(
                'الكل',
                null,
                _hasChildren,
                (v) => _hasChildren = v,
              ),
              _buildBoolChip(
                'نعم',
                true,
                _hasChildren,
                (v) => _hasChildren = v,
              ),
              _buildBoolChip(
                'لا',
                false,
                _hasChildren,
                (v) => _hasChildren = v,
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Has Aid
          Text(
            'حصلوا على تبرعات؟',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: [
              _buildBoolChip('الكل', null, _hasAid, (v) => _hasAid = v),
              _buildBoolChip('نعم', true, _hasAid, (v) => _hasAid = v),
              _buildBoolChip('لا', false, _hasAid, (v) => _hasAid = v),
            ],
          ),

          SizedBox(height: 16.h),

          Row(
            children: [
              const Text('ترتيب حسب الأقل دخلاً'),
              const Spacer(),
              Switch(
                value: _sortByLowestIncome,
                onChanged: (value) =>
                    setState(() => _sortByLowestIncome = value),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<AdminCasesCubit>().filterCasesAdvanced(
                  maritalStatus: _maritalStatus,
                  sortByLowestIncome: _sortByLowestIncome,
                  showUrgentOnly: context
                      .read<AdminCasesCubit>()
                      .state
                      .filterShowUrgentOnly, // preserve urgent
                  hasAid: _hasAid,
                  hasChildren: _hasChildren,
                );
                context.pop();
              },
              child: const Text(
                'تطبيق الفلتر',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                minimumSize: Size(double.infinity, 50.h),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _maritalStatus == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _maritalStatus = selected ? value : null;
        });
      },
      selectedColor: context.colors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? context.colors.primary : context.colors.text,
      ),
    );
  }

  Widget _buildBoolChip(
    String label,
    bool? value,
    bool? groupValue,
    Function(bool?) onSelect,
  ) {
    final isSelected = groupValue == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          onSelect(selected ? value : null);
        });
      },
      selectedColor: context.colors.primary.withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? context.colors.primary : context.colors.text,
      ),
    );
  }
}
