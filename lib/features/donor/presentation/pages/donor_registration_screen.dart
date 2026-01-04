import 'package:charity_app/core/helpers/context_extension.dart';
import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/core/utils/validation_utils.dart';
import 'package:charity_app/core/widgets/buttons/loading_button.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:charity_app/features/donor/data/models/donor_model.dart';
import 'package:charity_app/features/donor/presentation/cubit/donor_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DonorRegistrationScreen extends StatefulWidget {
  const DonorRegistrationScreen({super.key});

  @override
  State<DonorRegistrationScreen> createState() =>
      _DonorRegistrationScreenState();
}

class _DonorRegistrationScreenState extends State<DonorRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  DonationType _donationType = DonationType.cash;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final donor = DonorModel(
        id: '',
        name: _nameController.text,
        phone: _phoneController.text,
        donationType: _donationType,
        amount: _donationType == DonationType.cash
            ? double.tryParse(_amountController.text)
            : null,
        description: _donationType == DonationType.inKind
            ? _descriptionController.text
            : null,
        date: _selectedDate,
      );
      context.read<DonorCubit>().addDonor(donor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل كمتبرع'), centerTitle: true),
      body: BlocListener<DonorCubit, DonorState>(
        listener: (context, state) {
          if (state.status == DonorStatus.success) {
            MessageUtils.showSuccess(
              state.successMessage ?? 'تم التسجيل بنجاح',
            );
            context.go(AppRoutes.donorSuccess);
          } else if (state.status == DonorStatus.error) {
            MessageUtils.showError(state.errorMessage ?? 'حدث خطأ ما');
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  label: 'الاسم',
                  controller: _nameController,
                  hint: 'أدخل اسمك بالكامل',
                  validator: (v) => ValidationUtils.validateName(v),
                  hasTextAbove: true,
                ),
                SizedBox(height: 16.h),
                CustomTextFormField(
                  label: 'رقم التليفون',
                  controller: _phoneController,
                  hint: 'أدخل رقم الهاتف',
                  keyboardType: TextInputType.phone,
                  validator: (v) =>
                      ValidationUtils.validatePhone(v, required: true),
                  hasTextAbove: true,
                ),
                SizedBox(height: 24.h),
                Text(
                  'نوع التبرع',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<DonationType>(
                        title: const Text('نقدي'),
                        value: DonationType.cash,                       
                        groupValue: _donationType,
                        onChanged: (val) =>
                            setState(() => _donationType = val!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<DonationType>(
                        title: const Text('عيني'),
                        value: DonationType.inKind,
                        groupValue: _donationType,
                        onChanged: (val) =>
                            setState(() => _donationType = val!),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                if (_donationType == DonationType.cash)
                  CustomTextFormField(
                    label: 'المبلغ',
                    controller: _amountController,
                    hint: 'أدخل المبلغ المتبرع به',
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        ValidationUtils.validateAmount(v, required: true),
                    hasTextAbove: true,
                  )
                else
                  CustomTextFormField(
                    label: 'وصف التبرع',
                    controller: _descriptionController,
                    hint: 'وصف ما تم التبرع به (مثلاً: ملابس، طعام، إلخ)',
                    maxLines: 3,
                    validator: (v) =>
                        ValidationUtils.validateRequired(v, fieldName: 'الوصف'),
                    hasTextAbove: true,
                  ),
                SizedBox(height: 16.h),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                     color: context.colors.background,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تاريخ التبرع: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: context.colors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.h),
                BlocBuilder<DonorCubit, DonorState>(
                  builder: (context, state) {
                    return LoadingButton(
                      margin: EdgeInsets.zero,
                      onTap: () async {
                         _submit();
                      },
                      title: 'تأكيد وإرسال',
                      
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
