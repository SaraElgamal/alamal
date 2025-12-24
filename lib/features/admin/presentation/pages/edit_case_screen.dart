import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/validation_utils.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../data/models/case_model.dart' as admin_model;
import '../../data/models/expenses_model.dart' as admin_expenses;
import '../../data/models/person_model.dart' as admin_person;
import '../../../user/data/models/case_model.dart' as user_model;
import '../../data/models/aid_model.dart' as admin_aid;
import '../../../user/data/models/aid_model.dart' as user_aid;
import '../cubit/admin_cases_cubit.dart';
import '../cubit/admin_cases_state.dart';

class EditCaseScreen extends StatefulWidget {
  final user_model.CaseModel caseModel;

  const EditCaseScreen({super.key, required this.caseModel});

  @override
  State<EditCaseScreen> createState() => _EditCaseScreenState();
}

class _EditCaseScreenState extends State<EditCaseScreen> {
  int _currentStep = 0;
  final _applicantFormKey = GlobalKey<FormState>();
  final _spouseFormKey = GlobalKey<FormState>();
  final _caseInfoFormKey = GlobalKey<FormState>();
  final _expensesFormKey = GlobalKey<FormState>();

  // Controllers - Applicant
  late TextEditingController _nameController;
  late TextEditingController _nationalIdController;
  late TextEditingController _ageController;
  late TextEditingController _professionController;
  late TextEditingController _incomeController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  // Controllers - Spouse
  bool _hasSpouse = false;
  late TextEditingController _spouseNameController;
  late TextEditingController _spouseNationalIdController;
  late TextEditingController _spouseAgeController;
  late TextEditingController _spouseProfessionController;
  late TextEditingController _spouseIncomeController;
  late TextEditingController _spousePhoneController;

  // Controllers - Case Info
  late TextEditingController _caseDescriptionController;
  late TextEditingController _rationCardCountController;
  late TextEditingController _pensionCountController;

  // Controllers - Expenses
  late TextEditingController _rentController;
  late TextEditingController _electricityController;
  late TextEditingController _waterController;
  late TextEditingController _gasController;
  late TextEditingController _educationController;
  late TextEditingController _treatmentController;
  late TextEditingController _debtController;
  late TextEditingController _otherExpensesController;

  // Family Members
  late List<admin_person.PersonModel> _familyMembers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final c = widget.caseModel;

    // Applicant
    _nameController = TextEditingController(text: c.applicant.name);
    _nationalIdController = TextEditingController(text: c.applicant.nationalId);
    _ageController = TextEditingController(text: c.applicant.age.toString());
    _professionController = TextEditingController(text: c.applicant.profession);
    _incomeController = TextEditingController(
      text: c.applicant.income.toString(),
    );
    _phoneController = TextEditingController(text: c.applicant.phone);
    _addressController = TextEditingController(text: c.applicant.address ?? '');

    // Spouse
    _hasSpouse = c.spouse != null;
    _spouseNameController = TextEditingController(text: c.spouse?.name ?? '');
    _spouseNationalIdController = TextEditingController(
      text: c.spouse?.nationalId ?? '',
    );
    _spouseAgeController = TextEditingController(
      text: c.spouse?.age.toString() ?? '',
    );
    _spouseProfessionController = TextEditingController(
      text: c.spouse?.profession ?? '',
    );
    _spouseIncomeController = TextEditingController(
      text: c.spouse?.income.toString() ?? '',
    );
    _spousePhoneController = TextEditingController(text: c.spouse?.phone ?? '');

    // Case Info
    _caseDescriptionController = TextEditingController(text: c.caseDescription);
    _rationCardCountController = TextEditingController(
      text: c.rationCardCount.toString(),
    );
    _pensionCountController = TextEditingController(
      text: c.pensionCount.toString(),
    );
    _familyMembers = c.familyMembers
        .map(
          (m) => admin_person.PersonModel(
            name: m.name,
            nationalId: m.nationalId,
            age: m.age,
            profession: m.profession,
            income: m.income,
            phone: m.phone,
            address: m.address,
          ),
        )
        .toList();

    // Expenses
    _rentController = TextEditingController(text: c.expenses.rent.toString());
    _electricityController = TextEditingController(
      text: c.expenses.electricity.toString(),
    );
    _waterController = TextEditingController(text: c.expenses.water.toString());
    _gasController = TextEditingController(text: c.expenses.gas.toString());
    _educationController = TextEditingController(
      text: c.expenses.education.toString(),
    );
    _treatmentController = TextEditingController(
      text: c.expenses.treatment.toString(),
    );
    _debtController = TextEditingController(
      text: c.expenses.debtRepayment.toString(),
    );
    _otherExpensesController = TextEditingController(
      text: c.expenses.other.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nationalIdController.dispose();
    _ageController.dispose();
    _professionController.dispose();
    _incomeController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _spouseNameController.dispose();
    _spouseNationalIdController.dispose();
    _spouseAgeController.dispose();
    _spouseProfessionController.dispose();
    _spouseIncomeController.dispose();
    _spousePhoneController.dispose();
    _caseDescriptionController.dispose();
    _rationCardCountController.dispose();
    _pensionCountController.dispose();
    _rentController.dispose();
    _electricityController.dispose();
    _waterController.dispose();
    _gasController.dispose();
    _educationController.dispose();
    _treatmentController.dispose();
    _debtController.dispose();
    _otherExpensesController.dispose();
    super.dispose();
  }

  void _addFamilyMember() {
    final formKey = GlobalKey<FormState>();
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    label: 'الاسم',
                    controller: nameC,
                    validator: ValidationUtils.validateName,
                  ),
                  CustomTextFormField(
                    label: 'الرقم القومي',
                    controller: nidC,
                    validator: ValidationUtils.validateNationalId,
                    keyboardType: TextInputType.number,
                  ),
                  CustomTextFormField(
                    label: 'السن',
                    controller: ageC,
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        ValidationUtils.validateAge(v, required: true),
                  ),
                  CustomTextFormField(
                    label: 'المهنة',
                    controller: jobC,
                    validator: (v) => ValidationUtils.validateRequired(
                      v,
                      fieldName: 'المهنة',
                    ),
                  ),
                  CustomTextFormField(
                    label: 'الدخل',
                    controller: incomeC,
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        ValidationUtils.validateAmount(v, required: true),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _familyMembers.add(
                      admin_person.PersonModel(
                        name: nameC.text,
                        nationalId: nidC.text,
                        age: int.tryParse(ageC.text) ?? 0,
                        profession: jobC.text,
                        income: double.tryParse(incomeC.text) ?? 0,
                        phone: '',
                      ),
                    );
                  });
                  context.pop();
                }
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
      appBar: AppBar(title: const Text('تعديل بيانات الحالة')),
      body: BlocListener<AdminCasesCubit, AdminCasesState>(
        listener: (context, state) {
          if (state.status == AdminCasesStatus.success &&
              state.successMessage == 'Case updated successfully') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث البيانات بنجاح')),
            );
            context.pop(); // Go back to details
            context
                .pop(); // Go back to dashboard (optional, or just refresh details)
          } else if (state.status == AdminCasesStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'حدث خطأ')),
            );
          }
        },
        child: Stepper(
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          onStepContinue: () {
            bool isValid = false;
            switch (_currentStep) {
              case 0:
                isValid = _applicantFormKey.currentState!.validate();
                break;
              case 1:
                if (!_hasSpouse) {
                  isValid = true;
                } else {
                  isValid = _spouseFormKey.currentState!.validate();
                }
                break;
              case 2:
                isValid = _caseInfoFormKey.currentState!.validate();
                break;
              case 3:
                isValid = _expensesFormKey.currentState!.validate();
                break;
              case 4:
                isValid = true;
                break;
            }

            if (isValid) {
              if (_currentStep < 4) {
                setState(() => _currentStep += 1);
              } else {
                _submitForm();
              }
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
              content: Form(
                key: _applicantFormKey,
                child: Column(
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
                      validator: (v) =>
                          ValidationUtils.validateAge(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'المهنة',
                      controller: _professionController,
                      validator: (v) => ValidationUtils.validateRequired(
                        v,
                        fieldName: 'المهنة',
                      ),
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
                      validator: (v) =>
                          ValidationUtils.validatePhone(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'العنوان تفصيلياً',
                      controller: _addressController,
                      maxLines: 2,
                      validator: (v) => ValidationUtils.validateRequired(
                        v,
                        fieldName: 'العنوان',
                      ),
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('بيانات الزوج/الزوجة'),
              content: Form(
                key: _spouseFormKey,
                child: Column(
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
                        validator: (v) => ValidationUtils.validateRequired(
                          v,
                          fieldName: 'المهنة',
                        ),
                      ),
                      CustomTextFormField(
                        label: 'الدخل',
                        controller: _spouseIncomeController,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            ValidationUtils.validateAmount(v, required: true),
                      ),
                      CustomTextFormField(
                        label: 'رقم التليفون',
                        controller: _spousePhoneController,
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            ValidationUtils.validatePhone(v, required: true),
                      ),
                    ],
                  ],
                ),
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('تفاصيل الحالة والأسرة'),
              content: Form(
                key: _caseInfoFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: 'توصيف الحالة (أرملة، مطلقة، مريض...)',
                      controller: _caseDescriptionController,
                      validator: (v) => ValidationUtils.validateRequired(
                        v,
                        fieldName: 'توصيف الحالة',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'أفراد الأسرة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: _addFamilyMember,
                          icon: const Icon(Icons.add_circle),
                        ),
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
                          subtitle: Text(
                            '${member.profession} - ${member.age} سنة',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                setState(() => _familyMembers.removeAt(index)),
                          ),
                        );
                      },
                    ),
                    CustomTextFormField(
                      label: 'عدد الأفراد في بطاقة التموين',
                      controller: _rationCardCountController,
                      keyboardType: TextInputType.number,
                      validator: (v) => ValidationUtils.validatePositiveNumber(
                        v,
                        required: true,
                      ),
                    ),
                    CustomTextFormField(
                      label: 'عدد الحاصلين على معاش',
                      controller: _pensionCountController,
                      keyboardType: TextInputType.number,
                      validator: ValidationUtils.validatePositiveNumber,
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: const Text('المصروفات الشهرية'),
              content: Form(
                key: _expensesFormKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      label: 'إيجار',
                      controller: _rentController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          ValidationUtils.validateAmount(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'كهرباء',
                      controller: _electricityController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          ValidationUtils.validateAmount(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'مياه',
                      controller: _waterController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          ValidationUtils.validateAmount(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'غاز',
                      controller: _gasController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          ValidationUtils.validateAmount(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'تعليم',
                      controller: _educationController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          ValidationUtils.validateAmount(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'علاج',
                      controller: _treatmentController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          ValidationUtils.validateAmount(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'سداد ديون',
                      controller: _debtController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          ValidationUtils.validateAmount(v, required: true),
                    ),
                    CustomTextFormField(
                      label: 'أخرى',
                      controller: _otherExpensesController,
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          ValidationUtils.validateAmount(v, required: true),
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 3,
            ),
            Step(
              title: const Text('تأكيد'),
              content: const Text('هل أنت متأكد من حفظ التعديلات؟'),
              isActive: _currentStep >= 4,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    final applicant = admin_person.PersonModel(
      name: _nameController.text,
      nationalId: _nationalIdController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      profession: _professionController.text,
      income: double.tryParse(_incomeController.text) ?? 0,
      phone: _phoneController.text,
      address: _addressController.text,
    );

    final spouse = _hasSpouse
        ? admin_person.PersonModel(
            name: _spouseNameController.text,
            nationalId: _spouseNationalIdController.text,
            age: int.tryParse(_spouseAgeController.text) ?? 0,
            profession: _spouseProfessionController.text,
            income: double.tryParse(_spouseIncomeController.text) ?? 0,
            phone: _spousePhoneController.text,
          )
        : null;

    final expenses = admin_expenses.ExpensesModel(
      rent: double.tryParse(_rentController.text) ?? 0,
      electricity: double.tryParse(_electricityController.text) ?? 0,
      water: double.tryParse(_waterController.text) ?? 0,
      gas: double.tryParse(_gasController.text) ?? 0,
      education: double.tryParse(_educationController.text) ?? 0,
      treatment: double.tryParse(_treatmentController.text) ?? 0,
      debtRepayment: double.tryParse(_debtController.text) ?? 0,
      other: double.tryParse(_otherExpensesController.text) ?? 0,
    );

    final updatedCase = admin_model.CaseModel(
      id: widget.caseModel.id,
      applicant: applicant,
      spouse: spouse,
      caseDescription: _caseDescriptionController.text,
      familyMembers: _familyMembers,
      rationCardCount: int.tryParse(_rationCardCountController.text) ?? 0,
      pensionCount: int.tryParse(_pensionCountController.text) ?? 0,
      manualTotalFamilyIncome: widget.caseModel.manualTotalFamilyIncome,
      expenses: expenses,
      aidHistory: widget.caseModel.aidHistory
          .map(
            (a) => admin_aid.AidModel(
              type: admin_aid.AidType.values[a.type.index],
              value: a.value,
              date: a.date,
            ),
          )
          .toList(),
      createdAt: widget.caseModel.createdAt,
    );

    context.read<AdminCasesCubit>().updateCase(updatedCase);
  }
}
