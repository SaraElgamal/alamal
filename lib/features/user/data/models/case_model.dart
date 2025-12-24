import 'package:equatable/equatable.dart';
import 'person_model.dart';
import 'expenses_model.dart';
import 'aid_model.dart';

class CaseModel extends Equatable {
  final String id;
  final PersonModel applicant;
  final PersonModel? spouse;
  final String caseDescription;
  final List<PersonModel> familyMembers;
  final int rationCardCount;
  final int pensionCount;
  final double manualTotalFamilyIncome;
  final ExpensesModel expenses;
  final List<AidModel> aidHistory;
  final DateTime createdAt;

  const CaseModel({
    required this.id,
    required this.applicant,
    this.spouse,
    required this.caseDescription,
    required this.familyMembers,
    required this.rationCardCount,
    required this.pensionCount,
    required this.manualTotalFamilyIncome,
    required this.expenses,
    required this.aidHistory,
    required this.createdAt,
  });

  double get calculatedTotalFamilyIncome {
    double total = applicant.income;
    if (spouse != null) {
      total += spouse!.income;
    }
    for (var member in familyMembers) {
      total += member.income;
    }
    return total;
  }

  factory CaseModel.fromJson(Map<String, dynamic> json, String id) {
    return CaseModel(
      id: id,
      applicant: PersonModel.fromJson(json['applicant']),
      spouse: json['spouse'] != null
          ? PersonModel.fromJson(json['spouse'])
          : null,
      caseDescription: json['caseDescription'] ?? '',
      familyMembers:
          (json['familyMembers'] as List<dynamic>?)
              ?.map((e) => PersonModel.fromJson(e))
              .toList() ??
          [],
      rationCardCount: json['rationCardCount'] ?? 0,
      pensionCount: json['pensionCount'] ?? 0,
      manualTotalFamilyIncome: (json['manualTotalFamilyIncome'] ?? 0.0)
          .toDouble(),
      expenses: ExpensesModel.fromJson(json['expenses'] ?? {}),
      aidHistory:
          (json['aidHistory'] as List<dynamic>?)
              ?.map((e) => AidModel.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicant': applicant.toJson(),
      'spouse': spouse?.toJson(),
      'caseDescription': caseDescription,
      'familyMembers': familyMembers.map((e) => e.toJson()).toList(),
      'rationCardCount': rationCardCount,
      'pensionCount': pensionCount,
      'manualTotalFamilyIncome': manualTotalFamilyIncome,
      'expenses': expenses.toJson(),
      'aidHistory': aidHistory.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    applicant,
    spouse,
    caseDescription,
    familyMembers,
    rationCardCount,
    pensionCount,
    manualTotalFamilyIncome,
    expenses,
    aidHistory,
    createdAt,
  ];
}
