import 'dart:convert';

import 'package:charity_app/core/helpers/cache_service.dart';
import 'package:charity_app/core/utils/validation_utils.dart';
import 'package:charity_app/core/widgets/custom_messages.dart';
import 'package:charity_app/core/widgets/custom_text_form_field.dart';
import 'package:charity_app/features/user/data/models/aid_model.dart';
import 'package:charity_app/features/user/data/models/case_model.dart';
import 'package:charity_app/features/user/data/models/expenses_model.dart';
import 'package:charity_app/features/user/data/models/person_model.dart';
import 'package:charity_app/features/user/presentation/cubit/user_cases_cubit.dart';
import 'package:charity_app/features/user/presentation/cubit/user_cases_state.dart';
import 'package:charity_app/features/user/presentation/widgets/progress_stepper.dart';
import 'package:charity_app/features/user/presentation/widgets/registration_steps/step_1_personal_info.dart';
import 'package:charity_app/features/user/presentation/widgets/registration_steps/step_2_spouse_info.dart';
import 'package:charity_app/features/user/presentation/widgets/registration_steps/step_3_family_info.dart';
import 'package:charity_app/features/user/presentation/widgets/registration_steps/step_4_housing_expenses.dart';
import 'package:charity_app/features/user/presentation/widgets/registration_steps/step_5_aid_history.dart';
import 'package:charity_app/features/user/presentation/widgets/wizard_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CaseRegistrationScreen extends StatefulWidget {
  const CaseRegistrationScreen({super.key});

  @override
  State<CaseRegistrationScreen> createState() => _CaseRegistrationScreenState();
}

class _CaseRegistrationScreenState extends State<CaseRegistrationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  // Separate keys for each step
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();
  final _step4Key = GlobalKey<FormState>();
  // final _step5Key = GlobalKey<FormState>(); // Unused

  // Controllers - Personal
  final _nameController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _ageController = TextEditingController();
  final _professionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _incomeController = TextEditingController();
  final _addressController = TextEditingController();

  // Controllers - Spouse
  bool _hasSpouse = false;
  final _spouseNameController = TextEditingController();
  final _spouseNationalIdController = TextEditingController();
  final _spouseAgeController = TextEditingController();
  final _spouseProfessionController = TextEditingController();
  final _spouseIncomeController = TextEditingController();
  final _spousePhoneController = TextEditingController();

  // Controllers - Family & Case
  final _caseDescriptionController = TextEditingController();
  final _rationCardCountController = TextEditingController();
  final _pensionCountController = TextEditingController();
  final List<PersonModel> _familyMembers = [];

  // Controllers - Expenses
  final _rentController = TextEditingController();
  final _electricityController = TextEditingController();
  final _waterController = TextEditingController();
  final _gasController = TextEditingController();
  final _educationController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _debtController = TextEditingController();
  final _otherExpensesController = TextEditingController();

  // Aid
  final List<AidModel> _aidHistory = [];

  @override
  void initState() {
    super.initState();
    _loadDraft();
    _setupListeners();
  }

  void _setupListeners() {
    final controllers = [
      _nameController,
      _nationalIdController,
      _ageController,
      _professionController,
      _incomeController,
      _phoneController,
      _addressController,
      _spouseNameController,
      _spouseNationalIdController,
      _spouseAgeController,
      _spouseProfessionController,
      _spouseIncomeController,
      _spousePhoneController,
      _caseDescriptionController,
      _rationCardCountController,
      _pensionCountController,
      _rentController,
      _electricityController,
      _waterController,
      _gasController,
      _educationController,
      _treatmentController,
      _debtController,
      _otherExpensesController,
    ];

    for (final controller in controllers) {
      controller.addListener(_saveDraft);
    }
  }

  Future<void> _saveDraft() async {
    final draftData = {
      'name': _nameController.text,
      'nationalId': _nationalIdController.text,
      'age': _ageController.text,
      'profession': _professionController.text,
      'income': _incomeController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'hasSpouse': _hasSpouse,
      'spouseName': _spouseNameController.text,
      'spouseNationalId': _spouseNationalIdController.text,
      'spouseAge': _spouseAgeController.text,
      'spouseProfession': _spouseProfessionController.text,
      'spouseIncome': _spouseIncomeController.text,
      'spousePhone': _spousePhoneController.text,
      'caseDescription': _caseDescriptionController.text,
      'rationCardCount': _rationCardCountController.text,
      'pensionCount': _pensionCountController.text,
      'rent': _rentController.text,
      'electricity': _electricityController.text,
      'water': _waterController.text,
      'gas': _gasController.text,
      'education': _educationController.text,
      'treatment': _treatmentController.text,
      'debt': _debtController.text,
      'otherExpenses': _otherExpensesController.text,
      'familyMembers': _familyMembers.map((e) => e.toJson()).toList(),
      'aidHistory': _aidHistory.map((e) => e.toJson()).toList(),
    };
    await CacheStorage.write('case_draft', jsonEncode(draftData));
  }

  Future<void> _loadDraft() async {
    final draftString = CacheStorage.read('case_draft') as String?;
    if (draftString != null) {
      try {
        final draftData = jsonDecode(draftString) as Map<String, dynamic>;
        setState(() {
          _nameController.text = draftData['name'] ?? '';
          _nationalIdController.text = draftData['nationalId'] ?? '';
          _ageController.text = draftData['age'] ?? '';
          _professionController.text = draftData['profession'] ?? '';
          _incomeController.text = draftData['income'] ?? '';
          _phoneController.text = draftData['phone'] ?? '';
          _addressController.text = draftData['address'] ?? '';
          _hasSpouse = draftData['hasSpouse'] ?? false;
          _spouseNameController.text = draftData['spouseName'] ?? '';
          _spouseNationalIdController.text =
              draftData['spouseNationalId'] ?? '';
          _spouseAgeController.text = draftData['spouseAge'] ?? '';
          _spouseProfessionController.text =
              draftData['spouseProfession'] ?? '';
          _spouseIncomeController.text = draftData['spouseIncome'] ?? '';
          _spousePhoneController.text = draftData['spousePhone'] ?? '';
          _caseDescriptionController.text = draftData['caseDescription'] ?? '';
          _rationCardCountController.text = draftData['rationCardCount'] ?? '';
          _pensionCountController.text = draftData['pensionCount'] ?? '';
          _rentController.text = draftData['rent'] ?? '';
          _electricityController.text = draftData['electricity'] ?? '';
          _waterController.text = draftData['water'] ?? '';
          _gasController.text = draftData['gas'] ?? '';
          _educationController.text = draftData['education'] ?? '';
          _treatmentController.text = draftData['treatment'] ?? '';
          _debtController.text = draftData['debt'] ?? '';
          _otherExpensesController.text = draftData['otherExpenses'] ?? '';

          if (draftData['familyMembers'] != null) {
            _familyMembers.clear();
            _familyMembers.addAll(
              (draftData['familyMembers'] as List)
                  .map((e) => PersonModel.fromJson(e))
                  .toList(),
            );
          }

          if (draftData['aidHistory'] != null) {
            _aidHistory.clear();
            _aidHistory.addAll(
              (draftData['aidHistory'] as List)
                  .map((e) => AidModel.fromJson(e))
                  .toList(),
            );
          }
        });
      } catch (e) {
        debugPrint('Error loading draft: $e');
      }
    }
  }

  Future<void> _clearDraft() async {
    await CacheStorage.delete('case_draft');
  }

  void _nextPage() {
    bool isValid = false;
    switch (_currentStep) {
      case 0:
        isValid = _step1Key.currentState!.validate();
        break;
      case 1:
        isValid = !_hasSpouse || _step2Key.currentState!.validate();
        break;
      case 2:
        isValid = _step3Key.currentState!.validate();
        break;
      case 3:
        isValid = _step4Key.currentState!.validate();
        break;
      case 4:
        isValid = true;
        break;
    }

    if (isValid) {
      if (_currentStep < _totalSteps - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() => _currentStep++);
      } else {
        _submitForm();
      }
    } else {
      MessageUtils.showError(
        'يرجى التأكد من ادخال البيانات المطلوبة بشكل صحيح',
      );
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  void _addFamilyMember() {
    final formKey = GlobalKey<FormState>();
    final nameC = TextEditingController();
    final ageC = TextEditingController();
    final jobC = TextEditingController();
    final incomeC = TextEditingController();
    final nidC = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
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
                    hasTextAbove: true,
                    hint: 'الاسم',
                    validator: ValidationUtils.validateName,
                  ),
                  CustomTextFormField(
                    label: 'الرقم القومي',
                    controller: nidC,
                    hasTextAbove: true,
                    hint: 'الرقم القومي',
                    keyboardType: TextInputType.number,
                    validator: ValidationUtils.validateNationalId,
                  ),
                  CustomTextFormField(
                    label: 'السن',
                    controller: ageC,
                    hasTextAbove: true,
                    hint: 'السن',
                    keyboardType: TextInputType.number,
                    validator: ValidationUtils.validateAge,
                  ),
                  CustomTextFormField(
                    label: 'المهنة',
                    controller: jobC,
                    hasTextAbove: true,
                    hint: 'المهنة',
                    validator: (v) => ValidationUtils.validateRequired(
                      v,
                      fieldName: 'المهنة',
                    ),
                  ),
                  CustomTextFormField(
                    label: 'الدخل',
                    controller: incomeC,
                    hasTextAbove: true,
                    hint: '0.0',
                    keyboardType: TextInputType.number,
                    validator: ValidationUtils.validateAmount,
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
                      PersonModel(
                        name: nameC.text,
                        nationalId: nidC.text,
                        age: int.tryParse(ageC.text) ?? 0,
                        profession: jobC.text,
                        income: double.tryParse(incomeC.text) ?? 0,
                        phone: '', // Phone optional for family members?
                      ),
                    );
                    _saveDraft();
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

  void _addAidRecord() {
    final formKey = GlobalKey<FormState>();
    AidType selectedType = AidType.cash;
    final valueC = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('إضافة مساعدة سابقة'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<AidType>(
                        initialValue: selectedType,
                        items: const [
                          DropdownMenuItem(
                            value: AidType.cash,
                            child: Text('نقدية'),
                          ),
                          DropdownMenuItem(
                            value: AidType.other,
                            child: Text('عينية'),
                          ),
                        ],
                        onChanged: (v) =>
                            setDialogState(() => selectedType = v!),
                        decoration: const InputDecoration(
                          labelText: 'نوع المساعدة',
                        ),
                      ),
                      SizedBox(height: 12.h),
                      CustomTextFormField(
                        label: 'القيمة / الوصف',
                        controller: valueC,
                        hasTextAbove: true,
                        hint: 'القيمة',
                        validator: ValidationUtils.validateRequired,
                      ),
                      ListTile(
                        title: const Text('التاريخ'),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd').format(selectedDate),
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (date != null)
                            setDialogState(() => selectedDate = date);
                        },
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
                        _aidHistory.add(
                          AidModel(
                            type: selectedType,
                            value: double.tryParse(valueC.text) ?? 0,
                            date: selectedDate,
                          ),
                        );
                        _saveDraft();
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
      },
    );
  }

  void _submitForm() {
    final applicant = PersonModel(
      name: _nameController.text,
      nationalId: _nationalIdController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      profession: _professionController.text,
      income: double.tryParse(_incomeController.text) ?? 0,
      phone: _phoneController.text,
      address: _addressController.text,
    );

    final spouse = _hasSpouse
        ? PersonModel(
            name: _spouseNameController.text,
            nationalId: _spouseNationalIdController.text,
            age: int.tryParse(_spouseAgeController.text) ?? 0,
            profession: _spouseProfessionController.text,
            income: double.tryParse(_spouseIncomeController.text) ?? 0,
            phone: _spousePhoneController.text,
          )
        : null;

    final expenses = ExpensesModel(
      rent: double.tryParse(_rentController.text) ?? 0,
      electricity: double.tryParse(_electricityController.text) ?? 0,
      water: double.tryParse(_waterController.text) ?? 0,
      gas: double.tryParse(_gasController.text) ?? 0,
      education: double.tryParse(_educationController.text) ?? 0,
      treatment: double.tryParse(_treatmentController.text) ?? 0,
      debtRepayment: double.tryParse(_debtController.text) ?? 0,
      other: double.tryParse(_otherExpensesController.text) ?? 0,
    );

    final caseEntity = CaseModel(
      id: '',
      applicant: applicant,
      spouse: spouse,
      caseDescription: _caseDescriptionController.text,
      familyMembers: _familyMembers,
      rationCardCount: int.tryParse(_rationCardCountController.text) ?? 0,
      pensionCount: int.tryParse(_pensionCountController.text) ?? 0,
      expenses: expenses,
      aidHistory: _aidHistory,
      createdAt: DateTime.now(),
    );

    context.read<UserCasesCubit>().addNewCase(caseEntity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل حالة جديدة'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocListener<UserCasesCubit, UserCasesState>(
        listener: (context, state) {
          if (state.status == UserCasesStatus.caseAdded) {
            MessageUtils.showSuccess('تم التسجيل بنجاح');
            _clearDraft();
            context.pop();
          } else if (state.status == UserCasesStatus.error) {
            MessageUtils.showError(state.errorMessage ?? ' حدث خطأ');
          }
        },
        child: Column(
          children: [
            ProgressStepper(currentStep: _currentStep, totalSteps: _totalSteps),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Step1PersonalInfo(
                    formKey: _step1Key,
                    nameController: _nameController,
                    nationalIdController: _nationalIdController,
                    ageController: _ageController,
                    phoneController: _phoneController,
                    jobController: _professionController,
                  ),
                  Step2SpouseInfo(
                    formKey: _step2Key,
                    hasSpouse: _hasSpouse,
                    onSpouseChanged: (val) {
                      setState(() => _hasSpouse = val);
                      _saveDraft();
                    },
                    nameController: _spouseNameController,
                    nationalIdController: _spouseNationalIdController,
                    ageController: _spouseAgeController,
                    professionController: _spouseProfessionController,
                    incomeController: _spouseIncomeController,
                    phoneController: _spousePhoneController,
                  ),
                  Step3FamilyCaseInfo(
                    formKey: _step3Key,
                    caseDescriptionController: _caseDescriptionController,
                    rationCardCountController: _rationCardCountController,
                    pensionCountController: _pensionCountController,
                    familyMembers: _familyMembers,
                    onAddMember: _addFamilyMember,
                    onDeleteMember: (index) {
                      setState(() => _familyMembers.removeAt(index));
                      _saveDraft();
                    },
                  ),
                  Step4Expenses(
                    formKey: _step4Key,
                    addressController: _addressController,
                    rentController: _rentController,
                    electricityController: _electricityController,
                    waterController: _waterController,
                    gasController: _gasController,
                    educationController: _educationController,
                    treatmentController: _treatmentController,
                    debtController: _debtController,
                    otherExpensesController: _otherExpensesController,
                  ),
                  Step5AidHistory(
                    aidHistory: _aidHistory,
                    onAddAid: _addAidRecord,
                    onDeleteAid: (index) {
                      setState(() => _aidHistory.removeAt(index));
                      _saveDraft();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: WizardNavigationBar(
        onNext: _nextPage,
        onBack: _prevPage,
        isLastStep: _currentStep == _totalSteps - 1,
        isFirstStep: _currentStep == 0,
      ),
    );
  }
}
