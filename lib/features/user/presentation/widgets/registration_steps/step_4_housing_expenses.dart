import 'package:charity_app/core/utils/validation_utils.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Step4Expenses extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController addressController;
  final TextEditingController rentController;
  final TextEditingController electricityController;
  final TextEditingController waterController;
  final TextEditingController gasController;
  final TextEditingController educationController;
  final TextEditingController treatmentController;
  final TextEditingController debtController;
  final TextEditingController otherExpensesController;

  const Step4Expenses({
    super.key,
    required this.formKey,
    required this.addressController,
    required this.rentController,
    required this.electricityController,
    required this.waterController,
    required this.gasController,
    required this.educationController,
    required this.treatmentController,
    required this.debtController,
    required this.otherExpensesController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              label: 'العنوان تفصيلياً',
              controller: addressController,
              hasTextAbove: true,
              hint: 'المحافظة - المدينة - الشارع - رقم العقار',
              prefixIcon: const Icon(Icons.location_on),
              maxLines: 2,
              validator: (v) =>
                  ValidationUtils.validateRequired(v, fieldName: 'العنوان'),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 24.h),
            Text(
              'المصروفات الشهرية',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            _buildExpenseRow(context, 'إيجار', rentController, Icons.home_work),
            _buildExpenseRow(
              context,
              'كهرباء',
              electricityController,
              Icons.electric_bolt,
            ),
            _buildExpenseRow(
              context,
              'مياه',
              waterController,
              Icons.water_drop,
            ),
            _buildExpenseRow(
              context,
              'غاز',
              gasController,
              Icons.local_fire_department,
            ),
            _buildExpenseRow(
              context,
              'تعليم',
              educationController,
              Icons.school,
            ),
            _buildExpenseRow(
              context,
              'علاج',
              treatmentController,
              Icons.medical_services,
            ),
            _buildExpenseRow(context, 'ديون', debtController, Icons.money_off),
            _buildExpenseRow(
              context,
              'أخرى',
              otherExpensesController,
              Icons.more_horiz,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseRow(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: CustomTextFormField(
        label: label,
        controller: controller,
        hasTextAbove: true,
        hint: '0.0',
        keyboardType: TextInputType.number,
        prefixIcon: Icon(icon, size: 20.sp),
        validator: (v) => ValidationUtils.validateAmount(v, required: true),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
