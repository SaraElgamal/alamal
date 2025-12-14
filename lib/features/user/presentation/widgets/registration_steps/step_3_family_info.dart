import 'package:charity_app/core/utils/validation_utils.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:charity_app/features/user/data/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Step3FamilyCaseInfo extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController caseDescriptionController;
  final TextEditingController rationCardCountController;
  final TextEditingController pensionCountController;
  final List<PersonModel> familyMembers;
  final VoidCallback onAddMember;
  final ValueChanged<int> onDeleteMember;

  const Step3FamilyCaseInfo({
    super.key,
    required this.formKey,
    required this.caseDescriptionController,
    required this.rationCardCountController,
    required this.pensionCountController,
    required this.familyMembers,
    required this.onAddMember,
    required this.onDeleteMember,
  });

  @override
  State<Step3FamilyCaseInfo> createState() => _Step3FamilyCaseInfoState();
}

class _Step3FamilyCaseInfoState extends State<Step3FamilyCaseInfo> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            CustomTextFormField(
              label: 'توصيف الحالة',
              controller: widget.caseDescriptionController,
              hasTextAbove: true,
              hint: 'اشرح ظروف المريض/الحالة بالتفصيل...',
              maxLines: 4,
              validator: (v) => ValidationUtils.validateRequired(
                v,
                fieldName: 'توصيف الحالة',
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
            SizedBox(height: 16.h),

            // Family Members Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أفراد الأسرة',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: widget.onAddMember,
                  icon: const Icon(Icons.add_circle),
                  label: const Text('إضافة فرد'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),

            if (widget.familyMembers.isEmpty)
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.family_restroom, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Text(
                      'لا يوجد أفراد أسرة مضافين',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.familyMembers.length,
                itemBuilder: (context, index) {
                  final member = widget.familyMembers[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(member.name),
                      subtitle: Text(
                        '${member.profession} - ${member.age} سنة',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => widget.onDeleteMember(index),
                      ),
                    ),
                  );
                },
              ),

            SizedBox(height: 16.h),
            const Divider(),
            SizedBox(height: 16.h),

            CustomTextFormField(
              label: 'عدد الأفراد في التموين',
              controller: widget.rationCardCountController,
              keyboardType: TextInputType.number,
              hasTextAbove: true,
              hint: 'العدد',
              prefixIcon: const Icon(Icons.shopping_cart_outlined),
              validator: (v) =>
                  ValidationUtils.validatePositiveNumber(v, required: true),
              textInputAction: TextInputAction.next,
            ),
            CustomTextFormField(
              label: 'عدد الحاصلين على معاش',
              controller: widget.pensionCountController,
              keyboardType: TextInputType.number,
              hasTextAbove: true,
              hint: 'العدد',
              prefixIcon: const Icon(Icons.elderly),
              validator: ValidationUtils.validatePositiveNumber,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }
}
