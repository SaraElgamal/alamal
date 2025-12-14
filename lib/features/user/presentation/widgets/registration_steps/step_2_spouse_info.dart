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
  });

  @override
  State<Step2SpouseInfo> createState() => _Step2SpouseInfoState();
}

class _Step2SpouseInfoState extends State<Step2SpouseInfo> {
  // 0: Unspecified/Single, 1: Married (Has Spouse)
  // Simple toggle for now based on 'hasSpouse'

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الحالة الاجتماعية',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: CustomSelectionCard(
                    title: 'متزوج/ة',
                    icon: Icons.people_alt,
                    isSelected: widget.hasSpouse,
                    onTap: () => widget.onSpouseChanged(true),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomSelectionCard(
                    title: 'أعزب/أرمل/مطلق',
                    icon: Icons.person,
                    isSelected: !widget.hasSpouse,
                    onTap: () => widget.onSpouseChanged(false),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            if (widget.hasSpouse) ...[
              Text(
                'بيانات الزوج/الزوجة',
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
                validator: ValidationUtils.validateAge,
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
