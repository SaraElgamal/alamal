import '../../domain/entities/case_entity.dart';
import '../../domain/entities/person_entity.dart';
import 'person_model.dart';
import 'expenses_model.dart';
import 'aid_model.dart';

class CaseModel extends CaseEntity {
  const CaseModel({
    required super.id,
    required super.applicant,
    super.spouse,
    required super.caseDescription,
    required super.familyMembers,
    required super.rationCardCount,
    required super.pensionCount,
    required super.expenses,
    required super.aidHistory,
    required super.createdAt,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json, String id) {
    return CaseModel(
      id: id,
      applicant: PersonModel.fromJson(json['applicant']),
      spouse: json['spouse'] != null ? PersonModel.fromJson(json['spouse']) : null,
      caseDescription: json['caseDescription'] ?? '',
      familyMembers: (json['familyMembers'] as List<dynamic>?)
              ?.map((e) => PersonModel.fromJson(e))
              .toList() ??
          [],
      rationCardCount: json['rationCardCount'] ?? 0,
      pensionCount: json['pensionCount'] ?? 0,
      expenses: ExpensesModel.fromJson(json['expenses'] ?? {}),
      aidHistory: (json['aidHistory'] as List<dynamic>?)
              ?.map((e) => AidModel.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicant': PersonModel.fromEntity(applicant).toJson(),
      'spouse': spouse != null ? PersonModel.fromEntity(spouse!).toJson() : null,
      'caseDescription': caseDescription,
      'familyMembers': familyMembers
          .map((e) => PersonModel.fromEntity(e).toJson())
          .toList(),
      'rationCardCount': rationCardCount,
      'pensionCount': pensionCount,
      'expenses': ExpensesModel.fromEntity(expenses).toJson(),
      'aidHistory': aidHistory
          .map((e) => AidModel.fromEntity(e).toJson())
          .toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CaseModel.fromEntity(CaseEntity entity) {
    return CaseModel(
      id: entity.id,
      applicant: entity.applicant,
      spouse: entity.spouse,
      caseDescription: entity.caseDescription,
      familyMembers: entity.familyMembers,
      rationCardCount: entity.rationCardCount,
      pensionCount: entity.pensionCount,
      expenses: entity.expenses,
      aidHistory: entity.aidHistory,
      createdAt: entity.createdAt,
    );
  }
}
