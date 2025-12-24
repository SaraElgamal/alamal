import 'package:charity_app/core/utils/validation_utils.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:charity_app/features/user/data/models/aid_model.dart';
import 'package:charity_app/features/user/presentation/widgets/custom_selection_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class Step5AidHistory extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool hasReceivedAid;
  final ValueChanged<bool> onAidChanged;
  final AidType selectedAidType;
  final ValueChanged<AidType> onTypeChanged;
  final TextEditingController valueController;
  final TextEditingController descriptionController;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const Step5AidHistory({
    super.key,
    required this.formKey,
    required this.hasReceivedAid,
    required this.onAidChanged,
    required this.selectedAidType,
    required this.onTypeChanged,
    required this.valueController,
    required this.descriptionController,
    required this.selectedDate,
    required this.onDateChanged,
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
            Text(
              'هل حصلت على مساعدة من خلال الجمعية من قبل ؟',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: CustomSelectionCard(
                    title: 'نعم',
                    isSelected: hasReceivedAid,
                    onTap: () => onAidChanged(true),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomSelectionCard(
                    title: 'لا',
                    isSelected: !hasReceivedAid,
                    onTap: () => onAidChanged(false),
                  ),
                ),
              ],
            ),
            if (hasReceivedAid) ...[
              SizedBox(height: 24.h),
              const Divider(),
              SizedBox(height: 16.h),
              Text(
                'بيانات المساعدة : ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: AlignmentDirectional.center,
                child: SizedBox(
                  width: 330.w,
                  child: DropdownButtonFormField<AidType>(
                    value: selectedAidType,
                    isExpanded: false,
                    isDense: true,
                    alignment: AlignmentDirectional.center,
                    borderRadius: BorderRadius.circular(15.r),
                    items: [
                      DropdownMenuItem(
                        value: AidType.cash,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                size: 18.sp,
                                color: Colors.green,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'مساعدة نقدية',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: AidType.food,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 18.sp,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'مساعدة عينية',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (v) => onTypeChanged(v!),
                    decoration: InputDecoration(
                      labelText: 'نوع المساعدة',
                      labelStyle: TextStyle(fontSize: 14.sp),
                      // prefixIcon: const Icon(Icons.category_outlined),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              if (selectedAidType == AidType.cash)
                CustomTextFormField(
                  label: 'قيمة المساعدة',
                  controller: valueController,
                  hasTextAbove: true,
                  hint: '0.0',
                  prefixIcon: const Icon(Icons.attach_money),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      ValidationUtils.validateAmount(v, required: true),
                  textInputAction: TextInputAction.next,
                )
              else
                CustomTextFormField(
                  label: 'وصف المساعدة العينية',
                  controller: descriptionController,
                  hasTextAbove: true,
                  hint: 'مثال: مواد غذائية، علاج، ملابس...',
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                  validator: null,
                  textInputAction: TextInputAction.next,
                ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    onDateChanged(date);
                  }
                },
                child: Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 12.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تاريخ استلام المساعدة',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              selectedDate != null
                                  ? DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(selectedDate!)
                                  : 'اختر التاريخ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: selectedDate != null
                                    ? Colors.black87
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
