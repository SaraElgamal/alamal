import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../domain/entities/case_entity.dart';
import '../../domain/entities/expenses_entity.dart';
import '../../domain/entities/person_entity.dart';
import '../cubit/user_cases_cubit.dart';
import '../cubit/user_cases_state.dart';

class CaseRegistrationScreen extends StatefulWidget {
  const CaseRegistrationScreen({super.key});

  @override
  State<CaseRegistrationScreen> createState() => _CaseRegistrationScreenState();
}

class _CaseRegistrationScreenState extends State<CaseRegistrationScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers - Applicant
  final _nameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();
  final _incomeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Controllers - Spouse
  bool _hasSpouse = false;
  final _spouseNameController = TextEditingController();
  final _spouseNationalIdController = TextEditingController();
  final _spouseAgeController = TextEditingController();
  final _spouseProfessionController = TextEditingController();
  final _spouseIncomeController = TextEditingController();
  final _spousePhoneController = TextEditingController();

  // Controllers - Case Info
  final _caseDescriptionController = TextEditingController();
  final _rationCardCountController = TextEditingController();
  final _pensionCountController = TextEditingController();

  // Controllers - Expenses
  final _rentController = TextEditingController();
  final _electricityController = TextEditingController();
  final _waterController = TextEditingController();
  final _gasController = TextEditingController();
  final _educationController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _debtController = TextEditingController();
  final _otherExpensesController = TextEditingController();

  // Family Members
  List<PersonEntity> _familyMembers = [];

  void _addFamilyMember() {
    // Simple dialog to add family member
    showDialog(
      context: context,
      builder: (context) {
        final nameC = TextEditingController();
        final ageC = TextEditingController();
        final jobC = TextEditingController();
        final incomeC = TextEditingController();
        final nidC = TextEditingController();
        
        return AlertDialog(
          title: const Text('إضافة فرد أسرة'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFormField(label: 'الاسم', controller: nameC),
                CustomTextFormField(label: 'الرقم القومي', controller: nidC),
                CustomTextFormField(label: 'السن', controller: ageC, keyboardType: TextInputType.number),
                CustomTextFormField(label: 'المهنة', controller: jobC),
                CustomTextFormField(label: 'الدخل', controller: incomeC, keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _familyMembers.add(PersonEntity(
                    name: nameC.text,
                    nationalId: nidC.text,
                    age: int.tryParse(ageC.text) ?? 0,
                    profession: jobC.text,
                    income: double.tryParse(incomeC.text) ?? 0,
                    phone: '',
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل حالة جديدة')),
      body: BlocListener<UserCasesCubit, UserCasesState>(
        listener: (context, state) {
          if (state.status == UserCasesStatus.caseAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage ?? 'تم تسجيل الحالة بنجاح')),
            );
            Navigator.pop(context);
          } else if (state.status == UserCasesStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ')),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 4) {
                setState(() => _currentStep += 1);
              } else {
                _submitForm();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            steps: [
              Step(
                title: const Text('بيانات مقدم الطلب'),
                content: Column(
                  children: [
                    CustomTextFormField(
                      label: 'الاسم',
                      controller: _nameController,
                      validator: ValidationUtils.validateName,
                    ),
                    CustomTextFormField(
                      label: 'الرقم القومي',
                      controller: _nationalIdController,
                      validator: ValidationUtils.validateNationalId,
                      keyboardType: TextInputType.number,
                    ),
                    CustomTextFormField(
                      label: 'السن',
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      validator: (v) => ValidationUtils.validateAge(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'المهنة',
                      controller: _professionController,
                      validator: (v) => ValidationUtils.validateRequired(v, fieldName: 'المهنة'),
                    ),
                    CustomTextFormField(
                      label: 'الدخل',
                      controller: _incomeController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                    CustomTextFormField(
                      label: 'رقم التليفون',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => ValidationUtils.validatePhone(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'العنوان تفصيلياً',
                      controller: _addressController,
                      maxLines: 2,
                      validator: (v) => ValidationUtils.validateRequired(v, fieldName: 'العنوان'),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
              ),
              Step(
                title: const Text('بيانات الزوج/الزوجة'),
                content: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('يوجد زوج/زوجة'),
                      value: _hasSpouse,
                      onChanged: (v) => setState(() => _hasSpouse = v!),
                    ),
                    if (_hasSpouse) ...[
                      CustomTextFormField(
                        label: 'الاسم',
                        controller: _spouseNameController,
                        validator: ValidationUtils.validateName,
                      ),
                      CustomTextFormField(
                        label: 'الرقم القومي',
                        controller: _spouseNationalIdController,
                        validator: ValidationUtils.validateNationalId,
                        keyboardType: TextInputType.number,
                      ),
                      CustomTextFormField(
                        label: 'السن',
                        controller: _spouseAgeController,
                        keyboardType: TextInputType.number,
                        validator: ValidationUtils.validateAge,
                      ),
                      CustomTextFormField(
                        label: 'المهنة',
                        controller: _spouseProfessionController,
                      ),
                      CustomTextFormField(
                        label: 'الدخل',
                        controller: _spouseIncomeController,
                        keyboardType: TextInputType.number,
                        validator: ValidationUtils.validateAmount,
                      ),
                      CustomTextFormField(
                        label: 'رقم التليفون',
                        controller: _spousePhoneController,
                        keyboardType: TextInputType.phone,
                        validator: ValidationUtils.validatePhone,
                      ),
                    ],
                  ],
                ),
                isActive: _currentStep >= 1,
              ),
              Step(
                title: const Text('تفاصيل الحالة والأسرة'),
                content: Column(
                  children: [
                    CustomTextFormField(
                      label: 'توصيف الحالة (أرملة، مطلقة، مريض...)',
                      controller: _caseDescriptionController,
                      validator: (v) => ValidationUtils.validateRequired(v, fieldName: 'توصيف الحالة'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('أفراد الأسرة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(onPressed: _addFamilyMember, icon: const Icon(Icons.add_circle)),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _familyMembers.length,
                      itemBuilder: (context, index) {
                        final member = _familyMembers[index];
                        return ListTile(
                          title: Text(member.name),
                          subtitle: Text('${member.profession} - ${member.age} سنة'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => setState(() => _familyMembers.removeAt(index)),
                          ),
                        );
                      },
                    ),
                    CustomTextFormField(
                      label: 'عدد الأفراد في بطاقة التموين',
                      controller: _rationCardCountController,
                      keyboardType: TextInputType.number,
                      validator: (v) => ValidationUtils.validatePositiveNumber(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'عدد الحاصلين على معاش',
                      controller: _pensionCountController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validatePositiveNumber,
                    ),
                  ],
                ),
                isActive: _currentStep >= 2,
              ),
              Step(
                title: const Text('المصروفات الشهرية'),
                content: Column(
                  children: [
                    CustomTextFormField(
                      label: 'إيجار',
                      controller: _rentController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                    CustomTextFormField(
                      label: 'كهرباء',
                      controller: _electricityController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                    CustomTextFormField(
                      label: 'مياه',
                      controller: _waterController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                    CustomTextFormField(
                      label: 'غاز',
                      controller: _gasController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                    CustomTextFormField(
                      label: 'تعليم',
                      controller: _educationController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                    CustomTextFormField(
                      label: 'علاج',
                      controller: _treatmentController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                    CustomTextFormField(
                      label: 'سداد ديون',
                      controller: _debtController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                    CustomTextFormField(
                      label: 'أخرى',
                      controller: _otherExpensesController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validateAmount,
                    ),
                  ],
                ),
                isActive: _currentStep >= 3,
              ),
              Step(
                title: const Text('تأكيد'),
                content: const Text('هل أنت متأكد من صحة البيانات المدخلة؟'),
                isActive: _currentStep >= 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final applicant = PersonEntity(
        name: _nameController.text,
        nationalId: _nationalIdController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        profession: _professionController.text,
        income: double.tryParse(_incomeController.text) ?? 0,
        phone: _phoneController.text,
        address: _addressController.text,
      );

      final spouse = _hasSpouse
          ? PersonEntity(
              name: _spouseNameController.text,
              nationalId: _spouseNationalIdController.text,
              age: int.tryParse(_spouseAgeController.text) ?? 0,
              profession: _spouseProfessionController.text,
              income: double.tryParse(_spouseIncomeController.text) ?? 0,
              phone: _spousePhoneController.text,
            )
          : null;

      final expenses = ExpensesEntity(
        rent: double.tryParse(_rentController.text) ?? 0,
        electricity: double.tryParse(_electricityController.text) ?? 0,
        water: double.tryParse(_waterController.text) ?? 0,
        gas: double.tryParse(_gasController.text) ?? 0,
        education: double.tryParse(_educationController.text) ?? 0,
        treatment: double.tryParse(_treatmentController.text) ?? 0,
        debtRepayment: double.tryParse(_debtController.text) ?? 0,
        other: double.tryParse(_otherExpensesController.text) ?? 0,
      );

      final caseEntity = UserCaseEntity(
        id: '', // Will be generated
        applicant: applicant,
        spouse: spouse,
        caseDescription: _caseDescriptionController.text,
        familyMembers: _familyMembers,
        rationCardCount: int.tryParse(_rationCardCountController.text) ?? 0,
        pensionCount: int.tryParse(_pensionCountController.text) ?? 0,
        expenses: expenses,
        aidHistory: const [], // Initial registration has no aid history
        createdAt: DateTime.now(),
      );

      context.read<UserCasesCubit>().addNewCase(caseEntity);
    }
  }
}
