import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/utils/validation_utils.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class Step1PersonalInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController nationalIdController;
  final TextEditingController ageController;
  final TextEditingController phoneController;
  final TextEditingController jobController;

  const Step1PersonalInfo({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.nationalIdController,
    required this.ageController,
    required this.phoneController,
    required this.jobController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextFormField(
              label: 'الاسم رباعي',
              controller: nameController,
              hasTextAbove: true,
              hint: 'ادخل الاسم كما في البطاقة',
              prefixIcon:  Icon(Icons.person_outline , color: context.colors.primary ,),
              validator: ValidationUtils.validateName,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.name,
            ),
            CustomTextFormField(
              label: 'الرقم القومي',
              controller: nationalIdController,
              hasTextAbove: true,
              hint: '14 رقم',
              prefixIcon:  Icon(Icons.credit_card, color: context.colors.primary),
              validator: ValidationUtils.validateNationalId,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
            CustomTextFormField(
              label: 'السن',
              controller: ageController,
              hasTextAbove: true,
              hint: 'السن',
              prefixIcon:  Icon(Icons.calendar_today, color: context.colors.primary),
              validator: (v) => ValidationUtils.validateAge(v, required: true),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
            ),
            CustomTextFormField(
              label: 'رقم الهاتف',
              controller: phoneController,
              hasTextAbove: true,
              hint: 'رقم للتواصل',
              prefixIcon:  Icon(Icons.phone, color: context.colors.primary),
              validator: (v) =>
                  ValidationUtils.validatePhone(v, required: true),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.phone,
            ),
            CustomTextFormField(
              label: 'المهنة',
              controller: jobController,
              hasTextAbove: true,
              hint: 'المهنة الحالية',
              prefixIcon:  Icon(Icons.work_outline, color: context.colors.primary),
              validator: (v) =>
                  ValidationUtils.validateRequired(v, fieldName: 'المهنة'),
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
