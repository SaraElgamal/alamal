import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/utils/validation_utils.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:charity_app/features/user/presentation/widgets/custom_selection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Step2SpouseInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool hasSpouse;
  final ValueChanged<bool> onSpouseChanged;
  final TextEditingController nameController;
  final TextEditingController nationalIdController;
  final TextEditingController ageController;
  final TextEditingController professionController;
  final TextEditingController incomeController;
  final TextEditingController phoneController;

  // New parameters
  final List<String> selectedStatuses;
  final ValueChanged<String> onStatusToggled;
  final TextEditingController otherStatusController;

  const Step2SpouseInfo({
    super.key,
    required this.formKey,
    required this.hasSpouse,
    required this.onSpouseChanged,
    required this.nameController,
    required this.nationalIdController,
    required this.ageController,
    required this.professionController,
    required this.incomeController,
    required this.phoneController,
    required this.selectedStatuses,
    required this.onStatusToggled,
    required this.otherStatusController,
  });

  @override
  State<Step2SpouseInfo> createState() => _Step2SpouseInfoState();
}

class _Step2SpouseInfoState extends State<Step2SpouseInfo> {
  final List<String> _options = [
    'ارملة',
    'مطلقه',
    'مريضه',
    'هجر',
    'مدينه',
    'اخرى',
  ];

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _spouseFormKey = GlobalKey();

  void _scrollToSpouse() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_spouseFormKey.currentContext != null) {
        Scrollable.ensureVisible(
          _spouseFormKey.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'اختر توصيف الحالة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16.sp),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _options.map((option) {
                final isSelected = widget.selectedStatuses.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (_) => widget.onStatusToggled(option),
                  selectedColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.black87,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  backgroundColor: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : context.colors.black40,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (widget.selectedStatuses.contains('اخرى')) ...[
              SizedBox(height: 12.h),
              CustomTextFormField(
                label: 'توصيف الحالة الأخرى',
                controller: widget.otherStatusController,
                hasTextAbove: true,
                hint: 'اكتب الحالة الأخرى هنا...',
                validator: (v) => widget.selectedStatuses.contains('اخرى')
                    ? ValidationUtils.validateRequired(
                        v,
                        fieldName: 'الحالة الأخرى',
                      )
                    : null,
              ),
            ],
            SizedBox(height: 24.h),
            const Divider(),
            SizedBox(height: 16.h),
            Text(
              'هل أنت متزوج / متزوجة؟',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CustomSelectionCard(
                    title: 'نعم',
                    isSelected: widget.hasSpouse,
                    onTap: () {
                      widget.onSpouseChanged(true);
                      _scrollToSpouse();
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomSelectionCard(
                    title: 'لا',
                    isSelected: !widget.hasSpouse,
                    onTap: () => widget.onSpouseChanged(false),
                  ),
                ),
              ],
            ),
            if (widget.hasSpouse) ...[
              SizedBox(height: 24.h),
              Text(
                'بيانات الزوج/الزوجة',
                key: _spouseFormKey,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              CustomTextFormField(
                label: 'الاسم',
                controller: widget.nameController,
                hasTextAbove: true,
                hint: 'ادخل الاسم',
                prefixIcon: const Icon(Icons.person_outline),
                validator: ValidationUtils.validateName,
                textInputAction: TextInputAction.next,
              ),
              CustomTextFormField(
                label: 'الرقم القومي',
                controller: widget.nationalIdController,
                hasTextAbove: true,
                hint: '14 رقم',
                prefixIcon: const Icon(Icons.credit_card),
                validator: ValidationUtils.validateNationalId,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              CustomTextFormField(
                label: 'السن',
                controller: widget.ageController,
                keyboardType: TextInputType.number,
                hasTextAbove: true,
                hint: 'السن',
                validator: (val) => ValidationUtils.validateAge(val,required: true),
                textInputAction: TextInputAction.next,
              ),
              CustomTextFormField(
                label: 'المهنة',
                controller: widget.professionController,
                hasTextAbove: true,
                hint: 'المهنة',
                validator: (v) =>
                    ValidationUtils.validateRequired(v, fieldName: 'المهنة'),
                textInputAction: TextInputAction.next,
              ),
              CustomTextFormField(
                label: 'الدخل الشهري',
                controller: widget.incomeController,
                keyboardType: TextInputType.number,
                hasTextAbove: true,
                hint: '0.0',
                validator: (v) =>
                    ValidationUtils.validateAmount(v, required: true),
                textInputAction: TextInputAction.next,
              ),
              CustomTextFormField(
                label: 'رقم التليفون',
                controller: widget.phoneController,
                keyboardType: TextInputType.phone,
                hasTextAbove: true,
                hint: 'رقم التواصل',
                validator: (v) =>
                    ValidationUtils.validatePhone(v, required: true),
                textInputAction: TextInputAction.done,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
